import uuid
from datetime import datetime, timezone
from werkzeug.security import check_password_hash, generate_password_hash
from sqlalchemy.dialects.postgresql import UUID
from .extensions import db

def utcnow():
    return datetime.now(timezone.utc)

class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), nullable=False, unique=True, index=True)
    # scrypt hash with a random salt: never the plain password
    password_hash = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime(timezone=True), nullable=False, default=utcnow)
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    @staticmethod
    def verify_hash(password_hash, password):
        return check_password_hash(password_hash, password)
    def __repr__(self):
        return f"<User {self.id} {self.username!r}>"

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

    reservations = db.relationship('Reservations', back_populates='customer')
    orders = db.relationship('Orders', back_populates='customer')

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
    orders = db.relationship('Orders', back_populates='table')

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

class Categories(db.Model):
    __tablename__ = 'categories'
    __table_args__ = {'schema': 'content'}

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.String(100), nullable=False, unique=True)
    description = db.Column(db.Text)
    created = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
    )
    modified = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
        onupdate=utcnow,
    )

    products = db.relationship('Products', back_populates='category')

    def __repr__(self):
        return f'<Category id={self.id} name={self.name}>'

    def format(self):
        return {
            'id': str(self.id),
            'name': self.name,
            'description': self.description,
        }


class Products(db.Model):
    __tablename__ = 'products'
    __table_args__ = {'schema': 'content'}

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    category_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('content.categories.id'),
        nullable=False
    )
    name = db.Column(db.String(150), nullable=False)
    description = db.Column(db.Text)
    current_price = db.Column(db.Numeric(10, 2), nullable=False)
    is_available = db.Column(db.Boolean, nullable=False, default=True)
    created = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
    )
    modified = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
        onupdate=utcnow,
    )

    category = db.relationship('Categories', back_populates='products')
    order_items = db.relationship('OrderItems', back_populates='product')

    def __repr__(self):
        return f'<Product id={self.id} name={self.name}>'

    def format(self):
        return {
            'id': str(self.id),
            'category_id': str(self.category_id),
            'name': self.name,
            'description': self.description,
            'current_price': str(self.current_price),
            'is_available': self.is_available,
        }


class Orders(db.Model):
    __tablename__ = 'orders'
    __table_args__ = {'schema': 'content'}

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    table_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('content.tables.id'),
        nullable=False
    )
    customer_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('content.customers.id'),
        nullable=True
    )
    status = db.Column(db.String(30), nullable=False, default='IN_PROGRESS')
    total_amount = db.Column(db.Numeric(10, 2), nullable=False, default=0.00)
    created = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
    )
    modified = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
        onupdate=utcnow,
    )

    table = db.relationship('Tables', back_populates='orders')
    customer = db.relationship('Customer', back_populates='orders')
    order_items = db.relationship('OrderItems', back_populates='order')
    payments = db.relationship('Payments', back_populates='order')

    def __repr__(self):
        return f'<Order id={self.id} status={self.status}>'

    def format(self):
        return {
            'id': str(self.id),
            'table_id': str(self.table_id),
            'customer_id': str(self.customer_id) if self.customer_id else None,
            'status': self.status,
            'total_amount': str(self.total_amount),
        }


class OrderItems(db.Model):
    __tablename__ = 'order_items'
    __table_args__ = {'schema': 'content'}

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('content.orders.id', ondelete='CASCADE'),
        nullable=False
    )
    product_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('content.products.id'),
        nullable=False
    )
    quantity = db.Column(db.Integer, nullable=False)
    unit_price = db.Column(db.Numeric(10, 2), nullable=False)
    created = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
    )
    modified = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
        onupdate=utcnow,
    )

    __table_args__ = (
        db.UniqueConstraint('order_id', 'product_id', name='uq_order_product'),
        {'schema': 'content'}
    )

    order = db.relationship('Orders', back_populates='order_items')
    product = db.relationship('Products', back_populates='order_items')

    def __repr__(self):
        return f'<OrderItem id={self.id} quantity={self.quantity}>'

    def format(self):
        return {
            'id': str(self.id),
            'order_id': str(self.order_id),
            'product_id': str(self.product_id),
            'quantity': self.quantity,
            'unit_price': str(self.unit_price),
        }


class Payments(db.Model):
    __tablename__ = 'payments'
    __table_args__ = {'schema': 'content'}

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('content.orders.id'),
        nullable=False
    )
    amount = db.Column(db.Numeric(10, 2), nullable=False)
    payment_method = db.Column(db.String(50), nullable=False)
    status = db.Column(db.String(30), nullable=False, default='PENDING')
    created = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
    )
    modified = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        default=utcnow,
        onupdate=utcnow,
    )

    order = db.relationship('Orders', back_populates='payments')

    def __repr__(self):
        return f'<Payment id={self.id} status={self.status}>'

    def format(self):
        return {
            'id': str(self.id),
            'order_id': str(self.order_id),
            'amount': str(self.amount),
            'payment_method': self.payment_method,
            'status': self.status,
        }
