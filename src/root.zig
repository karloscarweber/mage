const std = @import("std");
const testing = std.testing;

// I'm using Root as a utility storage center.
// I'm using structs to namespace functions that are
// useful.

// Char helpers
pub const Char = struct {
	
	pub fn isAlphabetic(c: u8) bool {
		return switch (c) {
			'A'...'Z', 'a'...'z' => true,
			else => false,
		};
	}
	
	pub fn isDigit(c: u8) bool {
		return switch (c) {
			'0'...'9' => true,
			else => false,
		};
	}
	
	pub fn isHex(c: u8) bool {
		return switch (c) {
			'0'...'9', 'A'...'F', 'a'...'f', '_' => true,
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

};

// String Helpers
pub const String = struct {
	pub fn is_eq(str1: []const u8, str2: []const u8) bool {
		return std.mem.eql(u8, str1, str2);
	}
	
	pub fn isAlphabetic(str: []const u8) bool {
		for (str) |character| {
			if (!Char.isAlphabetic(character)) {
				return false;
			}
		}
		return true;
	}
	
	pub fn isAlphanumeric(str: []const u8) bool {
		for (str) |character| {
			if (!Char.isAlphanumeric(character)) {
				return false;
			}
		}
		return true;
	}
	
	pub fn isName(str: []const u8) bool {
		for (str) |character| {
			if (!Char.isAlphanumeric(character) and character != '_') {
				return false;
			}
		}
		return true;
	}
	
};
