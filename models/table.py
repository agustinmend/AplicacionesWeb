import uuid
from config.db import db
from flask import Flask, render_template, jsonify, abort, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID
import datetime

class Tables(db.Model):
    __tablename__ = 'tables'
    __table_args__ = {'schema': 'content'}
    id = db.Column(UUID(as_uuid=True), primary_key= True, default=uuid.uuid4)
    table_number = db.Column(db.Integer,  nullable=False)
    capacity = db.Column(db.Integer, nullable=False)
    is_active = db.Column(db.Boolean, nullable=False)
    created = db.Column(db.DateTime(timezone=True))
    modified = db.Column(db.DateTime(timezone=True))

    reservations = db.relationship('Reservations', back_populates='tables')

    def __repr__(self):
        return f'<Table id={self.id} table_number= {self.table_number}>'

    def format(self):
        return {
            'id': str(self.id),
            'table_number': self.table_number,
            'capacity': self.capacity,
            'is_active': self.is_active
        }
