
from decimal import Decimal

from app.extensions import db
from app.models import Pedido, ItemPedido
from tests.conftest import CLIENTE, COCINA


# 1. Sin sesión no puede crear pedidos.
def test_01_sin_sesion_no_crea_pedido(client, app):
    with app.app_context():
        antes = Pedido.query.count()

    respuesta = client.post("/pedidos/crear", data={
        "restaurante_id": "1",
        "plato_id": ["1"],
        "cantidad": ["2"]
    })

    assert respuesta.status_code in (302, 401)

    with app.app_context():
        assert Pedido.query.count() == antes


# 2. Cliente no puede actualizar pedidos desde cocina.
def test_02_cliente_no_puede_avanzar_estado(client, sign_in, app):
    sign_in(permissions=CLIENTE)

    respuesta = client.post("/cocina/1/avanzar", data={
        "estado_actual": "pendiente",
        "estado": "en_preparacion"
    })

    assert respuesta.status_code == 403

    with app.app_context():
        assert db.session.get(Pedido, 1).estado == "pendiente"


# 3. El precio enviado por el usuario se ignora.
def test_03_precio_inventado_se_ignora(client, sign_in, app):
    sign_in()

    respuesta = client.post("/pedidos/crear", data={
        "restaurante_id": "1",
        "plato_id": ["1", "2"],
        "cantidad": ["2", "1"],
        "precio": "1",
        "total": "1"
    })

    assert respuesta.status_code in (302, 303)

    with app.app_context():
        pedido = Pedido.query.order_by(Pedido.id.desc()).first()

        assert pedido.id > 3
        assert pedido.cliente == "auth0|ana"
        assert Decimal(str(pedido.total)) == Decimal("80.00")

        items = ItemPedido.query.filter_by(pedido_id=pedido.id).all()

        precios = [
            Decimal(str(item.precio_unitario))
            for item in items
        ]

        assert len(items) == 2
        assert sorted(precios) == [
            Decimal("10.00"),
            Decimal("35.00")
        ]


# 4. Un plato no disponible invalida el pedido completo.
def test_04_plato_no_disponible_no_deja_filas(client, sign_in, app):
    sign_in()

    with app.app_context():
        antes_pedidos = Pedido.query.count()
        antes_items = ItemPedido.query.count()

    respuesta = client.post("/pedidos/crear", data={
        "restaurante_id": "1",
        "plato_id": ["1", "3"],
        "cantidad": ["1", "1"]
    })

    assert respuesta.status_code in (302, 303, 400)

    with app.app_context():
        assert Pedido.query.count() == antes_pedidos
        assert ItemPedido.query.count() == antes_items


# 5. Cliente no puede ver un pedido ajeno.
def test_05_cliente_no_ve_pedido_ajeno(client, sign_in):
    sign_in(permissions=CLIENTE, sub="auth0|ana")

    respuesta = client.get("/pedidos/2")

    assert respuesta.status_code == 404


# 6. Cocina no puede retroceder el estado de un pedido.
def test_06_cocina_no_retrocede_de_listo_a_pendiente(
    client, sign_in, app
):
    sign_in(permissions=COCINA, sub="auth0|cocinero")

    respuesta = client.post("/cocina/3/avanzar", data={
        "estado_actual": "listo",
        "estado": "pendiente"
    })

    assert respuesta.status_code in (302, 303, 409)

    with app.app_context():
        assert db.session.get(Pedido, 3).estado == "listo"
