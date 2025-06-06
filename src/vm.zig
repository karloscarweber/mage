const std = @import("std");
const builtin = @import("builtin");
const ck = @import("chunk.zig");
const Chunk = ck.Chunk;
const Op = ck.Op;
const vl = @import("value.zig");
const Value = vl.Value;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const InterpretResult = enum {
  OK,
  COMPILE_ERROR,
  RUNTIME_ERROR,
};

const Instruction = u8;

pub const MageVM = struct {
  stack: []u8 = undefined,
  chunk: *Chunk = undefined,
  ip: *[]Instruction = undefined, // instruction pointer, pointer to an u8 instruction that is about to be executed
  mode: Mode = undefined,
  allocator: std.mem.Allocator,
  
  const Self = @This();
  
  pub fn init(allocator: Allocator) MageVM {
    return .{
      .stack = undefined,
      .mode = Mode.mac,
      .allocator = allocator,
    };
  }
  
  pub fn deinit(self: *Self) void {
    self.stack = undefined;
    self.chunk = undefined;
    self.ip = undefined;
    self.mode = undefined;
    self.mode = undefined;
  }
  
  // Which mode we're running our interpreter in.
  const Mode = enum {
    web,
    mac,
    windows,
    linux,
  };
  
  pub fn interpret(self: *Self, chunk: *Chunk) InterpretResult {
    self.chunk = chunk;
    self.ip = &self.chunk.code.items;
    return self.run();
  }
  
  inline fn read_constant(self: MageVM) Value {
    return self.chunk.constants.values.items[read_byte(self)];
  }
  
  inline fn read_byte(self: MageVM) u8 {
    defer self.ip = self.ip + 1;
    return self.ip;
  }
  
  fn run(self: *Self) InterpretResult {
    var instruction: u8 = undefined;
    while (true == true) {
      instruction = read_byte(self.*).*;
      
      switch (instruction) {
        Op.constant => {
          const constant = read_constant(self);
          print("{s}", constant.to_str());
          print("\n", .{});
          break;
        },
        Op.RETURN => {
          return InterpretResult.OK;
        }
      }
      
    }
    
    return InterpretResult.OK;
  }
  
};

// import tests.
// will only be executed when we're doing tests.
comptime {
    _ = @import("test/test_vm.zig");
}
