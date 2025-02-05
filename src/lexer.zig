const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;

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
			// switch (self) {
			// 	Type.letter => {
			// 		return "letter";
			// 	},
			// 	Type.number => {
			// 		return "number";
			// 	},
			// 	Type.symbol => {
			// 		return "symbol";
			// 	},
			// }
		}
	};
	
	// Displays a string.
	pub fn display_h(self: *Token) ![]const u8 {
		const typ = self.type.to_str();
		const start = self.start;
		const line = self.line;
		const length = self.length;

		const str = try std.fmt.allocPrint(std.heap.page_allocator, "{s} [{d}:{d}..{d}]!", .{typ, line, start, length});
		
		// std.debug.print("{s}\n", .{str});
		return str;
	}
};

// Lexer Struct
// pub const Lexer = struct {
// 	source: []const u8,
// 	start: usize = 0,
// 	current: usize = 0,
// 	line: usize = 1,
// 	tokens: ArrayList(Token),
//
// 	pub fn init(source: []const u8) Lexer {
// 		return .{
// 			.source = source
// 		};
// 	}
// };

pub fn lex() void {
	std.debug.print("Hello Friends.\n", .{});
}

// String comparison helper.
pub const String = struct {
	pub fn is_eq(str1: []const u8, str2: []const u8) bool {
		return std.mem.eql(u8, str1, str2);
	}
};

test "does it print tokens" {
	var token: Token = Token{
		.type = Token.Type.letter,
		.start = 15,
		.length = 2,
		.line = 1,
	};
	
	const disp = try token.display_h();
	defer std.heap.page_allocator.free(disp);
	std.debug.print("{s}\n", .{disp});
	
	try testing.expect(String.is_eq(disp, "letter [1:15..2]!"));
	
}
