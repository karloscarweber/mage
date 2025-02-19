const std = @import("std");
const root = @import("root.zig");
const Char = root.Char;
const String = root.String;
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
		name,
		number,
		symbol,
		newline,
		keyword,
		comment,
		
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

// Lexer Struct
// it manages the state of the Lexer as it runs through source code before
// passing the stuff off to the parser.
pub const Lexer = struct {
	start: usize = 0,
	current: usize = 0,
	line: usize = 1,
	tokens: Tokens,
	source: []const u8,
	
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
				'#' => {
					while (self.peek() != '\n' and !self.isAtEnd()) {
						_ = self.advance();
					}
				},
				else => break,
			}
		}
	}
	
	pub fn name(self: *Self) !void {
		while (Char.isAlphabetic(self.peek()) or Char.isDigit(self.peek()) or '_' == self.peek()) {
			_ = self.advance();
		}
		
		// do this later to check the names and stuff.
		try self.push(Token.Type.name);
	}
	
	// parses a number
	pub fn number(self: *Self, character: u8) !void {
		
		if (self.peek() == 'x' and character == 0) {
			// Hex number
			_ = self.advance(); // grabs the x
			while (Char.isHex(self.peek())) { _ = self.advance(); }
		} else {
			// Not Hex Number
			while (self.peek() == '.' or self.peek() == '_' or Char.isDigit(self.peek())) {
				_ = self.advance();
			}
		}
		try self.push(Token.Type.number);
	}
	
	pub fn scan(self: *Self) !void {
		// std.debug.print("lexing.....\n");
		while (!self.isAtEnd()) {
			try self.skipWhitespace();
			self.start = self.current;
			
			if (self.isAtEnd()) { break; }
			
			const c = self.advance();
			
			if (Char.isAlphabetic(c)) { try self.name(); continue; }
			if (Char.isDigit(c)) { try self.number(c); continue; }
			
			switch (c) {
				'(',')','{','}','[',']',
				'-','+','*','/','%','=',',', => {
					try self.push(Token.Type.symbol);
				},
				else => {
					continue;
				}
			}
		}
	}
	
};
