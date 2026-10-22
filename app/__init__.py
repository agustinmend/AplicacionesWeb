from flask import Flask
from werkzeug.middleware.proxy_fix import ProxyFix
from .config import Config
from .extensions import db

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    for key in ("AUTH0_DOMAIN", "AUTH0_AUDIENCE", "AUTH0_CLIENT_ID", "AUTH0_CLIENT_SECRET"):
        if not app.config[key]:
            raise RuntimeError(f"{key} is not set. Copy .env.example to .env and fill in your Auth0 values.")
    if app.config["BEHIND_PROXY"]:
        app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1)
    
    db.init_app(app)

    from . import models
    from .auth import AuthError, current_user
    from .auth.handlers import handle_auth_error
    from .auth.oauth import init_auth0
    from .auth.routes import bp as auth_bp
    from .auth.tokens import jwks_client
    from .routes import bp as main_bp
    from .api import bp as api_bp
    
    init_auth0(app)
    app.extensions["auth0_jwks"] = jwks_client(app.config["AUTH0_DOMAIN"])
    
    app.register_blueprint(main_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(api_bp)
    
    app.register_error_handler(AuthError, handle_auth_error)

    @app.context_processor
    def inject_current_user():
        return {"current_user": current_user()}
    
    return app