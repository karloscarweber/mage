const std = @import("std");
const scn = @import("scanner.zig");
const Scanner = scn.Scanner;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const print = std.debug.print;

pub const Op = enum(u8) {
  // expressions
  constant,
  name,
  TRUE,
  FALSE,
  pop,
  get_local,
  set_local,
  get_global,
  set_global,
  equal,
  greater,
  less,
  add,
  subtract,
  divide,
  multiply,
  mod,
  jump,
  jump_if_false,
  loop,
  call,
  closure,
  closure_upvalue,
  range,
  RETURN,
  
  pub fn int(self: Op) u8 {
    return @intFromEnum(self);
  }
  
  pub fn to_str(self: Op) []const u8 {
    return @tagName(self);
  }
  
  pub fn disassemble(self: Op) void {
    if (self == Op.RETURN) {
      self.simpleInstruction();
    } else {
      print("unknown opcode {s}\n", .{self.to_str()});
    }
  }
  pub fn simpleInstruction(self: Op) void {
    print("{s}\n", .{self.to_str()});
  }
};

const OpCode = Op;
const Code = ArrayList(OpCode);

pub const Chunk = struct {
  allocator: Allocator,
  code: Code,
  
  const Self = @This();
  pub fn init(allocator: Allocator) !Chunk {
    return .{
      .code = Code.init(allocator),
      .allocator = allocator
    };
  }
  
  pub fn deinit(self: *Self) void {
    self.code.deinit();
  }
  
  pub fn count(self: *Self) usize {
    return self.code.items.len;
  }
  
  pub fn write(self: *Self, byte: Op) !void {
    try self.code.append(byte);
  }
  
  // debugger methods
  pub fn disassemble(self: *Self, name: []const u8) void {
    print("\n== {s} ==\n", .{name});
    for (self.code.items) |code| {
        code.disassemble();
    }
  }

};
