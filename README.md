# MaxFit
Utilización de la plataforma Salesforce para el manejo de una empresa destinada a la organización de eventos deportivos.

Poniendo en práctica los siguientes tópicos:
- Modelado de Datos
 	- Creación de Objectos y Campos
 	-  Reglas de validación
 	- Definición de relaciones
 	- Org-Wide Settings, Sharing Rules, Perfiles y Roles.

- Apex
	- 	Apex Triggers
	- Apex Scheduler
	- Queueable Apex
	- Batch Apex
	- Callouts a APIs Externas
	
- Lightning Web Component
	- Comunicación con eventos
	- Llamada a métodos Apex
	- Lightning Data Service
	- Navegación y campos por default
	- Toast Events


### Requerimiento #1
------------
Definir el **modelo de datos** para la organización, creando los objetos necesarios y definiendo los tipos de datos adecuados para sus campos. Para ello, se deben establecer las **relaciones correspondientes** entre los objetos, asegurando que la estructura de datos sea coherente y eficiente.
Además, se deben definir las **reglas de validación** necesarias para garantizar la integridad de los datos, evitando incongruencias y duplicaciones en la base de datos.
![data-model](https://user-images.githubusercontent.com/100447235/230621298-8ed2b509-d8bc-43f2-9941-8c8d74c3e665.png)

En cuanto al nivel de acceso y seguridad, se deben configurar los permisos y restricciones necesarios para proteger los datos y garantizar que solo los usuarios autorizados puedan acceder a ellos. Esto implica la creación de **perfiles** y** roles**, así como el uso de** Org-Wide Settings** y **Sharing Rules** para establecer las reglas de acceso adecuadas en función de los distintos niveles de seguridad requeridos.

### Requerimiento #2
------------
**Apex Class* TransactionLogHandler***
Es responsable de manejar y registrar excepciones en un objeto personalizado llamado *Error_Log__c*, la cual tiene dos métodos: *exceptionHandler* y *exceptionHandlerWithError*, ambos reciben como parámetros una excepción y un nombre de proceso.

### Requerimiento #3
------------
**EventSpeakerTrigger**
Crear un trigger que, antes de que el registro sea guardado en la base de datos, compruebe que el presentador selecccionado no tenga un evento asociado en esa misma fecha.

### Requerimiento #4
------------
**EventAttendeeTrigger**
Utilizar un trigger para enviar un email al asistente del evento para comunicarle que su inscripcion fue confirmada. Que contenga diferentes datos sobre el evento, como el nombre, fecha, ubicación y nombre del organizador, e incluya una redireccion a la ubicación del evento en google maps.

### Requerimiento #5
------------
**Apex Class *DeleteEventBatch***
Utilizar Batch Apex para eliminar todos aquellos eventos que hayan tenido lugar hace más de dos meses.
Y, al finalizar, enviar un email informando que la ejecucion finalizo con exito.

### Requerimiento #6
------------
**LocationTrigger - QueueableVerifyLocation**
Al crear objetos Location, realizar un callout a SmartyStreets API para verificar que la ubicación sea válida.
Y actualizar el campo Verified según corresponda.

### Requerimiento #7
------------
**LWC *addEvent***
Crear un Lightning Web Component con forma de formulario que permita crear un nuevo Event.
Mostrando un Toast Event informando que se creo correctamente, y redirreccionando al nuevo registro.

### Requerimiento #8
------------
**LWC *eventDetails***
Crear un componente con las pestañas: Event Details, Event Speaker, Event Location y Event Attendees.
En principio, en la pestaña *Event Details* mostrar los datos correspondientes a ese Evento.

***eventSpeakers***
En la pestaña *Event Speaker* desplegar en una tabla el nombre, mail, telefono y compania a la que pertenecen los Speakers relacionados a este evento. Ejecutando un método Apex para obtener los Speakers de la base de datos

En la pestaña *Event Location*, exponer los datos relacionados a la ubicación del evento, que son obtenidos mediante adaptadores wire, permitiendo la redirección a google maps.

***eventAttendees***
En la pestaña *Event Speakers* desplegar en una tabla el nombre, mail, companía y ubicación de los asistentes del evento, los cuales serán obtenidos a través de un método Apex.

### Requerimiento #9
------------
**LWC *eventList***
Mostrar una lista de los próximos eventos (cuya fecha sea posterior a la actual) en una tabla que contenga el nombre del evento, el organizador, la ubicacion y detalles del mismo. Personalizando una de las columnas para que permita lograr la redirección al registro del evento al hacer click en él.

***searchForm***
Implementando también un buscador que filtre los resultados según nombre, fecha y/o ubicación.

### Requerimiento #10
------------
**LWC *attendeeEvents***
Crear un componente que exponga, detro del página del asistente al evento, en tablas separadas los eventos a los que la persona ha asistido y aquellos futuros a los que se ha inscripto.

### Requerimiento #11
------------
***eventSpeakers  -  eventAttendees***
Dentro de los componentes *eventSpeakers* y *eventAttendees* , que corresponden a pestañas dentro de *eventDetails*, incorporar una nueva funcionalidad que permita crear nuevos Speakers o Attendees, según corresponda, desde el mismo componente y autocompletando el campo del "Evento" con el del registro en el que se encuentra.
