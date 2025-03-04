const std = @import("std");
const lex = @import("lexer.zig");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Lexer = lex.Lexer;
pub const Tokens = lex.Tokens;
pub const Token = lex.Token;

pub const Precedence = enum {
	NONE,
	ASSIGNMENT,
	OR,
	AND,
	EQUALITY,
	COMPARISON,
	TERM,
	FACTOR,
	UNARY,
	CALL,
	PRIMARY

	pub fn to_str(self: Node) []const u8 {
		return @tagName(self);
	}
};

// static void grouping(bool canAssign) {
const ParseFn = fn (canAssign: bool) void;


pub const ParseRule = struct {
	prefix: ?ParseFn,
	infix: ?ParseFn,
	precedence: Precedence
}

pub const rules = []ParseRule{
	.{}, // Token.Type.name
	.{}, // Token.Type.number
	.{}, // Token.Type.symbol
	.{}, // Token.Type.newline
	.{}, // Token.Type.keyword
	.{}, // Token.Type.comment
};





// AST Nodes
// pub const Node = struct {
// 	operation: Operation,
// 	token: Token,

// 	pub const Operation = enum {
// 		op_name,
// 		op_true,
// 		op_false,
// 		op_operator,
// 		op_loop,
// 		op_call,
// 		op_return,
// 		op_range,

// 		pub fn to_str(self: Node) []const u8 {
// 			return @tagName(self);
// 		}
// 	}

// 	pub fn to_str(self: Node) []const u8 {
// 		return @tagName(self);
// 	}
// };

// const Nodes = ArrayList(Node);

// parsers make AST?
// Compiler takes AST and makes chunks of OpCodes.
pub const Parser = struct {
	lexer: Lexer,
	source: []const u8,
	current: Token = 0,
	previous: Token = 0,
	hadError: bool = false,
	panic: bool = false,

	const Self = @This();

	// pub fn init(allocator: Allocator, source: []const u8) !Parser {
	pub fn init(source: []const u8) !Parser {
		// const lexer = try Lexer.init(allocator, source);
		return .{
			.lexer = lexer,
			.source = source,
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
		return self.current == self.tokens().items.len;
	}

	// gets the token at an index.
	pub fn tokenAt(self: *Self, index: usize) *const Token {
		if (index >= self.tokens().items.len) {
			return &self.tokens().getLast();
		}
		return &self.tokens().items[index];
	}

	pub fn advance(self: *Self) *const Token {
		defer self.current += 1;
		return self.tokenAt(self.current);
	}

	pub fn peek(self: *Self) *Token {
		return self.tokenAt(self.current);
	}
	pub fn peekNext(self: *Self) *Token {
		return self.tokenAt(self.current + 1);
	}
	pub fn peekNextNext(self: *Self) *Token {
		return self.tokenAt(self.current + 2);
	}

	// currentChunk
	// errorAt
	// error
	// errorAtCurrent
	// advance
	// consume
	// check
	// match
	// emitByte
	// emitBytes
	// emitLoop
	// emitJump
	// emitReturn
	// makeConstant
	// emitConstant
	// patchJupm
	// initCompiler
	// endCompiler
	// beginScope
	// endScope
	// expression
	// statement
	// declaration
	// getRule
	// parsePrecedence
	// identifierConstant
	// identifiersEqual
	// resolveLocal
	// addLocal
	// declareVariable
	// parseVariable
	// markInitialized
	// defineVariable
	// argumentList
	// and_
	// binary
	// call
	// dot
	// literal
	// grouping
	// number
	// or_
	// string
	// namedVariable
	// variable
	// sytheticToken
	// super_
	// this_
	// unary
	// parsePrecedence
	// getRule
	// expression
	// block
	// function
	// method
	// classDeclaration
	// funDeclaration
	// varDeclaration
	// expressionStatement
	// forStatement
	// printStatement
	// returnStatement
	// whileStatement
	// synchronize
	// declaration
	// statement
	// compile
	// markCompilerRoots

	//beginScope
	//endScope



	// parse() represents not just the start of the parsing party,
	// but also the entry to our recursive structures. We use the
	// base token types to enter unique functions that parse out
	// the more complex grammar.
	pub fn parse(self: *Self) bool {
		while (!self.isAtEnd()) {
			const t = self.advance();
			switch (t.type) {
				.name => {
				},
				.number => {
				},
				.symbol => {
				},
				.newline => {
				},
				.keyword => {
				},
				.comment => {
				}
			}
		}
		return true;
	}

};

// # AST
// The AST separates between scope, names, files, etc...
// Each Chunk belongs to a scope. A scope of 0 means it's
// a file, A global Chunk. Each chunk has a filename too.
// Recompilation of an AST from the same file overwrites
// existing definitions in the Global Scope.
