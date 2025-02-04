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
			switch (self) {
				Type.letter => {
					return "letter";
				},
				Type.number => {
					return "number";
				},
				Type.symbol => {
					return "symbol";
				},
			}
		}
	};
	
	// Displays a string.
	pub fn display_h(self: *Token) ![]const u8 {
		const typ = self.type.to_str();
		const start = self.start;
		const line = self.line;

		const str = try std.fmt.allocPrint(std.heap.page_allocator, "{s} [{d}:{d}]!", .{typ, line, start});
		
		// std.debug.print("{s}\n", .{str});
		return str;
	}
};

pub fn lex() void {
	std.debug.print("Hello Friends.\n", .{});
}

pub const String = struct {
	pub fn is_eq(str1: []const u8, str2: []const u8) bool {
		if (std.mem.count(u8, str1, str2) > 0) {
			return true;
		} else {
			return false;
		}
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
	
	try testing.expect(String.is_eq(disp, "letter [1:15]!"));
	
}
