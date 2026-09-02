import uuid
from config.db import db
from flask import Flask, render_template, jsonify, abort, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID
import datetime

class Reservations(db.Model):
    __tablename__ = 'reservations'
    __table_args__ = {'schema': 'content'}
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    customer_id = db.Column(UUID(as_uuid=True), db.ForeignKey('content.customers.id'), nullable=False)
    table_id = db.Column(UUID(as_uuid=True), db.ForeignKey('content.tables.id'), nullable=False)
    reservation_time = db.Column(db.DateTime(timezone=True), nullable=False)
    status = db.Column(db.String(30), nullable=False)
    created = db.Column(db.DateTime(timezone=True), nullable=False)
    modified= db.Column(db.DateTime(timezone=True), nullable=False)

    customer = db.relationship('Customer', back_populates='reservations')
    tables = db.relationship('Tables', back_populates='reservations')