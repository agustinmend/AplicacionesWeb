from django.db import models
import uuid
from django.db import models
from django.core.validators import MinValueValidator
from django.utils.translation import gettext_lazy as _
# Create your models here.

class TimeStampedMixin(models.Model):
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)

    class Meta:
         abstract = True

class UUIDMixin(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    class Meta:
         abstract = True

class Category(UUIDMixin, TimeStampedMixin):
    name = models.CharField(_('name'), max_length=100)
    description = models.TextField(_('description'), blank=True)
    class Meta:
        db_table = "content\".\"categories"
        verbose_name = 'Categoria'
        verbose_name_plural = 'Categorias'

    def __str__(self):
        return self.name

class Customer(UUIDMixin, TimeStampedMixin):
    first_name = models.CharField(_('first_name'), max_length=100)
    last_name = models.CharField(_('last_name'), max_length=100)
    email = models.CharField(_('email'), max_length=150, unique=True)
    phone = models.CharField(_('phone'), max_length=20)

    class Meta:
        db_table = "content\".\"customers"
        verbose_name = 'Cliente'
        verbose_name_plural = 'Clientes'
    def __str__(self):
            return self.first_name + self.last_name
    
    

class Table(UUIDMixin, TimeStampedMixin):
    table_number = models.IntegerField(_('table number'), unique=True)
    capacity = models.IntegerField(_('capacity'), validators=[MinValueValidator(1)])
    is_active = models.BooleanField(_('is_Active'))

    class Meta:
        db_table = "content\".\"tables"
        verbose_name = 'mesa'
        verbose_name_plural = 'mesas'

    def __str__(self):
            return str(self.table_number)

class Reservations(UUIDMixin, TimeStampedMixin):
    class Status(models.TextChoices):
        PENDING = 'PENDING'
        CONFIRMED = 'CONFIRMED'
        CANCELLED = 'CANCELLED'
        COMPLETED = 'COMPLETED'

    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    table = models.ForeignKey(Table, on_delete=models.PROTECT)
    reservation_time = models.DateTimeField(_('reservation_time'))
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)

    class Meta:
        db_table = "content\".\"reservations"
        verbose_name = 'reservacion'
        verbose_name_plural = 'reservaciones'

    def __str__(self):
            return "reservacion: " + self.customer.first_name

class Product(UUIDMixin, TimeStampedMixin):
    category = models.ForeignKey(Category, on_delete=models.PROTECT)
    name = models.CharField(_('name'), max_length=150)
    description = models.TextField(_('description'), blank=True)
    current_price = models.DecimalField(_('currrent price'), max_digits=10, decimal_places=2, validators=[MinValueValidator(0)])
    is_available = models.BooleanField(_('is Available'))

    class Meta:
        db_table = "content\".\"products"
        verbose_name = 'producto'
        verbose_name_plural = 'productos'

    def __str__(self):
            return self.name

class Order(UUIDMixin, TimeStampedMixin):
    class Status(models.TextChoices):
        IN_PROGRESS = 'IN_PROGRESS'
        SERVED = 'SERVED'
        BILLED = 'BILLED'
        CANCELLED = 'CANCELLED'

    table = models.ForeignKey(Table, on_delete=models.PROTECT)
    customer = models.ForeignKey(Customer, on_delete=models.PROTECT, null=True, blank=True)
    status = models.CharField(max_length=30, choices=Status.choices, default=Status.IN_PROGRESS)
    total_amount = models.DecimalField(_('total amount'), max_digits=10, decimal_places=2, validators=[MinValueValidator(0.1)])
    products = models.ManyToManyField(Product, through='OrderItem')

    class Meta:
        db_table = "content\".\"orders"
        verbose_name = 'orden'
        verbose_name_plural = 'ordenes'

    def __str__(self):
            return str(self.id)

class OrderItem(UUIDMixin, TimeStampedMixin):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.PROTECT)
    quantity = models.IntegerField(_('quantity'), validators=[MinValueValidator(1)])
    unit_price = models.DecimalField(_('unit price'), max_digits=10, decimal_places=2)

    class Meta:
        db_table = "content\".\"order_items"
        verbose_name = 'detalle orden'
        verbose_name_plural = 'detalles ordenes'

class Payment(UUIDMixin, TimeStampedMixin):
    class PaymentMethod(models.TextChoices):
        CASH = 'CASH'
        CREDIT_CARD = 'CREDIT_CARD'
        QR = 'QR'
        OTHER = 'OTHER'

    class Status(models.TextChoices):
        PENDING = 'PENDING'
        COMPLETED = 'COMPLETED'
        FAILED = 'FAILED'

    order = models.ForeignKey(Order, on_delete=models.PROTECT)
    amount = models.DecimalField(_('amount'), max_digits=10, decimal_places=2)
    payment_method = models.CharField(_('payment method'), max_length=50, choices=PaymentMethod.choices)
    status = models.CharField(_('status'), max_length=30, choices=Status.choices, default=Status.PENDING)

    class Meta:
            db_table = "content\".\"payments"
            verbose_name = 'pago'
            verbose_name_plural = 'pagos'