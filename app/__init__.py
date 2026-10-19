from flask import Flask
from config import Config
from extensions import db, migrate

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    if len(app.config["JWT_SECRET_KEY"].encode()) < 32:
        raise RuntimeError("JWT_SECRET_KEY must be at least 32 bytes long.")
    
    db.init_app(app)
    migrate.init_app(app, db)
    
    import models  # noqa: F401  (registers the tables for migrations)
    from api import bp as api_bp
    from auth.errors import AuthError
    from auth.handlers import handle_auth_error
    from auth.routes import bp as auth_bp
    from routes import bp as todos_bp
    
    app.register_blueprint(todos_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(api_bp)

    app.register_error_handler(AuthError, handle_auth_error)
    
    return app