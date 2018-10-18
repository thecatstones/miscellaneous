## Yjs
- a JS framework for offline-first p2p shared editing on structured data like text, richtext, json, or XML.
- Yjs takes care of resolving conflicts on shared data
  - helps you to handle concurrency
- near real-time (NRT) collaboration
  - collaborators apply changes to their local copy, while concurrently sending and receiving notifications of those changes via some communication protocol.
  - eg: Google Docs uses Operation Transformation (OT) and a client-server infrastructure to resolve conflicts
  - Yjs doesn't use OT

### Connectors: (communication protocol to propagate changes to clients)
- WebRTC
  - browser2browser
  - more efficient response times than XMPP
- WebSockets
  - central server
- XMPP
  - propagate updates in a XMPP multi-user chat room
  - scales better than WebRTC for a large user base
- IPFS
- can build a custom connector
  - any communication protocol can be used (p2p, federated, client-server)
  - Choose a Sync Method
    - SyncAll Sync Method
      - everyone synchronizes with each other
      - based on WebRTC
      - good for small networks, but not big ones
    - Master-Slave Sync Method
      - one or more master clients serve as the endpoint for the syncing process of the slaves
      - you only need to sync once, even if there are 1000s of users
      - operations can still be published p2p (they don't have to go through the master-client)
        - master-clients should have a high uptime
      - good for implementing a nodeJS server that runs on your server/cloud to preserve the state of the shared document

### DB adapters (store changes in DB)
- memory
  - in-memory storage
- IndexedDB
  - offline storage for browser
- LevelDB

### Types (use 1+ data types to represent the shared data)
- map
- array
- XML
- JSON
- DOM
- graphs
- text
  - Ace Code Editor
  - CodeMirror
  - Monaco Editor
- richtext
- can create custom types


## DerbyJS MVC framework
- the Derby MVC framework makes it easy to write realtime, collaborative applications that run in both Node.js and browsers.
- uses ShareDB
  - ShareDB is a realtime DB backend based on Operation Transform (OT) of JSON documents
    - uses WebSocket
