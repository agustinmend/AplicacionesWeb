
from flask import Blueprint, jsonify, request
from sqlalchemy.exc import IntegrityError
from auth.decorators import requires_auth
from auth.routes import json_error
from extensions import db
from models import Customer, Tables

bp = Blueprint("api", __name__, url_prefix="/api")


# API PRINCIPAL

@bp.get("/")
@requires_auth
def hello_world(payload):
    return jsonify({
        "success": True,
        "message": "API del restaurante",
        "user": payload["username"]
    })

# LISTAR CLIENTES

@bp.get("/customers")
@requires_auth
def get_customers(payload):
    customers = Customer.query.all()

    return jsonify({
        "success": True,
        "total": len(customers),
        "clientes": [c.format() for c in customers]
    })

# CONTAR CLIENTES

@bp.get("/customers/length")
@requires_auth
def count_customers(payload):
    quantity = Customer.query.count()

    return jsonify({
        "success": True,
        "clientes_registrados": quantity
    })


# OBTENER CLIENTE POR ID

@bp.get("/customers/<uuid:person_id>")
@requires_auth
def get_customer_by_id(payload, person_id):
    customer = db.get_or_404(Customer, person_id)

    return jsonify({
        "success": True,
        "cliente": customer.format()
    })

# CREAR CLIENTE

@bp.post("/customers")
@requires_auth
def create_customer(payload):
    data = request.get_json(silent=True) or {}

    first_name = str(data.get("first_name") or "").strip()
    last_name = str(data.get("last_name") or "").strip()
    phone = str(data.get("phone") or "").strip()
    email = data.get("email") or None

    if not first_name or not last_name or not phone:
        return json_error(
            400, "missing_fields",
            "Nombre, apellido y teléfono son obligatorios."
        )

    customer = Customer(
        first_name=first_name,
        last_name=last_name,
        email=email,
        phone=phone
    )

    try:
        db.session.add(customer)
        db.session.commit()

    except IntegrityError:
        db.session.rollback()
        return json_error(
            409, "customer_conflict",
            "No se pudo crear el cliente. El correo puede estar registrado."
        )

    return jsonify({
        "success": True,
        "cliente": customer.format()
    }), 201

# ACTUALIZAR CLIENTE

@bp.patch("/customers/<uuid:person_id>")
@requires_auth
def update_customer(payload, person_id):
    customer = db.get_or_404(Customer, person_id)
    data = request.get_json(silent=True) or {}

    if "first_name" in data:
        first_name = str(data["first_name"] or "").strip()
        if not first_name:
            return json_error(400, "invalid_name", "El nombre es obligatorio.")
        customer.first_name = first_name

    if "last_name" in data:
        last_name = str(data["last_name"] or "").strip()
        if not last_name:
            return json_error(400, "invalid_last_name", "El apellido es obligatorio.")
        customer.last_name = last_name

    if "email" in data:
        customer.email = data["email"] or None

    if "phone" in data:
        phone = str(data["phone"] or "").strip()
        if not phone:
            return json_error(400, "invalid_phone", "El teléfono es obligatorio.")
        customer.phone = phone

    try:
        db.session.commit()

    except IntegrityError:
        db.session.rollback()
        return json_error(
            409, "customer_conflict",
            "No se pudo actualizar el cliente. El correo puede estar registrado."
        )

    return jsonify({
        "success": True,
        "cliente": customer.format()
    })


# ELIMINAR CLIENTE

@bp.delete("/customers/<uuid:person_id>")
@requires_auth
def delete_customer(payload, person_id):
    customer = db.get_or_404(Customer, person_id)

    try:
        db.session.delete(customer)
        db.session.commit()

    except IntegrityError:
        db.session.rollback()
        return json_error(
            409, "customer_in_use",
            "No se puede eliminar el cliente porque tiene registros asociados."
        )

    return jsonify({
        "success": True,
        "deleted": str(person_id)
    })


# LISTAR MESAS

@bp.get("/tables")
@requires_auth
def get_tables(payload):
    tables = Tables.query.all()

    return jsonify({
        "success": True,
        "total": len(tables),
        "mesas": [t.format() for t in tables]
    })


# ERROR 404

@bp.errorhandler(404)
def not_found(error):
    return json_error(404, "not_found", "Recurso no encontrado.")
