# Communication Protocols for Real-Time Collaboration

## WebRTC (Web Real-Time Communication)
- transport agnostic
  - uses UDP, TCP, SCTP, or other layers
  - data can be transported in both reliable or unreliable ways, and in-order or not-in-order
- p2p
  - peers can communicate with each other independently
  - it still requires a way to exchange endpoints data
    - often a centralized signaling server is used to establish the initial connection between peers
- good for high-volume data transfer (eg: audio/video streaming) where reliability can be sacrificed for response time and delivery
- newer than WebSocket
- uses same JS API as WebSockets (RTCDataChannel)
- very secure (encryption is mandatory)
- Users
  - TeleType (for Atom)
  - Conclave
- JS libraries
  - PeerJS

## WebSocket
- use a single TCP connection
  - only supports reliable, in-order transport
  - packet drops can delay all subsequent packets
- client-server only
  - establishes a persistent connection between client and server
  - bidirectional communication (full-duplex)
    - data can be transmitted at any time -- even simultaneously in both directions
    - central server acts as a relay by forwarding operations from each user to all the other users
    - increases latency
    - expensive to scale
    - single point-of-failure
- easier to use (simple browser API)
- real-time
- data can be encrypted using TLS
- uses HTTP compatible handshake and default ports
  - uses HTTP Upgrade header to change from HTTP to WebSocket protocol
  - much easier to use with existing firewall, proxy, and web-server infrastructure
- good in applications that require frequent messaging


## XMPP (Extensible Messaging and Presence Protocol)
- based on XML
- near-real-time exchange of structured data
- client-server decentralized architecture

### Pros
- decentralization
  - anyone can run their own server -- there's no central master server
- open standards
- long history (since 1999) and many implementations exist
- security
  - supports secure authentication (SASL) and encryption (TLS)
- flexible
  - custom functionality can be built on top of XMPP
  - many extensions are available

### Cons
- does not support Quality of Service (QoS)
  - assured delivery of messages has to be built on top of the XMPP layer
- specializes in text-based communication
