### "why we chose to have one instance per container instead of multiple repl processes in a single container"?
  - strong isolation of containers so that instances of the application do not mix
  - easily configure the maximum allowed memory and CPU for each instance
  - one malicious actor can only take down one instance at a time, the attacker will not have access to other instances

Every user who connects to our service will either get their own room or join an existing room (if connecting via a shared room-invitation URL).
For every room, we will create a complete instance of our app, including the language runtimes.
For example, Room #1 would be a Docker container with Alpine Linux, Nodejs, Ruby, and Python installed.
Room #2 would have a copy of these same apps, but it would be running on a separate Docker container.
When the users of the room select a language, the container will start a REPL process for that language.

We have decided to create a separate container for every room for a variety of reasons.

> "It is generally recommended that you separate areas of concern by using one service per container. That service may fork into multiple processes. It’s ok to have multiple processes, but to get the most benefit out of Docker, avoid one container being responsible for multiple aspects of your overall application."
[https://docs.docker.com/config/containers/multi-service_container/]

First of all, it greatly enhances the security of our app.
If a malicious user were to try to damage our app, any negative effects would be isolated within a single container. 
The only other users that would be affected would be the users in the same room.
Even if a user were to delete all the files on the file system, or bring down the server hosting the room, it wouldn't be a major problem.
As soon as the main server becomes aware of the problem, it could just shut down that container and create a new one.

Another benefit of having separate containers is that it allows us to easily place limits on the maximum amount of resources each room is able to use. 

> "If an application were to consume an excessive amount of CPU resources, or if a buggy application were to have a memory leak, then the application's use of resources would likely impact any other applications running on the server."
[https://searchservervirtualization.techtarget.com/tip/Weighing-the-pros-and-cons-of-application-containers]

For example, we could place a maximum limit of 100MB of memory and 5% processing power on every container.
Specifying limits would allow us to easily calculate the maximum amount of rooms that our main server would be able to run at the same time.
If we needed to scale up our app, we would have a good idea of the amount of additional resources our app would require.
These limits also ensure that if a user executes code that consumes a large amount of resources, such as an infinite loop, then any drops in performance or stability will be isolated to their room, and won't significantly affect the host server.

> "Scaling containers horizontally is much easier if the container is isolated to a single function. Having a single function per container allows the container to be easily re-used for other projects or purposes." [https://devops.stackexchange.com/questions/447/why-it-is-recommended-to-run-only-one-process-in-a-container]

We have also explored other alternatives to having a separate contained app per room.
One possibility is to not use containers at all, and just spawn a REPL process (like IRB) for every room that runs directly on  the server.
This approach has many potential problems.
Since we have chosen to use a pseudo-terminal as an interface to our REPL, users have the ability to input dangerous code that threatens the integrity of our entire app (including all other rooms and the main server).
For example, in Ruby, they could enter `system 'rm -rf /'`, which would delete the entire root directory of the file system, effectively shutting down and destroying our app.
It's possible to prevent this by sanitizing user input before sending it to the REPL to execute, but since we are planning on supporting a variety of languages, it would be very difficult, if not impossible, to guarantee the security of our app by covering every edge case.
Even if we were successful implementing validation from a security perspective, the extra processing required would decrease performance and increase latency.

Another alternative we considered is having a separate container for every language, instead of for every room.
While this approach is better than not having containers at all, it still has some issues.
For example, while the security and stability problems mentioned above would be isolated from affecting our main server, they would still affect all the other rooms that are currently using the same language.
Another drawback of this approach is that it exposes users to attacks coming from users in another room.
A third problem is that it would be difficult to specify a limit for the amount of resources that could be used by a particular container.
Since any number of rooms could be running in the same container, depending on the popularity of the language, there would be no way to accurately estimate the amount of resources required ahead of time.
This would mean that a container would often under- or over-utilize its available resources, leading to lower performance, higher running costs, or both.

Creating separate containers allows us to avoid the problems mentioned above, but there are some downsides as well.
One issue is that it increases the amount of memory required, because each container has a copy of the entire operating system, environment, and language runtimes.
For example, running a container built from a Docker image that has Alpine Linux and Node, consumes a base amount of 32MB of memory, without any users connected or language runtimes running.
Another issue is that containers are not completely secure and isolated.
While difficult, there are ways to break out of a container and gain access to the host environment, because containers share some of the resources of the host.
One way to increase the security would be to use a virtual machine instead of a container, as virtual machines provide much greater isolation.
For even better security, we could make use of *both* containers and a virtual machine.
Instead of running the containers directly on our server, we could create a virtual machine on our server that would be responsible for running the containers.
This way, even if the security of a container was compromised, the malicious user would still have to get through the virtual machine before they could affect the host.
While this would be more secure, it would also increase the complexity and resource costs of our app.

Another way of providing strong container isolation from our host kernel is to use a container runtime sandbox. A container runtime sandbox intercepts application system calls (by blocking system calls that attempt privileged access) and acts as the guest Kernel, without the need for translation through virtualized hardware. Just like within a VM, an application running in the sandbox gets its own kernel, distinct from the host and other sandboxes. It provides a flexible resource footprint and lower fixed cost than a full VM. However, it comes with a higher per-system call overhead and lower application compatibility. [https://cloud.google.com/blog/products/gcp/open-sourcing-gvisor-a-sandboxed-container-runtime]

For now, we have decided that creating separate containers that run on our main server provides a good balance of security and practical viability.
