
"""Pruebas locales con tokens Auth0 simulados, sin conectarse a Auth0."""

import json
import time
from datetime import datetime, timedelta, timezone

import jwt
import pytest
from cryptography.hazmat.primitives.asymmetric import rsa
from sqlalchemy import event

from app import create_app
from app.config import TestConfig
from app.extensions import db
from app.models import Restaurante, Plato, Pedido, ItemPedido


KID = "clave-prueba"
PRIVATE_KEY = rsa.generate_private_key(public_exponent=65537, key_size=2048)

CLIENTE = ["create:pedidos", "read:mis-pedidos"]
COCINA = ["read:pedidos", "update:pedidos"]
ADMIN = ["read:pedidos", "write:carta", "delete:carta"]


def jwks():
    clave = json.loads(
        jwt.algorithms.RSAAlgorithm.to_jwk(PRIVATE_KEY.public_key())
    )
    return {
        "keys": [{**clave, "kid": KID, "use": "sig", "alg": "RS256"}]
    }


@pytest.fixture
def app():
    app = create_app(TestConfig)
    app.config.update(TESTING=True)

    # Simular las claves públicas de Auth0.
    app.extensions["auth0_jwks"].fetch_data = lambda: jwks()

    dominio = app.config["AUTH0_DOMAIN"]

    # Evitar solicitudes reales de descubrimiento a Auth0.
    app.extensions[
        "authlib.integrations.flask_client"
    ].auth0.server_metadata.update({
        "issuer": f"https://{dominio}/",
        "authorization_endpoint": f"https://{dominio}/authorize",
        "token_endpoint": f"https://{dominio}/oauth/token",
        "jwks_uri": f"https://{dominio}/.well-known/jwks.json",
        "_loaded_at": time.time(),
    })

    with app.app_context():

        # Crear el esquema content solo en SQLite de pruebas.
        @event.listens_for(db.engine, "connect")
        def crear_schema_sqlite(conexion, registro):
            cursor = conexion.cursor()
            cursor.execute("ATTACH DATABASE ':memory:' AS content")
            cursor.close()

        # Asegurar que las conexiones usen el esquema temporal.
        db.engine.dispose()

        db.create_all()

        restaurante = Restaurante(
            nombre="Restaurante prueba",
            ciudad="Santa Cruz",
            direccion="",
            telefono=""
        )
        db.session.add(restaurante)
        db.session.flush()

        disponible = Plato(
            nombre="Hamburguesa",
            precio="35.00",
            disponible=True,
            restaurante_id=restaurante.id
        )

        otro = Plato(
            nombre="Jugo",
            precio="10.00",
            disponible=True,
            restaurante_id=restaurante.id
        )

        agotado = Plato(
            nombre="Agotado",
            precio="20.00",
            disponible=False,
            restaurante_id=restaurante.id
        )

        db.session.add_all([disponible, otro, agotado])
        db.session.flush()

        propio = Pedido(
            cliente="auth0|ana",
            restaurante_id=restaurante.id,
            estado="pendiente",
            total="35.00"
        )

        ajeno = Pedido(
            cliente="auth0|otro",
            restaurante_id=restaurante.id,
            estado="pendiente",
            total="35.00"
        )

        listo = Pedido(
            cliente="auth0|otro",
            restaurante_id=restaurante.id,
            estado="listo",
            total="10.00"
        )

        db.session.add_all([propio, ajeno, listo])
        db.session.flush()

        db.session.add_all([
            ItemPedido(
                pedido_id=propio.id,
                plato_id=disponible.id,
                cantidad=1,
                precio_unitario="35.00"
            ),
            ItemPedido(
                pedido_id=ajeno.id,
                plato_id=disponible.id,
                cantidad=1,
                precio_unitario="35.00"
            ),
            ItemPedido(
                pedido_id=listo.id,
                plato_id=otro.id,
                cantidad=1,
                precio_unitario="10.00"
            ),
        ])

        db.session.commit()

        yield app

        db.session.remove()
        db.drop_all()


@pytest.fixture
def client(app):
    return app.test_client()


@pytest.fixture
def make_token(app):
    def _make(
        permissions=CLIENTE,
        sub="auth0|ana",
        key=PRIVATE_KEY,
        algorithm="RS256",
        **claims
    ):
        ahora = datetime.now(timezone.utc)

        payload = {
            "iss": f"https://{app.config['AUTH0_DOMAIN']}/",
            "sub": sub,
            "aud": app.config["AUTH0_AUDIENCE"],
            "iat": ahora,
            "exp": ahora + timedelta(hours=1),
            **claims,
        }

        if permissions is not None:
            payload["permissions"] = permissions

        return jwt.encode(
            payload,
            key,
            algorithm=algorithm,
            headers={"kid": KID}
        )

    return _make


@pytest.fixture
def sign_in(client, make_token):
    def _sign_in(permissions=CLIENTE, sub="auth0|ana", **claims):
        with client.session_transaction() as sesion:
            sesion["access_token"] = make_token(
                permissions=permissions,
                sub=sub,
                **claims
            )
            sesion["user"] = {
                "name": "Ana",
                "email": "ana@example.com"
            }

    return _sign_in
