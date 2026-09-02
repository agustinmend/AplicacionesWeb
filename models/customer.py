import uuid
from config.db import db
from flask import Flask, render_template, jsonify, abort, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID
import datetime

class Customer(db.Model):
    __tablename__ = 'customers'
    __table_args__ = {'schema': 'content'}
    id = db.Column(UUID(as_uuid=True), primary_key= True, default=uuid.uuid4)
    first_name = db.Column(db.String(100), nullable=False)
    last_name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(150), unique=True)
    phone = db.Column(db.String(20), nullable=False)
    created = db.Column(db.DateTime(timezone=True))
    modified = db.Column(db.DateTime(timezone=True))

    reservations = db.relationship('Reservations', back_populates= 'customer')

    def __repr__(self):
        return f'<Customer id={self.id} first_name= {self.first_name}>'

    def format(self):
        return {
            'id': str(self.id),
            'first_name': self.first_name,
            'last_name': self.last_name,
            'email': self.email,
            'phone': self.phone,
        }