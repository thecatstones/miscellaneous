# Problems

## CORS
- It was very difficult to get CORS to work correctly between the WebSocket server (Heroku/Yjs/Node), the client (Heroku/Yjs/Express/Node/Webpack/Socket.io).
  - With all these different services, some of which may be old versions, it was very confusing to try to figure out exactly what to do differently.
- The error messages and network logs were also not very informative.
- It was also hard because sometimes it would work randomly and allow CORS for a couple minutes, but then stop again, even though I didn't change anything.
- Glot doesn't support CORS at all.

## Webpack
- Webpack sometimes hangs for no apparent reason, which makes it difficult to debug because sometimes it seems like there's a bug, but Webpack actually just needs to be restarted.

## Docker
- It's difficult to get a concrete grasp on how to use Docker to build the various parts of our desired architecture.

## Heroku
- It took a while to get Heroku to work correctly with Webpack -- there is a lot of conflicting advice out there on the internet about the proper way to deploy a Node app to Heroku.

## Repl 
- How to handle multi-line input from editor consistently across various languages?

## Which protocol(s) to use?
- WebSockets
- http1
- http2 (can't use with WebSockets)
- WebRTC
= XMPT
- SSE (Server Sent Events) (EventSource)
