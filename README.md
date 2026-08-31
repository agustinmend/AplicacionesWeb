# isw233-despliegue-mendoza
Se realizo comparacion de indices en los siguientes casos:
- columna created se obtuvo antes del indice:
```
                                             QUERY PLAN
----------------------------------------------------------------------------------------------------
 Seq Scan on customers  (cost=0.00..8.75 rows=1 width=82) (actual time=2.749..2.750 rows=0 loops=1)
   Filter: (created = '2026-01-01 00:00:00+00'::timestamp with time zone)
   Rows Removed by Filter: 300
 Planning Time: 268.982 ms
 Execution Time: 2.912 ms
(5 rows)
```
Despues del indice:
```
                                                           QUERY PLAN                                                   
---------------------------------------------------------------------------------------------------------------------------------
 Index Scan using customer_created_idx on customers  (cost=0.15..4.17 rows=1 width=82) (actual time=0.985..1.090 rows=0 loops=1)
   Index Cond: (created = '2026-01-01 00:00:00+00'::timestamp with time zone)
 Planning Time: 49.309 ms
 Execution Time: 2.682 ms
(4 rows)
```

como se puede observar hubo una mejora en comparacion al momento de realizar la busqueda en el tiempo de ejecucion hay una diferencia de 0.3 ms entre consultas lo cual es una diferencia que se va notando mas mientras la BD crece

- Tambien se vio la necesidad de crear un indice para la columna reservation_time en la tabla reservations debido a la alta demanda q va a tener esta columna al momento de filtrar reservaciones por hora la reserva u ordenarlas:
Sin indice:
```
                                               QUERY PLAN
--------------------------------------------------------------------------------------------------------
 Seq Scan on reservations  (cost=0.00..14.25 rows=1 width=81) (actual time=4.929..4.930 rows=0 loops=1)
   Filter: (reservation_time = '2026-01-01 00:00:00+00'::timestamp with time zone)
   Rows Removed by Filter: 500
 Planning Time: 46.160 ms
 Execution Time: 4.966 ms
(5 rows)

```
Con indice:
```
                                                                   QUERY PLAN                                           
-------------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using reservations_reservation_time_idx on reservations  (cost=0.27..8.29 rows=1 width=81) (actual time=1.853..1.855 rows=0 loops=1)
   Index Cond: (reservation_time = '2026-01-01 00:00:00+00'::timestamp with time zone)
 Planning Time: 7.763 ms
 Execution Time: 1.875 ms
(4 rows)
```
se puede observar que el tiempo de ejecucion bajo drasticamente de 4.966 a 1.875 ms

- Tambien se vio la necesidad de crear un indice en la columna created en la tabla orders debido a que para la administracion va a ser muy comun la realizacion y manejo de sus ordenes por determinados rangos de tiempo como semanas, dias, etc.
Sin indices:
```
                                             QUERY PLAN
----------------------------------------------------------------------------------------------------
 Seq Scan on orders  (cost=0.00..31.00 rows=1 width=79) (actual time=25.382..25.383 rows=0 loops=1)
   Filter: (created = '2026-01-01 00:00:00+00'::timestamp with time zone)
   Rows Removed by Filter: 800
 Planning Time: 68.841 ms
 Execution Time: 25.645 ms
(5 rows)
```
Con indices:

```
                                                         QUERY PLAN                                                     
----------------------------------------------------------------------------------------------------------------------------
 Index Scan using orders_created_idx on orders  (cost=0.15..4.17 rows=1 width=79) (actual time=1.119..1.120 rows=0 loops=1)
   Index Cond: (created = '2026-01-01 00:00:00+00'::timestamp with time zone)
 Planning Time: 7.778 ms
 Execution Time: 1.150 ms
(4 rows)
```

En este caso tambien se logra apreciar una enorme baja en el tiempo de ejecucion siendo la consulta sin indices ejecutada en un tiempo de 25.0645ms mientras que al aplicar indices esta misma consulta bajo a 1.150ms