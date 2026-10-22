
from urllib.parse import parse_qs, urlparse

from app.auth.oauth import auth0
from tests.conftest import CLIENTE, COCINA, ADMIN


def test_carta_publica_sin_sesion(client):
    respuesta = client.get("/")
    assert respuesta.status_code == 200


def test_login_generar_redirect_auth0(client, app):
    respuesta = client.get("/auth/login?next=/mis-pedidos")

    assert respuesta.status_code == 302

    url = urlparse(respuesta.headers["Location"])
    params = parse_qs(url.query)

    assert url.netloc == app.config["AUTH0_DOMAIN"]
    assert url.path == "/authorize"

    assert params["audience"] == [app.config["AUTH0_AUDIENCE"]]
    assert params["client_id"] == [app.config["AUTH0_CLIENT_ID"]]
    assert params["response_type"] == ["code"]
    assert params["redirect_uri"] == ["http://localhost/auth/callback"]
    assert params["state"][0]

    with client.session_transaction() as sesion:
        assert sesion["next"] == "/mis-pedidos"


def test_callback_guarda_token(app, client, make_token, monkeypatch):
    token = make_token()

    with client.session_transaction() as sesion:
        sesion["next"] = "/mis-pedidos"

    with app.test_request_context():
        monkeypatch.setattr(
            type(auth0()),
            "authorize_access_token",
            lambda self, **kwargs: {
                "access_token": token,
                "userinfo": {"name": "Ana"}
            }
        )

    respuesta = client.get("/auth/callback?code=prueba&state=prueba")

    assert respuesta.status_code == 302
    assert respuesta.headers["Location"] == "/mis-pedidos"

    with client.session_transaction() as sesion:
        assert sesion["access_token"] == token


def test_cliente_no_accede_cocina(client, sign_in):
    sign_in(permissions=CLIENTE)
    assert client.get("/cocina").status_code == 403


def test_cocina_si_accede_cocina(client, sign_in):
    sign_in(permissions=COCINA)
    assert client.get("/cocina").status_code == 200


def test_admin_si_accede_administracion(client, sign_in):
    sign_in(permissions=ADMIN)
    assert client.get("/administracion").status_code == 200


def test_usuario_sin_rol_solo_carta(client, sign_in):
    sign_in(permissions=[])

    assert client.get("/").status_code == 200
    assert client.get("/mis-pedidos").status_code == 403
    assert client.get("/cocina").status_code == 403
    assert client.get("/administracion").status_code == 403


def test_logout_limpia_sesion(client, sign_in):
    sign_in()

    respuesta = client.post("/auth/logout")

    assert respuesta.status_code == 302

    with client.session_transaction() as sesion:
        assert "access_token" not in sesion
