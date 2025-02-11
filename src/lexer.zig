const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const testing = std.testing;
const print = std.debug.print;

// var gpa = std.heap.GemeralPurposeAllocator(.{}){};
// const allocator = gpa.allocator();

pub const Token = struct {
	type: Type,
	start: usize,
	length: usize,
	line: usize,
	
	pub const Type = enum {
		letter,
		number,
		symbol,
		
		pub fn to_str(self: Type) []const u8 {
			return @tagName(self);
		}
	};
	
	// Displays a string.
	pub fn to_str(self: *Token) ![]const u8 {
		const typ = self.type.to_str();
		const start = self.start;
		const line = self.line;
		const length = self.length;

		const str = try std.fmt.allocPrint(std.heap.page_allocator, "{s} [{d}:{d}..{d}]!", .{typ, line, start, length});
		
		return str;
	}
};
const Tokens = ArrayList(Token);

pub fn isAlphabetic(c: u8) bool {
	return switch (c) {
		'A'...'Z', 'a'...'z', '_' => true,
		else => false,
	};
}

pub fn isDigit(c: u8) bool {
	return switch (c) {
		'0'...'9' => true,
		else => false,
	};
}

pub fn isAlphanumeric(c: u8) bool {
	return switch (c) {
		'0'...'9', 'A'...'Z', 'a'...'z' => true,
		else => false,
	};
}

pub fn isWhitespace(c: u8) bool {
	return switch (c) {
		' ', '\t', '\r' => true,
		else => false,
	};
}

pub fn isNewline(c: u8) bool {
	return switch (c) {
		'\n' => true,
		else => false,
	};
}

// Lexer Struct
// it manages the state of the Lexer as it runs through source code before
// passing the stuff off to the parser.
pub const Lexer = struct {
	source: []const u8,
	start: usize = 0,
	current: usize = 0,
	line: usize = 1,
	tokens: Tokens,
	allocator: Allocator,
	
	const Self = @This();

	pub fn init(allocator: Allocator, source: []const u8) !Lexer {
		const arr = Tokens.init(allocator);
		return .{
			.source = source,
			.tokens = arr,
			.allocator = allocator,
		};
	}

	pub fn deinit(self: *Self) void {
		const allocator = self.allocator;
		allocator.free(self.tokens);
	}
	
	// member functions
	// pub fn lex(self: *Self) void {
	// 	if (self.tokens.len > 0) {
	// 		std.debug.print("What up!\n");
	// 	}
	// }
	
	pub fn isAtEnd(self: *Self) bool {
		return self.current == self.source.len;
	}
	
	// returns a legit character, or the EOF null terminating byte.
	fn charAt(self: *Self, index: usize) u8 {
		return self.source[index];
	}

	pub fn peek(self: *Self) u8 {
		return self.charAt(self.current+1);
	}

	pub fn advance(self: *Self) u8 {
		defer self.current += 1;
		return self.charAt(self.current);
	}
	
	//
	// fn peek_next(&self) -> char {
	// 	if self.is_at_end() {
	// 		return EOF
	// 	}
	// 	self.char_at(self.current+1)
	// }
	//
	// // pushes a token onto the stack.
	// fn push(&mut self, typ: TokenType) {
	// 	self.tokens.push(Token {
	// 		typ,
	// 		start: self.start,
	// 		length: self.current - self.start,
	// 		line: self.line,
	// 	});
	// }
	
};

pub fn lex() void {
	std.debug.print("lexing.....\n");
	
	
	
	
}

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

const small_source_code = "hello friends! This is some source code";

test "does the lexer get started with some source" {
	return error.SkipZigTest;
	
	// var lexer = try Lexer.init(testing.allocator, small_source_code);
	// lexer.lex();
	// defer lexer.deinit();
	
	// std.debug.print("{s}\n", .{lexer.source});
	
	// lexer.lex();
	// _ = lexer;
}

test "does the lexer thing advance as we expect, and does isAtEnd work like we want?" {
	var lexer = try Lexer.init(testing.allocator, small_source_code);
	try expect(!lexer.isAtEnd());
	try expect(lexer.charAt(0) == 'h');
	try expect(lexer.charAt(1) == 'e');
	try expect(lexer.charAt(2) == 'l');
	try expect(lexer.peek() == 'e');
	
	try expect(lexer.advance() == 'h');
	try expect(lexer.advance() == 'e');
	try expect(lexer.advance() == 'l');
}
