
import base64
import json
import uuid
import jwt
import pytest

from app.extensions import db
from app.models import Customer, User
from tests.conftest import PASSWORD

def bearer(token):
    return {"Authorization": f"Bearer {token}"}

# ------------------------------------------------ REGISTER
def test_register_creates_a_user_and_rejects_duplicates(client):
    ok = client.post("/auth/register", json={
        "username": "nuevo",
        "password": "una-clave-larga"
    })

    assert ok.status_code == 201
    assert ok.get_json()["user"]["username"] == "nuevo"

    dup = client.post("/auth/register", json={
        "username": "nuevo",
        "password": "una-clave-larga"
    })

    assert dup.status_code == 409

@pytest.mark.parametrize("username, password, code", [
    ("ab", "una-clave-larga", "invalid_username"),
    ("con espacios", "una-clave-larga", "invalid_username"),
    ("valido", "corta", "weak_password"),
])
def test_register_validates_the_input(client, username, password, code):
    res = client.post("/auth/register", json={
        "username": username,
        "password": password
    })

    assert res.status_code == 400
    assert res.get_json()["code"] == code

def test_passwords_are_stored_hashed(app):
    user = User.query.filter_by(username="ana").first()

    assert user is not None
    assert user.password_hash != PASSWORD
    assert user.password_hash.startswith("scrypt:")

def test_a_new_user_can_log_in(client):
    client.post("/auth/register", json={
        "username": "nuevo",
        "password": "una-clave-larga"
    })

    res = client.post("/auth/login", json={
        "username": "nuevo",
        "password": "una-clave-larga"
    })

    assert res.status_code == 200
    assert res.get_json()["token_type"] == "Bearer"

# ------------------------------------------------ LOGIN

def test_login_returns_a_signed_jwt(app, token):
    payload = jwt.decode(
        token,
        app.config["JWT_SECRET_KEY"],
        algorithms=["HS256"],
        issuer=app.config["JWT_ISSUER"]
    )

    assert payload["username"] == "ana"
    assert payload["exp"] > payload["iat"]

def test_login_sets_no_cookie(client):
    res = client.post("/auth/login", json={
        "username": "ana",
        "password": PASSWORD
    })

    assert res.status_code == 200
    assert "Set-Cookie" not in res.headers

@pytest.mark.parametrize("username, password", [
    ("ana", "wrong-password"),
    ("nobody", PASSWORD)
])
def test_bad_credentials_get_the_same_401(client, username, password):
    res = client.post("/auth/login", json={
        "username": username,
        "password": password
    })

    assert res.status_code == 401
    assert res.get_json()["message"] == "Invalid username or password."

# ------------------------------------------------ JWT
@pytest.mark.parametrize("header, code", [
    (None, "authorization_header_missing"),
    ("   ", "authorization_header_missing"),
    ("Token abc", "invalid_header"),
    ("Bearer", "invalid_header"),
    ("Bearer a b", "invalid_header"),
    ("Bearer not.a.token", "invalid_token"),
])
def test_no_valid_token_no_access(client, header, code):
    headers = {} if header is None else {"Authorization": header}

    res = client.get("/api/customers", headers=headers)

    assert res.status_code == 401
    assert res.get_json()["code"] == code

def test_a_token_in_a_cookie_is_ignored(client, token):
    client.set_cookie("access_token", token)

    res = client.get("/api/customers")

    assert res.status_code == 401
    assert res.get_json()["code"] == "authorization_header_missing"

def test_expired_token_is_rejected(app, client, monkeypatch):
    monkeypatch.setitem(app.config, "JWT_EXPIRES_MINUTES", -1)

    res = client.post("/auth/login", json={
        "username": "ana",
        "password": PASSWORD
    })

    expired = res.get_json()["access_token"]

    res = client.get("/api/customers", headers=bearer(expired))

    assert res.status_code == 401
    assert res.get_json()["code"] == "token_expired"

def test_tampered_payload_is_rejected(client, token):
    header, payload, signature = token.split(".")

    data = json.loads(base64.urlsafe_b64decode(payload + "=="))
    data["sub"] = "999"

    forged = base64.urlsafe_b64encode(
        json.dumps(data).encode()
    ).decode().rstrip("=")

    res = client.get(
        "/api/customers",
        headers=bearer(f"{header}.{forged}.{signature}")
    )

    assert res.status_code == 401

def test_alg_none_token_is_rejected(client):
    unsigned = jwt.encode(
        {"sub": "1", "username": "ana"},
        key=None,
        algorithm="none"
    )

    res = client.get("/api/customers", headers=bearer(unsigned))

    assert res.status_code == 401

# ------------------------------------------------ API CLIENTES

def test_api_create_and_list(client, token):
    res = client.post("/api/customers", json={
        "first_name": "Juan",
        "last_name": "Perez",
        "email": "juan@test.com",
        "phone": "70000000"
    }, headers=bearer(token))

    assert res.status_code == 201
    assert res.get_json()["cliente"]["first_name"] == "Juan"

    res = client.get("/api/customers", headers=bearer(token))

    assert res.status_code == 200

    nombres = [c["first_name"] for c in res.get_json()["clientes"]]
    assert "Juan" in nombres

def test_api_patch_customer(client, token):
    customer = Customer(
        first_name="Maria",
        last_name="Lopez",
        email="maria@test.com",
        phone="71111111"
    )

    db.session.add(customer)
    db.session.commit()

    res = client.patch(
        f"/api/customers/{customer.id}",
        json={
            "first_name": "Mariana",
            "phone": "72222222"
        },
        headers=bearer(token)
    )

    assert res.status_code == 200

    cliente = res.get_json()["cliente"]

    assert cliente["first_name"] == "Mariana"
    assert cliente["phone"] == "72222222"
    assert cliente["last_name"] == "Lopez"

def test_api_delete_customer(client, token):
    customer = Customer(
        first_name="Pedro",
        last_name="Gomez",
        email="pedro@test.com",
        phone="73333333"
    )

    db.session.add(customer)
    db.session.commit()

    customer_id = customer.id

    res = client.delete(
        f"/api/customers/{customer_id}",
        headers=bearer(token)
    )

    assert res.status_code == 200
    assert db.session.get(Customer, customer_id) is None

def test_api_missing_customer_is_a_json_404(client, token):
    missing_id = uuid.uuid4()

    res = client.delete(
        f"/api/customers/{missing_id}",
        headers=bearer(token)
    )

    assert res.status_code == 404
    assert res.get_json()["code"] == "not_found"

def test_api_create_customer_requires_fields(client, token):
    res = client.post("/api/customers", json={
        "first_name": "Juan"
    }, headers=bearer(token))

    assert res.status_code == 400
    assert res.get_json()["code"] == "missing_fields"

# ------------------------------------------------ API MESAS

def test_api_list_tables(client, token):
    res = client.get("/api/tables", headers=bearer(token))

    assert res.status_code == 200
    assert res.get_json()["success"] is True
    assert "mesas" in res.get_json()

# ------------------------------------------------ PAGINA

def test_page_is_a_public_shell_without_data(client):
    res = client.get("/")

    assert res.status_code == 200

    page = res.get_data(as_text=True)

    assert "login-form" in page
    assert "customers-view" in page
    assert "customer-list" in page
