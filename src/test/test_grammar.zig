// test_grammar.zig
const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const allocator = testing.allocator;
const expect = testing.expect;
const print = std.debug.print;

const psp = @import("../parser.zig");
const Parser = psp.Parser;

// const lx = @import("../scanner.zig");
// const Scanner = lx.Scanner;
// const Token = lx.Token;
const number_source = "15 + 20 * 12";
const name_source = "String hello = 15";

const Grammar = @import("../grammar.zig");

test "Parser recognizes numbers" {
	var parser = try Parser.init(allocator, number_source);
	defer parser.parse();
	// try expect(!scanner.isAtEnd());
	// try expect(scanner.peek() == 'h');
	// try expect(scanner.advance() == 'h');
	// try expect(scanner.advance() == 'e');
	// try expect(scanner.advance() == 'l');
	// try expect(scanner.peek() == 'l');
	// try expect(!scanner.isAtEnd());
	print("whatever", .{});
}
