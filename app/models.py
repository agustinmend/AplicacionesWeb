from datetime import datetime, timezone
from .extensions import db

# RESTAURANTE
class Restaurante(db.Model):
    __tablename__ = "restaurantes"
    __table_args__ = {"schema": "content"}

    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(120), nullable=False)
    ciudad = db.Column(db.String(80), nullable=False)
    direccion = db.Column(db.String(200), nullable=False, default="")
    telefono = db.Column(db.String(30), nullable=False, default="")

    platos = db.relationship("Plato", back_populates="restaurante")
    pedidos = db.relationship("Pedido", back_populates="restaurante")

    def format(self):
        return {
            "id": self.id,
            "nombre": self.nombre,
            "ciudad": self.ciudad,
            "direccion": self.direccion,
            "telefono": self.telefono
        }

# PLATO
class Plato(db.Model):
    __tablename__ = "platos"
    __table_args__ = {"schema": "content"}

    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(120), nullable=False)
    precio = db.Column(db.Numeric(10, 2), nullable=False)
    disponible = db.Column(db.Boolean, nullable=False, default=True)

    restaurante_id = db.Column(
        db.Integer,
        db.ForeignKey("content.restaurantes.id"),
        nullable=False
    )

    restaurante = db.relationship("Restaurante", back_populates="platos")
    items = db.relationship("ItemPedido", back_populates="plato")

    def format(self):
        return {
            "id": self.id,
            "nombre": self.nombre,
            "precio": str(self.precio),
            "disponible": self.disponible,
            "restaurante_id": self.restaurante_id
        }

# PEDIDO
class Pedido(db.Model):
    __tablename__ = "pedidos"
    __table_args__ = {"schema": "content"}

    PENDIENTE = "pendiente"
    EN_PREPARACION = "en_preparacion"
    LISTO = "listo"
    ENTREGADO = "entregado"
    CANCELADO = "cancelado"

    id = db.Column(db.Integer, primary_key=True)

    # Identificador sub de Auth0
    cliente = db.Column(db.String(255), nullable=False, index=True)

    restaurante_id = db.Column(
        db.Integer,
        db.ForeignKey("content.restaurantes.id"),
        nullable=False
    )

    estado = db.Column(
        db.String(20),
        nullable=False,
        default=PENDIENTE
    )

    fecha = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc)
    )

    total = db.Column(db.Numeric(10, 2), nullable=False, default=0)

    restaurante = db.relationship("Restaurante", back_populates="pedidos")
    items = db.relationship("ItemPedido", back_populates="pedido")

    def format(self):
        return {
            "id": self.id,
            "cliente": self.cliente,
            "restaurante_id": self.restaurante_id,
            "estado": self.estado,
            "fecha": self.fecha.isoformat() if self.fecha else None,
            "total": str(self.total),
            "items": [item.format() for item in self.items]
        }

# ITEM PEDIDO

class ItemPedido(db.Model):
    __tablename__ = "items_pedido"
    __table_args__ = {"schema": "content"}

    id = db.Column(db.Integer, primary_key=True)

    pedido_id = db.Column(
        db.Integer,
        db.ForeignKey("content.pedidos.id"),
        nullable=False
    )

    plato_id = db.Column(
        db.Integer,
        db.ForeignKey("content.platos.id"),
        nullable=False
    )

    cantidad = db.Column(db.Integer, nullable=False)
    precio_unitario = db.Column(db.Numeric(10, 2), nullable=False)

    pedido = db.relationship("Pedido", back_populates="items")
    plato = db.relationship("Plato", back_populates="items")

    def format(self):
        return {
            "id": self.id,
            "pedido_id": self.pedido_id,
            "plato_id": self.plato_id,
            "cantidad": self.cantidad,
            "precio_unitario": str(self.precio_unitario)
        }
