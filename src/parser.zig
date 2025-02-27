const std = @import("std");
const lex = @import("lexer.zig");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Lexer = lex.Lexer;
const Tokens = Lexer.Tokens;

// AST Nodes
pub const Node = enum {
	op_name,
	op_true,
	op_false,
	op_operator,
	op_loop,
	op_call,
	op_return,
	op_range,

	pub fn to_str(self: Node) []const u8 {
		return @tagName(self);
	}
};

const Nodes = ArrayList(Node);

// parsers make AST?
// Compiler takes AST and makes chunks of OpCodes.
pub const Parser = struct {
	lexer: Lexer,
	source: []const u8,
	nodes: Nodes,

	// panic mode
	panic: bool = false,
	current: usize,


	const Self = @This();

	pub fn init(allocator: Allocator, source: []const u8) !Parser {
		const lexer = try Lexer.init(allocator, source);
		return .{
			.lexer = lexer,
			.source = source,
			.nodes = Nodes.init(allocator),
		};
	}

	pub fn deinit(self: *Self) void {
		self.lexer.deinit();
	}

	// helper access methods
	pub fn tokens(self: *Self) *Tokens {
		return &self.lexer.tokens;
	}

	pub fn isAtEnd(self: *Self) bool {
		return self.current == lexer.tokens.len-1;
	}

	pub fn parse(self: *Self) bool {
		_ = self;
		return true;

		while (!self.isAtEnd()) {

		}
	}

};

// # AST
// The AST separates between scope, names, files, etc...
// Each Chunk belongs to a scope. A scope of 0 means it's
// a file, A global Chunk. Each chunk has a filename too.
// Recompilation of an AST from the same file overwrites
// existing definitions in the Global Scope.
