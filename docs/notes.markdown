Title:          Notes about Octavius
Author:         Pedro Melo
Affiliation:    
Date:           2008-10-19
Copyright:      2008 Pedro Melo.  
                This work is licensed under a Creative Commons License.  
                http://creativecommons.org/licenses/by-sa/2.5/
Keywords:       octavius, messaging, pubsub, peer2peer
XMP:            CCAttributionShareAlike

What is Octavius?
=================

Octavius is a embedded peer-to-peer messaging system. The clients
runs inside your own scripts, and exchanges messages directly with
other peers.

The Octavius client uses one or more tracker services to know which
peers have similar interests.

A set of trackers and peers forms a cloud.


Tracker life cycle
==================

After starting up, he sets up an empty map of interested parties.

He then connects to the other trackers in this cloud and asks for the current
map.

After he is in sync with the other trackers, he starts the listening socket,
and is ready to accept peer connections.

Each peer connects and sends its identification and current interests list:

 * topics that he is interested on;
 * topics that he is producing.

The tracker sends back the peers that produce the topics that he is
interested on, and the peers that are interested on topics that he is
producing.


Protocol
--------

This is a sample session of the protocol.

    C: ID <peer_id>
    S: ID-Ack <peer_id>
    C: Sub <topic, role> *
    S: Sub-Ack *
    S: Map <topic, peer, role> *
    C: Unsub <topic>

A `*` means that you can send or receive several of this messages.


Peer life cycle
===============

After the client is initialized, he tries to connect to the trackers.

He identifies himself to all the trackers, and then sends all his interests,
pairs `<topic, role>`, where `role` can be subscriber or publisher.

The tracker then sends back topic maps. It includes the topic, the role and the peer.

The client connects to all the producers of topics he is interested on.


The peer protocol
-----------------

The peers connect to each other and use the peer protocol to
exchange messages.

To make it easier to follow, we label the source peer as the Client, and
the destination peer as the Server. There is no difference between
client and server when two peers talk to each other.

The only exception is the initial handshake. The Client is expected to
take the initiative and start the conversation.

    C: ID <client_peer_id>
    S: ID-Ack <client_peer_id>
    S: ID <server_peer_id>
    C: ID-Ack <server_peer_id>

The connection is now active. The Server will use this connection to
send messages for matching topics.

Notice that peers don't exchange subscription information between each
other. That information is only exchanged with the tracker.

