from decimal import Decimal, InvalidOperation

from flask import Blueprint, abort, flash, redirect, render_template, request, session, url_for
from sqlalchemy.exc import SQLAlchemyError

from .auth import requires_auth
from .extensions import db
from .models import Restaurante, Plato, Pedido, ItemPedido

bp = Blueprint("carta", __name__)

# CARTA PUBLICA
@bp.get("/")
def index():
    ciudad = request.args.get("ciudad", "").strip()
    consulta = Restaurante.query
    if ciudad:
        consulta = consulta.filter(Restaurante.ciudad.ilike(f"%{ciudad}%"))
    restaurantes = consulta.order_by(Restaurante.nombre).all()
    return render_template("index.html", restaurantes=restaurantes)


@bp.get("/restaurantes/<int:restaurante_id>")
def restaurante(restaurante_id):
    lugar = db.get_or_404(Restaurante, restaurante_id)
    return render_template("restaurantes/detalle.html", restaurante=lugar)


@bp.get("/restaurantes/<int:restaurante_id>/platos")
def platos(restaurante_id):
    restaurante = db.get_or_404(Restaurante, restaurante_id)
    platos = Plato.query.filter_by(
        restaurante_id=restaurante.id, disponible=True
    ).order_by(Plato.nombre).all()
    return render_template("platos/platos.html", restaurante=restaurante, platos=platos)


@bp.get("/platos/<int:plato_id>")
def detalle_plato(plato_id):
    plato = db.get_or_404(Plato, plato_id)
    if not plato.disponible:
        abort(404)
    return render_template("platos/detalle.html", plato=plato)


# CLIENTE: PEDIDO DE VARIOS PLATOS POR HTML SIN JAVASCRIPT
@bp.post("/pedidos/crear")
@requires_auth("create:pedidos")
def crear_pedido(payload):
    try:
        restaurante_id = int(request.form.get("restaurante_id", ""))
    except ValueError:
        abort(400, "Restaurante invalido.")

    restaurante = db.get_or_404(Restaurante, restaurante_id)
    ids = request.form.getlist("plato_id")
    cantidades = request.form.getlist("cantidad")

    if len(ids) != len(cantidades) or not ids:
        abort(400, "Pedido invalido.")

    seleccion = {}
    ids_vistos = set()
    for id_texto, cantidad_texto in zip(ids, cantidades):
        try:
            plato_id = int(id_texto)
            cantidad = int(cantidad_texto)
        except ValueError:
            abort(400, "Los IDs y cantidades deben ser enteros.")

        if plato_id <= 0 or cantidad < 0 or cantidad > 20:
            abort(400, "La cantidad debe estar entre 0 y 20.")

        if plato_id in ids_vistos:
            abort(400, "No puedes repetir un plato.")
        ids_vistos.add(plato_id)

        if cantidad > 0:
            seleccion[plato_id] = cantidad

    if not seleccion:
        flash("Selecciona al menos un plato.", "error")
        return redirect(url_for("carta.platos", restaurante_id=restaurante.id), code=303)

    platos = Plato.query.filter(Plato.id.in_(seleccion.keys())).with_for_update().all()
    if len(platos) != len(seleccion):
        abort(400, "Uno de los platos no existe.")

    total = Decimal("0.00")
    detalles = []
    for plato in platos:
        if not plato.disponible or plato.restaurante_id != restaurante.id:
            abort(400, "Un plato no esta disponible o es de otro restaurante.")
        cantidad = seleccion[plato.id]
        total += plato.precio * cantidad
        detalles.append((plato.id, cantidad, plato.precio))

    try:
        pedido = Pedido(
            cliente=payload["sub"],
            restaurante_id=restaurante.id,
            estado="pendiente",
            total=total,
        )
        db.session.add(pedido)
        db.session.flush()
        for plato_id, cantidad, precio in detalles:
            db.session.add(ItemPedido(
                pedido_id=pedido.id,
                plato_id=plato_id,
                cantidad=cantidad,
                precio_unitario=precio,
            ))
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(500, "No se pudo guardar el pedido.")

    flash("Pedido creado correctamente.", "success")
    return redirect(url_for("carta.detalle_pedido", pedido_id=pedido.id), code=303)

# CLIENTE: SUS PEDIDOS
@bp.get("/mis-pedidos")
@requires_auth("read:mis-pedidos")
def mis_pedidos(payload):
    pedidos = Pedido.query.filter_by(
        cliente=payload["sub"]
    ).order_by(Pedido.id.desc()).all()

    items_por_pedido = {pedido.id: [] for pedido in pedidos}
    if pedidos:
        ids = [pedido.id for pedido in pedidos]
        items = ItemPedido.query.filter(ItemPedido.pedido_id.in_(ids)).all()
        for item in items:
            items_por_pedido[item.pedido_id].append(item)

    return render_template(
        "pedidos/mis_pedidos.html",
        pedidos=pedidos,
        items_por_pedido=items_por_pedido
    )


