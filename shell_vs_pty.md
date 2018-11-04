## Why We Chose Pseudo-Terminal Over Interacting with Shell
When the user executes a line of code from within the REPL terminal, the user's input will be sent to the server for processing. There are two main ways that we can handle user input:
- Spawning a REPL child process and interacting directly with it
- Spawn a pseudo-terminal and simulate command-line-like user inputs



> Reading standard output from shell subprocess directly through application code usually requires the standard input to be closed. If the stdin is not closed, the stdout can not be read properly and may cause the daemon to be stuck. "Unneeded file descriptors should be closed. This prevents the daemon from holding open any descriptors that is may have inherited from its parent (which could be a shell or some other process)." From "Advanced Programming in the UNIX Environment", W. Richard Stevens, Addison-Weseley, 18th Printing, 1999, page 417.

> Using a pseudo terminal solves this problem as the pseudo terminal simulates a real command line interface that we can directly write lines into, issue commands as well as reading the terminal output directly without interacting with the process' stdout. With this, we can capture terminal prompts, ANSI escape codes for colored output, as well as full error messages for each repl evaluations.

### Spawning a Child Process and Interacting Directly with It
