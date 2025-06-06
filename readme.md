# Mage
A small math language.

## Progress
- [x] Scanner
- [ ] Parser
- [ ] Compiler
- [ ] VM Interpeter

## Building the project
Run `zig build`.

## Running the project
Run `zig run src/main.zig`. or `zig build run`. Or when things get hairy and it really doesn't work: `zig build run -freference-trace`.

## Running the tests
Run `zig build tests` to run the tests. Add a file to the tests by importing it into `tests.zig`. Run an individual file: `zig test src/filename.zig`. Alternatively we have short hands for the unit tests: `zig build test:vm`, to build tests just for the VM.

