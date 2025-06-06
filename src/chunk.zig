const std = @import("std");
const scn = @import("scanner.zig");
const Scanner = scn.Scanner;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const print = std.debug.print;
const val = @import("value.zig");
const Value = val.Value;
const Values = val.Values;

pub const Op = struct {
  
  pub const constant: u8        = 0x00;
  pub const name: u8            = 0x01;
  pub const TRUE: u8            = 0x02;
  pub const FALSE: u8           = 0x03;
  pub const pop: u8             = 0x04;
  pub const get_local: u8       = 0x05;
  pub const set_local: u8       = 0x06;
  pub const get_global: u8      = 0x07;
  pub const set_global: u8      = 0x08;
  pub const equal: u8           = 0x09;
  pub const greater: u8         = 0x0A;
  pub const less: u8            = 0x0B;
  pub const add: u8             = 0x0C;
  pub const subtract: u8        = 0x0D;
  pub const divide: u8          = 0x0E;
  pub const multiply: u8        = 0x0F;
  pub const mod: u8             = 0x10;
  pub const jump: u8            = 0x11;
  pub const jump_if_false: u8   = 0x12;
  pub const loop: u8            = 0x13;
  pub const call: u8            = 0x14;
  pub const closure: u8         = 0x15;
  pub const closure_upvalue: u8 = 0x16;
  pub const range: u8           = 0x17;
  pub const RETURN: u8          = 0x18;
  
  pub fn to_str(code: u8) []const u8 {
    return OPS.to_str(code);
  }
  
  pub const OPS = enum(u8) {
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
    
    pub fn to_str(code: u8) []const u8 {
      const thing: OPS = @enumFromInt(code);
      return @tagName(thing);
    }
    
  };
  
  pub fn disassemble(chunk: *Chunk, operation: u8, index: usize) bool {
    return switch (operation) {
        Op.constant => Op.constantInstruction(chunk, operation, index),
        Op.RETURN => Op.simpleInstruction(operation),
        else => {
          print("unknown opcode {X} : {d}\n", .{operation, operation});
          return false;
        },
    };
  }
  
  pub fn constantInstruction(chunk: *Chunk, operation: u8, index: usize) bool {
    const constant_index = chunk.*.code.items[index + 1];
    var const_value = chunk.*.constants.items[constant_index];
    print("0x{X}  {s}: {s}\n", .{operation, OPS.to_str(operation), const_value.to_str()});
    return true;
  }
  
  pub fn simpleInstruction(operation: u8) bool {
    print("0x{X}  {s}\n", .{operation, OPS.to_str(operation)});
    return false;
  }
  
};

const OpCode = u8;
const Code = ArrayList(OpCode);
const Lines = ArrayList(u8);

pub const Chunk = struct {
  allocator: Allocator,
  code: Code,
  lines: Lines,
  constants: Values,
  
  const Self = @This();
  pub fn init(allocator: Allocator) !Chunk {
    return .{
      .allocator = allocator,
      .code = Code.init(allocator),
      .lines = Lines.init(allocator),
      .constants = Values.init(allocator),
    };
  }
  
  pub fn deinit(self: *Self) void {
    self.code.deinit();
    self.lines.deinit();
    self.constants.deinit();
  }
  
  pub fn write(self: *Self, byte: u8, line: u8) !void {
    try self.code.append(byte);
    try self.lines.append(line);
  }
  
  pub fn addConstant(self: *Self, value: Value) !u8 {
    try self.constants.append(value);
    // we're casting this down to a u8, as we're storing the index
    // of this constant in our bytecode, and our bytecode is bytes.
    const truncated_index: u8 = @truncate(self.constants.items.len - 1);
    return truncated_index;
  }
  
  // debugger methods
  pub fn disassemble(self: *Self, name: []const u8) void {
    print("\n== {s} ==\n", .{name});
    var skipNext = false;
    for (0.., self.code.items) |index, code| {
        if (skipNext) {
          skipNext = false;
          continue;
        }
        print("{d:0>4} ", .{index});
        if (index > 0 and self.lines.items[index] == self.lines.items[index - 1]) {
          print("   | ", .{});
        } else {
          print("{d: >4} ", .{self.lines.items[index]});
        }
        skipNext = Op.disassemble(self, code, index);
    }
  }
};
