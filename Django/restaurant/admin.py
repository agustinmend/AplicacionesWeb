from decimal import Decimal
from django.contrib import admin
from django.core.exceptions import ValidationError
from django.forms.models import BaseInlineFormSet
from .models import Restaurante, Plato, Pedido, ItemPedido

@admin.register(Restaurante)
class RestauranteAdmin(admin.ModelAdmin):
    list_display = ("id", "nombre", "ciudad", "telefono")
    list_filter = ("ciudad",)
    search_fields = ("nombre", "ciudad")

@admin.register(Plato)
class PlatoAdmin(admin.ModelAdmin):
    list_display = (
        "id", "nombre", "restaurante", "precio", "disponible"
    )
    list_filter = ("restaurante", "disponible")
    search_fields = ("nombre",)

class ItemPedidoFormSet(BaseInlineFormSet):

    def clean(self):
        super().clean()

        if any(self.errors):
            return

        for form in self.forms:
            data = form.cleaned_data

            if not data or data.get("DELETE"):
                continue

            plato = data.get("plato")

            if plato and plato.restaurante_id != self.instance.restaurante_id:
                raise ValidationError(
                    "El plato no pertenece al restaurante del pedido."
                )

class ItemPedidoInline(admin.TabularInline):
    model = ItemPedido
    formset = ItemPedidoFormSet

    fields = ("plato", "cantidad", "precio_unitario")
    readonly_fields = ("precio_unitario",)

    extra = 1
    min_num = 1
    validate_min = True

@admin.register(Pedido)
class PedidoAdmin(admin.ModelAdmin):
    list_display = (
        "id", "cliente", "restaurante",
        "estado", "fecha", "total"
    )

    list_filter = ("estado", "restaurante")
    search_fields = ("cliente",)

    readonly_fields = ("total", "fecha")
    inlines = (ItemPedidoInline,)

    def get_readonly_fields(self, request, obj=None):
        if request.user.is_superuser:
            return ("total", "fecha")

        return ("total", "fecha", "estado")

    def save_formset(self, request, form, formset, change):
        items = formset.save(commit=False)

        for item in formset.deleted_objects:
            item.delete()

        for item in items:
            if item.pk is None:
                item.precio_unitario = item.plato.precio
            else:
                anterior = ItemPedido.objects.get(pk=item.pk)

                if anterior.plato_id != item.plato_id:
                    item.precio_unitario = item.plato.precio

            item.save()

        formset.save_m2m()

    def save_related(self, request, form, formsets, change):
        super().save_related(request, form, formsets, change)

        pedido = form.instance
        total = Decimal("0.00")

        for item in pedido.items.all():
            total += item.cantidad * item.precio_unitario

        pedido.total = total
        pedido.save(update_fields=["total"])
