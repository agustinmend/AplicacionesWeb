import os
import uuid
from models.customer import Customer
from models.table import Tables
from models.reservation import Reservations
from flask import Flask, render_template, jsonify, abort, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID
from config.db import db
import datetime

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://app:123qwe@localhost:5432/restaurant_database'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

@app.route('/customers', methods=['GET'])
def get_customers():
    customers = Customer.query.all()
    return jsonify({
        'success': True,
        'total': len(customers),
        'clientes': [c.format() for c in customers]
    })

@app.route('/customers/<uuid:person_id>', methods=['GET'])
def get_customer_by_id(person_id):
    customer = Customer.query.get(person_id)
    if customer is None:
        abort(404)
    return jsonify({'success':True, 'cliente': customer.format()})

@app.route('/tables', methods= ['GET'])
def get_tables():
    tables = Tables.query.all()
    return jsonify({
        'succes': True,
        'total': len(tables),
        'mesas': [t.format() for t in tables]        
    })

@app.route('/customers/length', methods= ['GET'])
def count_customers():
    quantity = Customer.query.count()
    return jsonify({'status': 'ok', 'clientes_registrados': quantity})

@app.errorhandler(404)
def no_encontrado(error):
    return jsonify({'succes': False, 'error': 404, 'mensaje': 'recurso no encontrado'}), 404

@app.route('/', methods=['GET'])
def hello_world():
    return "Hello wordl!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=False)