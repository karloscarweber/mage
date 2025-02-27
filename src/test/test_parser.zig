const ps = @import("../parser.zig");
const Parser = ps.Parser;
const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const print = std.debug.print;

// TESTS
const expect = testing.expect;

// Test Lexer fucntiosn
// Lexer.isAtEnd()
test "Parser functions" {
	var parser = try Parser.init(testing.allocator, "hello friends!");
	defer parser.deinit();
	try expect(parser.parse());
}
