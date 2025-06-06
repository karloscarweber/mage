const std = @import("std");
const ArrayList = std.ArrayList;
const builtin = @import("builtin");
const ck = @import("chunk.zig");
const Chunk = ck.Chunk;
const Op = ck.Op;
const vl = @import("value.zig");
const Value = vl.Value;
const printValue = vl.printValue;
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const debug = @import("build_options").debug;

const InterpretResult = enum {
  OK,
  COMPILE_ERROR,
  RUNTIME_ERROR,
};

const Instruction = u8;
const STACK_MAX = 256;
const Stack = ArrayList(Value);

pub const MageVM = struct {
  stack: Stack,
  
  // Pointer to the chunk we're currently iterating through.
  chunk: *Chunk = undefined,
  // instruction pointer, pointer to an u8 instruction that is about to be executed
  // in our case, we're just using a usize as an index to the a chunks:
  // chunk.code.items, of u8 bytecode.
  ip: usize = 0,
  // instruction length is how many instructions are in this chunk.
  il: usize = 0,
  mode: Mode = undefined,
  allocator: std.mem.Allocator,
  
  // Which mode we're running our interpreter in.
  const Mode = enum {
    web,
    mac,
    windows,
    linux,
  };
  
  const Self = @This();
  
  pub fn init(allocator: Allocator) MageVM {
    return .{
      .stack = Stack.init(allocator),
      .mode = Mode.mac,
      .allocator = allocator,
    };
  }
  
  pub fn deinit(self: *Self) void {
    self.stack.deinit();
    self.chunk = undefined;
    self.ip = undefined;
    self.mode = undefined;
    self.mode = undefined;
  }
  
  pub fn resetStack(self: *Self) void {
    self.stackTop = 0;
  }
  
  pub fn interpret(self: *Self, chunk: *Chunk) InterpretResult {
    self.chunk = chunk;
    self.ip = 0;
    self.il = chunk.code.items.len;
    return self.run();
  }
  
  // Stack operations
  fn push(self: *Self, value: Value) void {
    self.stack.append(value);
  }
  
  fn pop(self: *Self) Value {
    return self.stack.pop();
  }
  
  // returns the instruction at index
  inline fn op(self: *Self, index: usize) u8 {
    return self.chunk.*.code.items[index];
  }
  
  inline fn read_constant(self: *Self) Value {
    return self.chunk.*.constants.items[self.read_byte()];
  }
  
  inline fn read_byte(self: *Self) u8 {
    defer self.ip = self.ip + 1;
    return self.op(self.ip);
  }
  
  fn run(self: *Self) InterpretResult {
    var instruction: u8 = undefined;
    var response = InterpretResult.OK;
    
    while (self.ip < self.il) {
      instruction = self.read_byte();
      
      if (debug) {
        print("          ", .{});
        for (self.stack.items) |slot| {
          print("[", .{});
          printValue(slot);
          print("]", .{});
        }
        print("\n", .{});

        _ = Op.disassemble(self.chunk, instruction, self.ip-1);
      }
      
      switch (instruction) {
        Op.constant => {
          self.push(self.read_constant());
        },
        Op.RETURN => {
          printValue(self.pop());
          print("\n", .{});
          response = InterpretResult.OK;
          break;
        },
        else => {
          response = InterpretResult.RUNTIME_ERROR;
          break;
        },
      }
      
    }
    
    return response;
  }
  
};

// import tests.
// will only be executed when we're doing tests.
comptime {
    _ = @import("test/test_vm.zig");
}
