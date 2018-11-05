## Why we chose WebSockets over HTTP and SSE

For our application, we need to be able to provide a stable connection between the client and server so that our users are able to submit their code for evaluation and execution, as well as being able to use the client-side REPL. Additionally, we want to enable users to join the same pad and collaborate together on the same editor and REPL in real-time. The options that we explored to achieve these goals were the HTTP request/response protocol, server-side events (SSE), and WebSockets. After considering the tradeoffs for each option, we chose WebSockets to achieve our goal and detail our reasons for doing so below.

### HTTP Request/Response Protocol

With HTTP we would have the advantage of using an established protocol that our group has experience working with. However, there are several challenges that arise in our application when using HTTP. First, our application will be creating a lot of traffic between the client and server with the following actions:

- client sends code either from the editor or REPL to the server for evaluation and execution.
- server sends the result of the code execution to the client.
- when collaborating with several users in the same room, the client will send any changes in the code editor to the server.
- server will push changes in the code editor to all collaborating users.
- server will push code execution to the client for all collaborating users.

As we can see, there will be many requests and responses sent for even simple client-side actions (such as typing in the code editor, outputing code execution, etc.) that will generate a lot of overhead with HTTP. This is because each HTTP request will create a new TCP connection, send information with headers, and receive the server response. Additionally, we will need to prioritize reducing the latency experienced by our users as they will be collaborating in real-time and all users on the same pad will need to see any changes made by one user as soon as possible.

Finally, we have to address the issue of when a client disconnects from our server. Since our application will be running a container and pseudo-terminal on the server for each pad, we need to know when a client disconnects in order to start the process of shutting down the pseudo-terminal and container. With HTTP, we cannot know when a disconnect occurs as no request is sent by the client upon disconnection. Thus, we need a solution that will enable us to detect and handle disconnections as soon as possible so that we can free up resources for other users.

### Server-Side Events (SSE)

One approach that could address these challenges are SSE, which is a technique using HTTP in which the server continuously sends updates to the client over an open TCP connection without needing a request to do so. This is commonly known as a *data push* technique and would allow us to:

- reduce our overhead by using a single TCP connection to send updates.
- reduce our latency by sending continuous updates from the server without first needing a request for each collaborating user.
- allows us to use our existing infrastructure as HTTP supports SSE out of the box.
- provides the ability to reconnect a disconnected client.

However, there are some issues with using SSE. For one, a SSE connection needs an HTTP requst to establish a connection, afterwich the server can continuously send updates to the client. So when several users who are collaborating join a pad on our application our server can provide each of them with updates when a user writes code in our editor or REPL and when code is executed.

That said, SSE connections can only push data to the browser. Any updates from the client would still require a new TCP connection to submit to the server. So while we reduce the overall overhead when only one user is performing client-side actions and other users are simply observing their actions, the overhead will still grow as multiple users perform actions on the same pad as their actions will be sent as updates to the server. Thus our real-time collaboration feature would not benefit from using SSE with our application.

> If you don’t need to send data to the server in “real-time” (e.g. voice/video chat, multiplayer games, …) go with Server-Sent Events. https://blog.stanko.io/do-you-really-need-websockets-343aed40aa9b

Additionally, while a SSE can reconnect a disconnected client we still cannot detect a disconnection on it's own and would need additional engineering to handle this issue. Lat, all major browsers have a limit to how many parallel open HTTP connections can be maintained at any one time, and for SSE the limit is ~6 connections per server. This severly limits our ability to effetively scale our application.

> Server-Sent Events utilize a regular HTTP octet streams, and therefore are limited to the browser’s connection pool limit of ~6 concurrent HTTP connections per server. https://blog.stanko.io/do-you-really-need-websockets-343aed40aa9b

### WebSockets

After considerable research, we reached the conclusion that WebSockets would allow us to address all of the above challenges. WebSockets provides bidirectional communication between the client and server over a single TCP connection that remains open until one of the two disconnects. This allows both the client and server to continuously send updates to each other without needing a request from one side to start the update, and WebSockets provides us with a simple way to provide real-time, collaboration to all users on the same pad.

Arguably the biggest advantage in using WebSockets is the number of parallel connections we can maintain with 1024 or more connections per server as opposed to ~6 connections per server with SSE and HTTP. This allows us to scale much more efficiently and fully utilize our server resources before needing to add more servers.

![Comparison Chart of WebSockets, SSE, Long Polling](https://cdn-images-1.medium.com/max/1000/1*xG6z--Cc_556TAfhVD17tQ.png)

Considering performance, browser tests comparing a single HTTP and equivalent WebSocket request show that WebSockets result in lower latency. We have chosen Socket.io as our preferred implementation of WebSockest, and on average a single HTTP request took about 107ms and a Socket.io request 83ms. For a larger number of parallel requests things started to look quite different. 50 requests via Socket.io took ~180ms while completing the same number of HTTP requests took around 5 seconds. Overall HTTP allowed to complete about 10 requests per second while Socket.io could handle almost 4000 requests in the same time. These results can be found here: https://blog.feathersjs.com/http-vs-websockets-a-performance-comparison-da2533f13a77

As for data transfer, benchmarking has shown that one HTTP request and response can take a total of 282 bytes while the request and response WebSocket frames weighs in at a total of 54 bytes (31 bytes for the request message and 24 bytes for the response). Note that this difference will be less significant for larger payloads however since the HTTP header size doesn’t change. These results can be found here: https://blog.feathersjs.com/http-vs-websockets-a-performance-comparison-da2533f13a77

These benefits do not come without some tradeoffs. For one, WebSockets is a custom solution with many libraries that offer variable performances and functionality. Additionally, while WebSockets can detect disconnections it doesn't have the ability to automatically reconnect clients with servers, and the ability to do so would have to be added onto a WebSocket implementation. Fortunately, Socket.io is an implementation of WebSockets that provides a reconnection feature and provides high performance, while also being simple to use.

### Conclusion

The area of how one manages their client-server connection can be incredibly deep and there are many paths to choose depending on one's goals. For our project, we believe that WebSockets is the best choice to meet our needs and tackle the challenges of a real-time, collaborative REPL while providing us with a low latency and high performance experiences for our users.








