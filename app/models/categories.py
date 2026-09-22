import uuid
from config.db import db
from flask import Flask, render_template, jsonify, abort, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID
import datetime

class Products(db.Model):
    __tablename__ = 'products'
    __table_args__ = {'schema': 'content'}
    id = db.Column(UUID(as_uuid=True), primary_key= True, default=uuid.uuid4)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(150), unique=True)
    created = db.Column(db.DateTime(timezone=True))
    modified = db.Column(db.DateTime(timezone=True))
