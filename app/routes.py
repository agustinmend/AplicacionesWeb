from flask import Blueprint, render_template, jsonify, abort, request, redirect, url_for
from extensions import db
from models import Customer, Tables, Reservations

bp = Blueprint("main", __name__)

@bp.route('/', methods=['GET'])
def hello_world():
    return "Hello wordl!"

@bp.route('/clientes', methods=['GET'])
def list_customers_view():
    customers = Customer.query.all()
    return render_template('customers/customers.html', clientes=customers)

@bp.route('/formulario', methods=['GET'])
def get_form():
    return render_template('customers/formulario.html')

@bp.route('/customer/editar/<uuid:person_id>', methods=['GET'])
def edit_form(person_id):
    customer = Customer.query.get(person_id)
    if customer is None:
        abort(404)
    return render_template('customers/editar.html', customer=customer)

@bp.route('/customer/update/<uuid:person_id>', methods=['POST'])
def update_customer(person_id):
    customer = Customer.query.get(person_id)
    if customer is None:
        abort(404)
    
    try:
        customer.first_name = request.form.get('first_name', customer.first_name)
        customer.last_name = request.form.get('last_name', customer.last_name)
        customer.email = request.form.get('email', customer.email)
        customer.phone = request.form.get('phone', customer.phone)
        
        db.session.commit()
        return redirect(url_for('main.list_customers_view'))
    except Exception as e:
        db.session.rollback()
        return f"Error al actualizar: {str(e)}", 500

@bp.route('/customer/delete/<uuid:person_id>', methods=['POST'])
def delete_customer(person_id):
    customer = Customer.query.get(person_id)
    if customer is None:
        abort(404)
        
    try:
        db.session.delete(customer)
        db.session.commit()
        return redirect(url_for('main.list_customers_view'))
    except Exception as e:
        db.session.rollback()
        return f"Error al eliminar: {str(e)}", 500

@bp.route('/customer/crear', methods=['POST'])
def create_customer():
    try:
        customer = Customer(
            first_name=request.form['first_name'],
            last_name=request.form['last_name'],
            email=request.form['email'],
            phone=request.form['phone']
        )
        db.session.add(customer)
        db.session.commit()
        return redirect(url_for('main.get_customer_by_id', person_id=customer.id))
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 400,
            'mensaje': 'Error al crear cliente',
            'detalles': str(e)
        }), 400

@bp.route('/customers', methods=['GET'])
def get_customers():
    customers = Customer.query.all()
    return jsonify({
        'success': True,
        'total': len(customers),
        'clientes': [c.format() for c in customers]
    })

@bp.route('/customers/<uuid:person_id>', methods=['GET'])
def get_customer_by_id(person_id):
    customer = Customer.query.get(person_id)
    if customer is None:
        abort(404)
    return jsonify({'success': True, 'cliente': customer.format()})

@bp.route('/tables', methods=['GET'])
def get_tables():
    tables = Tables.query.all()
    return jsonify({
        'succes': True,
        'total': len(tables),
        'mesas': [t.format() for t in tables]
    })

@bp.route('/customers/length', methods=['GET'])
def count_customers():
    quantity = Customer.query.count()
    return jsonify({'status': 'ok', 'clientes_registrados': quantity})

@bp.app_errorhandler(404)
def no_encontrado(error):
    return jsonify({'succes': False, 'error': 404, 'mensaje': 'recurso no encontrado'}), 404