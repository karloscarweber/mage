# Development

## Scanner
Scanner scans the code and makes simple tokens.

## Parser
Runs through the tokens and emits loose bytecode.

## Compiler (JORT)
The compiler optimizes the bytecode, and recompiles the stuff on the fly for the interpreter.

## Interpreter
Runs the bytecode, manages the fibers, does cool stuff, talks to the environment.

## Commands
- Run tests: `zig build tests`
