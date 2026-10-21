from decimal import Decimal
from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator

# RESTAURANTE
class Restaurante(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=120)
    ciudad = models.CharField(max_length=80)
    direccion = models.CharField(max_length=200, blank=True)
    telefono = models.CharField(max_length=30, blank=True)

    class Meta:
        db_table = "content\".\"restaurantes"
        verbose_name = "Restaurante"
        verbose_name_plural = "Restaurantes"

    def __str__(self):
        return self.nombre

# PLATO
class Plato(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=120)

    precio = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(Decimal("0.01"))]
    )

    disponible = models.BooleanField(default=True)

    restaurante = models.ForeignKey(
        Restaurante,
        on_delete=models.CASCADE,
        related_name="platos"
    )

    class Meta:
        db_table = "content\".\"platos"
        verbose_name = "Plato"
        verbose_name_plural = "Platos"

        constraints = [
            models.CheckConstraint(
                check=models.Q(precio__gt=0),
                name="plato_precio_positivo"
            )
        ]

    def __str__(self):
        return self.nombre


# PEDIDO
class Pedido(models.Model):
    class Estado(models.TextChoices):
        PENDIENTE = "pendiente", "Pendiente"
        EN_PREPARACION = "en_preparacion", "En preparación"
        LISTO = "listo", "Listo"
        ENTREGADO = "entregado", "Entregado"
        CANCELADO = "cancelado", "Cancelado"

    id = models.AutoField(primary_key=True)
    cliente = models.CharField(max_length=255, db_index=True)
    
    restaurante = models.ForeignKey(
        Restaurante,
        on_delete=models.CASCADE,
        related_name="pedidos"
    )

    estado = models.CharField(
        max_length=20,
        choices=Estado.choices,
        default=Estado.PENDIENTE
    )

    fecha = models.DateTimeField(auto_now_add=True)

    total = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        default=Decimal("0.00"),
        validators=[MinValueValidator(Decimal("0.00"))]
    )

    class Meta:
        db_table = "content\".\"pedidos"
        verbose_name = "Pedido"
        verbose_name_plural = "Pedidos"

        constraints = [
            models.CheckConstraint(
                check=models.Q(estado__in=[
                    "pendiente",
                    "en_preparacion",
                    "listo",
                    "entregado",
                    "cancelado"
                ]),
                name="pedido_estado_valido"
            ),
            models.CheckConstraint(
                check=models.Q(total__gte=0),
                name="pedido_total_no_negativo"
            )
        ]

    def __str__(self):
        return f"Pedido {self.id} - {self.estado}"


# ITEM PEDIDO

class ItemPedido(models.Model):
    id = models.AutoField(primary_key=True)

    pedido = models.ForeignKey(
        Pedido,
        on_delete=models.CASCADE,
        related_name="items"
    )

    plato = models.ForeignKey(
        Plato,
        on_delete=models.CASCADE
    )

    cantidad = models.IntegerField(
        validators=[
            MinValueValidator(1),
            MaxValueValidator(20)
        ]
    )

    precio_unitario = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(Decimal("0.00"))]
    )

    class Meta:
        db_table = "content\".\"items_pedido"
        verbose_name = "Ítem de pedido"
        verbose_name_plural = "Ítems de pedidos"

        constraints = [
            models.CheckConstraint(
                check=models.Q(cantidad__gte=1, cantidad__lte=20),
                name="item_cantidad_valida"
            ),
            models.CheckConstraint(
                check=models.Q(precio_unitario__gte=0),
                name="item_precio_no_negativo"
            )
        ]

    def __str__(self):
        return f"{self.cantidad} x {self.plato.nombre}"
