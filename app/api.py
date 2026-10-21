from decimal import Decimal, InvalidOperation
from flask import Blueprint, jsonify, request, redirect, url_for
from sqlalchemy import delete, select
from .extensions import db
from .models import Restaurante, Plato, Pedido, ItemPedido
from .auth import requires_auth

bp = Blueprint("api", __name__, url_prefix="/api")
