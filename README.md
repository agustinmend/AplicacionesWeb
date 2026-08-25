# isw233-despliegue-mendoza
## Uso de IA
- elaboracion de css
- correccion de etiquetas html
- Explicacion de partes del documento
- Aclaracion de conceptos
- Encontrar donde colocar la llave en putty
- Explicacion de respuestas de terminal cuando se conecta con github y uso de llave
- Explicacion de error al instalar python, la IA me menciono que ubuntu ya venia con su python por defecto y q este tenia algunas restricciones y me sugirio usar entorno virtual lo cual acepte debido a q lo hemos visto un par de veces en clases
- Comando para crear entorno virtual y para conectarse
- Explicacion de debug=True y si afectaba al momento de desplegar
- Ayuda para matar proceso

## Levantamiento del servicor sin docker
- En primera no corrio sospecho del debuger active que me imprime la consola,
- Ahora funciona en mi maquina pero no el servidor
- Acabo de abrir ambos ssh uno donde corre el flask y el otro donde hace la solicitud con ambos comandos si hubo repuesta, ahora cuando coloco la direccion en el navegador no me carga lo cual supongo que puede ser que ambas maquinas ssh pertenecen a la mismar instancia y por eso es que si funcionan las peticiones, segun creo podria ser algo tipo como que falte habilitar el puerto
- el parametro en flask fue el de host a 0.0.0.0 debido a q si ponemos cualquier otro solo se va a escuchar a esa ip, pero al poner 0.0.0.0 estamos diciendo que escuche a todos

- El ssh en produccion deberia ser restringido solo a direcciones especificas q conocemos dado que si lo ponemos para todos cualquiera puede intentar conectarse y ya para todo publico tendria q haber una unica entrada q sea gestionada por un proxy inverso como ngnix

## Docker
- El COPY en el dockerfile copia los elementos de mi maquina local a el contenedor, en este caso al usar el . esta diciendo q copie todo los elementos que estan en la misma altura del dockerfile y los pegue en una carpeta /site/ dentro del contenedor, si tuviera un .pem en el directorio al no haber nada q me limite yo pienso que igual lo copiaria al contenedor lo cual no seria muy bueno q digamos, en el caso de los puertos a lo q yo tengo entendido el EXPOSE en Dockerfile es mas como documentacion no es que lo exponga por ende se seguiria escuchando en el 8000

- Al ejecutar el docker run y despues docker ps este no esta vivo, en los logs dice No module named flask, despues de un error que tuve con el dockerfile ahora si esta vivo

- Cuando se hace un cambio la pantalla en mi browser no se actualiza automaticamente, pero cuando se reinicia el contenedor sin reconstruir si se actualiza