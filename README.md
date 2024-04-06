# Implementación de una arquitectura

En esta práctica debes desarrollar una implementación que demuestre la
estructura y funcionamiento de una de las arquitecturas que se
estudian en la materia, a excepción de la arquitectura
cliente/servidor básica.


La funcionalidad del sistema no es relevante, no es necesario
implementar ninguna lógica de negocio concreta.

El proyecto tiene que modelar los componentes propios de la
arquitectura elegida y dichos componentes deben colaborar según lo
definido en la arquitectura. Tanto la implementación de los
componentes como la colaboración entre ellos debe usar los mecanismos
propios del lenguaje de programación _elixir_.


## Pasos

1. Cubre el apartado _Autor_  de este README.

1. Elige una de las arquitecturas estudiadas en la materia,
   distribuida o no. La arquitectura cliente/servidor no es elegible.

2. Cubre el apartado correspondiente de este README.

3. Documenta la arquitectura usando el modelo C4 según se describe en
   el apartado correspondiente de este README.

4. Cubre los apartados correspondientes de este README.

5. Implementa un modelo de la arquitectura elegida y las pruebas
   necesarias para validar dicha implementación.
 
6. Cubre los apartados correspondientes de este README.

7. Sube al moodle la url de este repositorio.


>[!NOTE]
> Si deseas una revisión intermedia antes de completar el
> desarrollo de la práctica, solicítala directamente al profesor.


## Requisitos

1. Dado que _elixir_ es un lenguaje orientado a la concurrencia, la
   forma adecuada de representar los componentes de la arquitectura es
   mediante procesos.
   
2. El código fuente tiene que tener el formato dado por `mix format`.

3. Se debe usar la herramienta de construcción estándar: `mix`.

4. Documenta _en línea_ las funciones relevantes del código, usando
   `@doc`, `@spec`, ...
   
5. El código debe compilar sin _warnings_.

6. El código debe pasar los tests antes de hacer un _push_ a _github_.


## Uso del repositorio

1. Antes de realizar el primer _push_ es conveniente crear el proyecto
   con `mix new app`.

2. El repositorio inicial contiene una _github action_ que realiza
   comprobaciones automáticas sobre el código del proyecto.
   
   Para que esta acción funcione correctamente puede ser necesario
   configurar los siguientes parámetros:
   
   - Versión de OTP.
   
   - Versión de elixir.
   
   - Ruta al proyecto dentro del repositorio.
   
   Estos parámetros se configuran en el fichero `.config` en la raíz
   del repositorio.
   
   Ejemplo de fichero `.config`:
   
   ```
   OTP_VERSION=25.0.4
   ELIXIR_VERSION=1.14.1
   APP_BASE_PATH=app/
   ```
   
3. Para nuestra comodidad también podemos configurar el repositorio
   local para que realice comprobaciones sobre el proyecto y no nos
   permita hacer un commit si nos hemos olvidado de algo.
   
   Por ejemplo, comprobar que el código compila sin warnings, tiene el
   formato requerido y pasa los tests. En un entorno _unix-like_ una
   opción para hacer esto último es con el siguiente fichero:

   ```
   ---------------------------
   File: .git/hooks/pre-commit
   ---------------------------
   
   #!/bin/sh
   mix compile --warnings-as-errors
   mix format --check-formatted
   mix test
   ```
   
## Entrega de la práctica

Al entregar la práctica para su evaluación debes tener en cuenta lo
siguiente:

- Sube al moodle la url del _commit_ que quieres que se evalúe. Si
  subes la url del repositorio, se evaluará el último commit de la
  rama `main`.
  
- Los commits para los que la _github action_ original no se haya
  ejecutado con éxito se consideran **no entregados** y reciben una
  calificación de **0 puntos**.

- Si quieres una revisión intermedia del proyecto _antes de
  finalizarlo_, ponte en contacto con el profesor.


# Secciones a cubrir durante el desarrollo de la práctica

## Autor

Alberto, Fernández Valiño, alberto.fernandezv@udc.es


## Presentación de la arquitectura

Arquitectura P2P semi centralziada 

La arquitectura propuesta es una red Peer-to-Peer (P2P) semi-centralizada. En este modelo, los nodos o "peers" se comunican directamente entre sí para el intercambio de mensajes, suscripción a otros peers, y gestión de perfiles. Un componente centralizado, conocido como "SuperPeer" o supervisor dinámico e el código, facilita la creación y gestión de estos nodos, actuando como un punto de registro y coordinación inicial. Esta arquitectura combina las ventajas de las redes descentralizadas con la gestión centralizada para mejorar la eficiencia, el descubrimiento de servicios y la robustez.


## Diseño de la arquitectura

[Ver Diagrama de contexto](doc/P2P-C4-Context.png)

[Ver Diagrama de contenedores](doc/P2P-C4-Container.png)

[Ver Diagrama de componentes](doc/P2P-C4-Components.png)

[Ver Diagrama de Secuencia](doc/diagramas_secuencia.md)


## Testing

Los tests implementados son para el módulo Peer e incluyen:

Tests de Integración: Verifican la comunicación y el correcto funcionamiento entre peers, incluyendo el inicio y detención de procesos Peer, envío y recepción de mensajes, actualización y consulta de perfiles, y gestión de suscripciones.

Tests de Comportamiento: Aseguran que la lógica de negocio (como la suscripción y notificación entre peers) funcione según lo esperado.
Estos tests están diseñados para asegurar que las funcionalidades clave del módulo Peer operen correctamente bajo diversas condiciones.

Para ejecutar los test se usará el siguiente comando:

```bash
mix test
```

## Uso

En el caso de que se quiera ejecutar en modo interactivo para probar la arquitectura a tiempo real se debe ejecutar el siguiente comando:

```bash
iex -S mix
```

Una vez en la terminal se inicializará el superPeer que gestionará los Peers de forma automática y el registro de Peers, para inicializar Peers hay que ejecutar lo siguiente:

```bash
{:ok, _peer1} = Peer.start_link("peer1")
{:ok, _peer2} = Peer.start_link("peer2")
{:ok, _peer3} = Peer.start_link("peer3")
```

Para listar los Peers activos:

```bash
Peer.list_peers()
```

Para mandar un mensaje a un Peer:

```bash
Peer.send_message("peer2", "Hello, peer2 from peer1!")
```

Para recivir mensajes de un Peer:

```bash
Peer.get_messages("peer2")
```

Para actualizar un perfil y consultar su información:

```bash
Peer.update_profile("peer1", %{bio: "Just a peer in the P2P world", status: "online"})
Peer.get_profile("peer1")
```

Para que un Peer se suscriba a otro para que escuchar activamente los mensajes de ese Peer:

```bash
Peer.subscribe_to("peer2", "peer1")
```

Para detener un Peer
```bash
Peer.stop("peer1")
```



