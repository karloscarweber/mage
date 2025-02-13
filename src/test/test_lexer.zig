const lx = @import("../lexer.zig");
const Lexer = lx.Lexer;
const Token = lx.Token;
// const String = lx.String;

const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const testing = std.testing;
const print = std.debug.print;

// String comparison helper.
pub const String = struct {
	pub fn is_eq(str1: []const u8, str2: []const u8) bool {
		return std.mem.eql(u8, str1, str2);
	}
};

// TESTS
const expect = testing.expect;

// returns some tokens for tests.
fn ts_some_tokens() Token {
	const token: Token = Token{
		.type = Token.Type.letter,
		.start = 15,
		.length = 2,
		.line = 1,
	};
	return token;
}

test "does it print tokens" {
	var token = ts_some_tokens();
	
	const disp = try token.to_str();
	defer std.heap.page_allocator.free(disp);
	// std.debug.print("{s}\n", .{disp});
	
	try expect(String.is_eq(disp, "letter [1:15..2]!"));
}

const small_source_code = "hello friends!";

// Test Lexer fucntiosn
// Lexer.isAtEnd()
test "Lexer functions" {
	var lexer = try Lexer.init(testing.allocator, small_source_code);
	try expect(!lexer.isAtEnd());
	try expect(lexer.peek() == 'h');
	try expect(lexer.advance() == 'h');
	try expect(lexer.advance() == 'e');
	try expect(lexer.advance() == 'l');
	try expect(lexer.peek() == 'l');
	try expect(!lexer.isAtEnd());
}

test "skips whitespace" {
	var lexer = try Lexer.init(testing.allocator, "  hello");
	defer lexer.deinit();
	
	try lexer.skipWhitespace();
	try expect(lexer.peek() == 'h');
}

test "pushing Tokens" {
	var lexer = try Lexer.init(testing.allocator, small_source_code);
	// we need to deinit this lexer at the end or we'll leak memory.
	// I suspect that not using the testing.allocator doesn't
	// catch the leaked memory.
	defer lexer.deinit();
	try lexer.tokens.append(Token{
		.type = Token.Type.letter,
		.start = 0,
		.length = 0,
		.line = 1,
	});
}

test "registers newlines" {
	var lexer = try Lexer.init(testing.allocator, small_source_code);
	// we need to deinit this lexer at the end or we'll leak memory.
	// I suspect that not using the testing.allocator doesn't
	// catch the leaked memory.
	defer lexer.deinit();
	try lexer.tokens.append(Token{
		.type = Token.Type.letter,
		.start = 0,
		.length = 0,
		.line = 1,
	});
}
