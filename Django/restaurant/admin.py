from django.contrib import admin
from .models import Category, Customer, Reservations, Table, Order, OrderItem, Payment, Product
# Register your models here.

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    pass

@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    search_fields = ('first_name', 'last_name')

@admin.register(Reservations)
class ReservationAdmin(admin.ModelAdmin):
    pass

@admin.register(Table)
class TableAdmin(admin.ModelAdmin):
    pass

class OrderProductInline(admin.TabularInline):
    model = OrderItem

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    inlines = (OrderProductInline,)
    list_display = ('table', 'customer', 'status', 'total_amount', 'created')
    list_filter = ('status',)
    search_fields = ('table__table_number', 'customer__first_name', 'customer__last_name')

@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    pass

@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    pass

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    pass
