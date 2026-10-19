from functools import wraps
from flask import request
from auth.errors import AuthError
from auth.tokens import verify_decode_jwt

def get_token_auth_header():
    """Return the raw JWT from `Authorization: Bearer <token>`.
    The header is the only place a token is accepted: there is no cookie
    fallback, so the browser never attaches it on its own.
    """
    auth = request.headers.get("Authorization", "").strip()
    if not auth:  # absent, empty or only spaces: split() would give []
        raise AuthError(
        {"code": "authorization_header_missing", "description": "Authorization header is expected."}, 401
    )
    parts = auth.split()
    if parts[0].lower() != "bearer":
        raise AuthError({"code": "invalid_header", "description": 'Authorization header must start with "Bearer".'}, 401)
    if len(parts) == 1:
        raise AuthError({"code": "invalid_header", "description": "Token not found."}, 401)
    if len(parts) > 2:
        raise AuthError({"code": "invalid_header", "description": 'Authorization header must be "Bearer <token>".'}, 401)
    return parts[1]

def requires_auth(f):
    """Decorator: `@requires_auth` on a route lets in only valid tokens.
    Two filters, in order: is there a token (401), is it valid (401). The
    decoded payload is passed to the view as its first argument, exactly
    like the course's first example.
    """
    @wraps(f)
    def wrapper(*args, **kwargs):
        token = get_token_auth_header()
        payload = verify_decode_jwt(token)
        return f(payload, *args, **kwargs)
    return wrapper
