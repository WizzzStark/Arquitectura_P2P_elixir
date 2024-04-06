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



