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
		newline,
		
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
	
	const Self = @This();

	pub fn init(allocator: Allocator, source: []const u8) !Lexer {
		return .{
			.source = source,
			.tokens = Tokens.init(allocator),
		};
	}

	pub fn deinit(self: *Self) void {
		self.tokens.deinit();
	}
	
	pub fn isAtEnd(self: *Self) bool {
		return self.current == self.source.len;
	}
	
	// returns a legit character, or the EOF null terminating byte.
	fn charAt(self: *Self, index: usize) u8 {
		return self.source[index];
	}

	// peek looks at the thing at current
	pub fn peek(self: *Self) u8 {
		return self.charAt(self.current);
	}

	// advances returns the current character and then advances the pointer forward.
	pub fn advance(self: *Self) u8 {
		defer self.current += 1;
		return self.charAt(self.current);
	}

	// we probably don't need this.
	pub fn peekNext(self: *Self) u8 {
		if (self.isAtEnd()) { return self.peek(); }
		return self.charAt(self.current+1);
	}

	// pushes a token onto the stack.
	pub fn push(self: *Self, typ: Token.Type) !void {
		try self.tokens.append(Token{
				.type = typ,
				.start = self.start,
				.length = self.current - self.start,
				.line = self.line,
			});
	}
	
	// adds a new line.
	// it's special because newlines are whitespace, but they are also importantish.
	// So skipWhitespace will mark a new line as it rolls right on through, but also
	// advance the ticker thingy.
	//
	pub fn pushNewline(self: *Self) !void {
		self.line += 1;
		try self.tokens.append(Token{
			.type = Token.Type.newline,
			.start = self.current - 1,
			.length = 1,
			.line = self.line,
		});
		_ = self.advance();
	}
	
	pub fn skipWhitespace(self: *Self) !void {
		while (true) {
			switch (self.peek()) {
				' ', '\r', '\t' => { _ = self.advance(); },
				'\n' => { try self.pushNewline(); },
				
				// comments reach the end of the line, so.., if we have a slash,
				// we roll over until the end of the line if we see another slash.
				'/' => {
					if (self.peekNext() == '/') {
						while (self.peek() != '\n' and !self.isAtEnd()) {
							_ = self.advance();
						}
					} else {
						break;
					}
				},
				else => break,
			}
		}
	}
	
	// pub fn scan(self: *Self) void {
	// 	std.debug.print("lexing.....\n");
	// }
	
};
