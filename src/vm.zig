const std = @import("std");
const builtin = @import("builtin");
const ck = @import("chunk.zig");
const Chunk = ck.Chunk;
const Op = ck.Op;
const vl = @import("value.zig");
const Value = vl.Value;
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const debug = @import("build_options").debug;

const InterpretResult = enum {
  OK,
  COMPILE_ERROR,
  RUNTIME_ERROR,
};

const Instruction = u8;

pub const MageVM = struct {
  stack: []u8 = undefined,
  chunk: *Chunk = undefined,
  // instruction pointer, pointer to an u8 instruction that is about to be executed
  // in our case, we're just using a usize as an index to the a chunks:
  // chunk.code.items, of u8 bytecode.
  ip: usize = 0,
  // instruction length is how many instructions are in this chunk.
  il: usize = 0,
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
    self.ip = 0;
    self.il = chunk.code.items.len;
    return self.run();
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
        _ = Op.disassemble(self.chunk, instruction, self.ip-1);
      }
      
      switch (instruction) {
        Op.constant => {
          if (debug) {
            _ = self.read_constant();
            // const str = constant.to_str();
            // print("{s}\n", .{str});
          } else {
            _ = self.read_constant();
          }
        },
        Op.RETURN => {
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