@bp.get("/pedidos/<int:pedido_id>")
@requires_auth("read:mis-pedidos")
def detalle_pedido(payload, pedido_id):
    pedido = Pedido.query.filter_by(id=pedido_id, cliente=payload["sub"]).first()
    if pedido is None:
        abort(404)
    items = ItemPedido.query.filter_by(pedido_id=pedido.id).all()
    return render_template("pedidos/detalle.html", pedido=pedido, items=items)


@bp.post("/mis-pedidos/<int:pedido_id>/cancelar")
@requires_auth("read:mis-pedidos")
def cancelar_pedido(payload, pedido_id):
    pedido = Pedido.query.filter_by(
        id=pedido_id, cliente=payload["sub"]
    ).with_for_update().first()
    if pedido is None:
        abort(404)
    if pedido.estado != "pendiente":
        db.session.rollback()
        flash("Solo puedes cancelar un pedido pendiente.", "error")
        return redirect(url_for("carta.detalle_pedido", pedido_id=pedido.id), code=303)
    pedido.estado = "cancelado"
    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(500, "No se pudo cancelar el pedido.")
    flash("Pedido cancelado.", "success")
    return redirect(url_for("carta.detalle_pedido", pedido_id=pedido.id), code=303)


# COCINA
@bp.get("/cocina")
@requires_auth("read:pedidos")
def cocina(payload):
    pedidos = Pedido.query.filter(
        Pedido.estado.in_(["pendiente", "en_preparacion", "listo"])
    ).order_by(Pedido.fecha.asc()).all()
    items_por_pedido = {pedido.id: [] for pedido in pedidos}
    if pedidos:
        ids = [pedido.id for pedido in pedidos]
        items = ItemPedido.query.filter(ItemPedido.pedido_id.in_(ids)).all()
        for item in items:
            items_por_pedido[item.pedido_id].append(item)

    return render_template(
        "cocina/cola.html", pedidos=pedidos,
        items_por_pedido=items_por_pedido
    )


@bp.post("/cocina/<int:pedido_id>/avanzar")
@requires_auth("update:pedidos")
def avanzar_pedido(payload, pedido_id):
    pedido = Pedido.query.filter_by(id=pedido_id).with_for_update().first()
    if pedido is None:
        abort(404)
    transiciones = {
        "pendiente": "en_preparacion",
        "en_preparacion": "listo",
        "listo": "entregado",
    }
    estado_visto = request.form.get("estado_actual")
    nuevo_estado = request.form.get("estado")
    if pedido.estado != estado_visto or nuevo_estado != transiciones.get(pedido.estado):
        db.session.rollback()
        abort(409, "Transicion de estado no permitida o modificada por otro usuario.")

    pedido.estado = nuevo_estado
    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(500, "No se pudo actualizar el estado.")
    flash("Estado actualizado.", "success")
    return redirect(url_for("carta.cocina"), code=303)


# ADMINISTRADOR: FORMULARIOS DE CARTA
@bp.get("/administracion")
@requires_auth("write:carta")
def administracion(payload):
    restaurantes = Restaurante.query.order_by(Restaurante.id).all()
    platos = Plato.query.order_by(Plato.id).all()
    return render_template("admin/carta.html", restaurantes=restaurantes, platos=platos)


@bp.post("/administracion/restaurantes/crear")
@requires_auth("write:carta")
def crear_restaurante(payload):
    nombre = request.form.get("nombre", "").strip()
    ciudad = request.form.get("ciudad", "").strip()
    direccion = request.form.get("direccion", "").strip()
    telefono = request.form.get("telefono", "").strip()
    if not nombre or len(nombre) > 120 or not ciudad or len(ciudad) > 80 or len(direccion) > 200 or len(telefono) > 30:
        abort(400, "Datos del restaurante invalidos.")
    db.session.add(Restaurante(nombre=nombre, ciudad=ciudad, direccion=direccion, telefono=telefono))
    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(500)
    flash("Restaurante creado.", "success")
    return redirect(url_for("carta.administracion"), code=303)


