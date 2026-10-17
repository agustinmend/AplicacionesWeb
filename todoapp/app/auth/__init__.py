from flask import Flask
from ..config import Config
from ..extensions import db, migrate
from .decorators import get_token_auth_header, requires_auth
from .errors import AuthError
from .tokens import create_acces_token, verify_decode_jwt

"""JWT authentication: register, login and a decorator that requires a valid token.
Follows the structure of the Identity and Access Management course:
AuthError              -> error with its HTTP status code
get_token_auth_header  -> reads "Authorization: Bearer <token>"
verify_decode_jwt      -> checks signature, expiry and issuer
requires_auth          -> decorator: no valid token, no access
Instead of Auth0, this app issues its own tokens in POST /auth/login. The
client sends them back in the Authorization header on every request; no
cookies are involved.
"""

__all__ = [
    "AuthError",
    "create_acces_token",
    "get_token_auth_header",
    "requires_auth",
    "verify_decode_jwt"
]

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    db.init_app(app)
    migrate.init_app(app, db)

    from .. import models
    from .routes import bp as todos_bp
    app.register_blueprint(todos_bp)

    from ..api import api_bp
    app.register_blueprint(api_bp, url_prefix="/api/v1")
    return app