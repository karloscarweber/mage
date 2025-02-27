const std = @import("std");
const lex = @import("lexer.zig");
const Lexer = lex.Lexer;

pub const OpCode = enum {
    // expressions
	op_constant,
	op_name,
	op_true,
	op_false,
	op_pop,
	op_get_local,
	op_set_local,
	op_get_global,
	op_set_global,
	op_equal,
	op_greater,
	op_less,
	op_add,
	op_subtract,
	op_divide,
	op_multiply,
	op_mod,
	op_jump,
	op_jump_if_false,
	op_loop,
	op_call,
	op_closure,
	op_closure_upvalue,
	op_return,
	op_range,

	pub fn to_str(self: Type) []const u8 {
		return @tagName(self);
	}
};

pub const Chunk = struct {
    count: usize,
    capacity: usize,
    lexer: Lexer,
    name: []const u8,
}