@bp.post("/administracion/restaurantes/<int:restaurante_id>/editar")
@requires_auth("write:carta")
def editar_restaurante(payload, restaurante_id):
    restaurante = db.get_or_404(Restaurante, restaurante_id)
    nombre = request.form.get("nombre", "").strip()
    ciudad = request.form.get("ciudad", "").strip()
    direccion = request.form.get("direccion", "").strip()
    telefono = request.form.get("telefono", "").strip()
    if not nombre or len(nombre) > 120 or not ciudad or len(ciudad) > 80 or len(direccion) > 200 or len(telefono) > 30:
        abort(400, "Datos del restaurante invalidos.")
    restaurante.nombre = nombre
    restaurante.ciudad = ciudad
    restaurante.direccion = direccion
    restaurante.telefono = telefono
    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(500)
    flash("Restaurante actualizado.", "success")
    return redirect(url_for("carta.administracion"), code=303)


@bp.post("/administracion/restaurantes/<int:restaurante_id>/eliminar")
@requires_auth("delete:carta")
def eliminar_restaurante(payload, restaurante_id):
    restaurante = db.get_or_404(Restaurante, restaurante_id)
    try:
        pedidos = Pedido.query.filter_by(restaurante_id=restaurante_id).all()
        ids_pedidos = [pedido.id for pedido in pedidos]
        if ids_pedidos:
            items = ItemPedido.query.filter(ItemPedido.pedido_id.in_(ids_pedidos)).all()
            for item in items:
                db.session.delete(item)
            db.session.flush()
        for pedido in pedidos:
            db.session.delete(pedido)
        db.session.flush()
        platos = Plato.query.filter_by(restaurante_id=restaurante_id).all()
        for plato in platos:
            db.session.delete(plato)
        db.session.flush()
        db.session.delete(restaurante)
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(409, "No se pudo eliminar el restaurante.")
    flash("Restaurante eliminado junto con sus registros asociados.", "success")
    return redirect(url_for("carta.administracion"), code=303)


@bp.post("/administracion/platos/crear")
@requires_auth("write:carta")
def crear_plato(payload):
    nombre = request.form.get("nombre", "").strip()
    disponible = request.form.get("disponible") == "on"
    try:
        restaurante_id = int(request.form.get("restaurante_id", ""))
        precio = Decimal(request.form.get("precio", ""))
    except (ValueError, InvalidOperation):
        abort(400, "Restaurante o precio invalido.")
    if not nombre or len(nombre) > 120 or not precio.is_finite() or precio <= 0 or precio > Decimal("99999999.99") or precio.as_tuple().exponent < -2:
        abort(400, "Nombre o precio invalido.")
    restaurante = db.session.get(Restaurante, restaurante_id)
    if restaurante is None:
        abort(404)
    db.session.add(Plato(nombre=nombre, precio=precio, disponible=disponible, restaurante_id=restaurante.id))
    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(500)
    flash("Plato creado.", "success")
    return redirect(url_for("carta.administracion"), code=303)


@bp.post("/administracion/platos/<int:plato_id>/editar")
@requires_auth("write:carta")
def editar_plato(payload, plato_id):
    plato = db.get_or_404(Plato, plato_id)
    nombre = request.form.get("nombre", "").strip()
    disponible = request.form.get("disponible") == "on"
    try:
        restaurante_id = int(request.form.get("restaurante_id", ""))
        precio = Decimal(request.form.get("precio", ""))
    except (ValueError, InvalidOperation):
        abort(400, "Restaurante o precio invalido.")
    if not nombre or len(nombre) > 120 or not precio.is_finite() or precio <= 0 or precio > Decimal("99999999.99") or precio.as_tuple().exponent < -2:
        abort(400, "Nombre o precio invalido.")
    if db.session.get(Restaurante, restaurante_id) is None:
        abort(404)
    if restaurante_id != plato.restaurante_id and ItemPedido.query.filter_by(plato_id=plato.id).first():
        abort(409, "No se puede mover un plato con historial de pedidos.")
    plato.nombre = nombre
    plato.precio = precio
    plato.disponible = disponible
    plato.restaurante_id = restaurante_id
    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(500)
    flash("Plato actualizado (sin modificar precios historicos).", "success")
    return redirect(url_for("carta.administracion"), code=303)


@bp.post("/administracion/platos/<int:plato_id>/eliminar")
@requires_auth("delete:carta")
def eliminar_plato(payload, plato_id):
    plato = db.get_or_404(Plato, plato_id)
    if ItemPedido.query.filter_by(plato_id=plato.id).first():
        flash("El plato ya figura en pedidos; puedes desactivarlo.", "error")
        return redirect(url_for("carta.administracion"), code=303)
    db.session.delete(plato)
    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        abort(500)
    flash("Plato eliminado.", "success")
    return redirect(url_for("carta.administracion"), code=303)
