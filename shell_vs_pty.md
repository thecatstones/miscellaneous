## Why We Chose Pseudo-Terminal Over Interacting with Shell
When the user executes a line of code from within the REPL terminal, the user's input will be sent to the server for processing. There are two main ways that we can process the user's input:
- Spawning a REPL child process and interacting directly with its stdin
- Spawn a pseudo-terminal and simulate user inputs via a pseudo command-line

### Spawning a Child Process and Interacting Directly with It
Many languages provide APIs to access operating system features by executing system commands inside a child process.
Node.js for example, provides the `child_process` module that includes methods such as `spawn()` that executes a command that spawns a new process. We can, for instance use the `spawn()` method to spawn a `node` REPL child process from within our application code. 

The API would also provide access to the standard streams of the child process: `stdin`, `stdout` and `stderr`. We can listen to a child process' readable streams, `stdout`/`stderr`, while its `stdin` stream is a writable one. While it is possible to evaluate lines of code through sending the lines to the `stdin`, due to the differences in how different REPLs are implemented, the `stdin` may not send any data to the REPL program for evaluation until the `stdin` is closed. One possible way this could happen is that the background process (node) holds open any descriptors that may have inherited from the parent process (application):

> "Unneeded file descriptors should be closed. This prevents the daemon from holding open any descriptors that is may have inherited from its parent (which could be a shell or some other process)." - From "Advanced Programming in the UNIX Environment", W. Richard Stevens, Addison-Weseley, 18th Printing, 1999, page 417.

This is a problem because once the input stream is closed, we may not be able to evaluate any additional lines of code. While there are ways that we can potentially manipulate how each REPL child process work, it has to be done manually and do not fit our use case of supporting more than one language for REPL.

### Interacting with a Pseudo-terminal
Creating an instance of pseudo-terminal that interacts with the REPL child process solves this problem. A pseudo-terminal emulates a command line interface within our application, so that our application will *think* that it is interacting with a terminal [https://github.com/Microsoft/node-pty] and is able to send control sequences (such as Ctrl-C). 

> "Anything that is written on the master end is provided to the process on the slave end as though it was input typed on a terminal. For example, writing the interrupt character (usually control-C) to the master device would cause an interrupt signal (SIGINT) to be generated for the foreground process group that is connected to the slave." [http://man7.org/linux/man-pages/man7/pty.7.html]

With this, our application will not need to manually handle the child process' input/output streams as well as sending signals to the program to abort an evaluation while keeping the REPL running (such as terminating an infinite loop).
Furthermore, our application will automatically capture all appropriate prompts as well as ANSI escape codes for colored output.
