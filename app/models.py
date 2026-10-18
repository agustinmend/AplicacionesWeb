import uuid
from datetime import datetime, timezone
from sqlalchemy.dialects.postgresql import UUID
from extensions import db

class Customer(db.Model):
    __tablename__ = 'customers'
    __table_args__ = {'schema': 'content'}

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    first_name = db.Column(db.String(100), nullable=False)
    last_name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(150), unique=True)
    phone = db.Column(db.String(20), nullable=False)
    created = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
    )
    modified = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    reservations = db.relationship('Reservations', back_populates='customer', cascade='all, delete-orphan')

    def __repr__(self):
        return f'<Customer id={self.id} first_name={self.first_name}>'

    def format(self):
        return {
            'id': str(self.id),
            'first_name': self.first_name,
            'last_name': self.last_name,
            'email': self.email,
            'phone': self.phone,
        }

class Tables(db.Model):
    __tablename__ = 'tables'
    __table_args__ = {'schema': 'content'}

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    table_number = db.Column(db.Integer, nullable=False, unique=True)
    capacity = db.Column(db.Integer, nullable=False)
    is_active = db.Column(db.Boolean, nullable=False, default=True)
    created = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
    )
    modified = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    reservations = db.relationship('Reservations', back_populates='tables')

    def __repr__(self):
        return f'<Table id={self.id} table_number={self.table_number}>'

    def format(self):
        return {
            'id': str(self.id),
            'table_number': self.table_number,
            'capacity': self.capacity,
            'is_active': self.is_active
        }

class Reservations(db.Model):
    __tablename__ = 'reservations'
    __table_args__ = {'schema': 'content'}

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    customer_id = db.Column(UUID(as_uuid=True), db.ForeignKey('content.customers.id'), nullable=False)
    table_id = db.Column(UUID(as_uuid=True), db.ForeignKey('content.tables.id'), nullable=False)
    reservation_time = db.Column(db.DateTime(timezone=True), nullable=False)
    status = db.Column(db.String(30), nullable=False, default='PENDING')
    created = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
    )
    modified = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    customer = db.relationship('Customer', back_populates='reservations')
    tables = db.relationship('Tables', back_populates='reservations')

    def format(self):
        return {
            'id': str(self.id),
            'customer_id': str(self.customer_id),
            'table_id': str(self.table_id),
            'reservation_time': self.reservation_time.isoformat() if self.reservation_time else None,
            'status': self.status
        }