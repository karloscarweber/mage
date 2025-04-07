// vm.zig
const std = @import("std");
const val = @import("value.zig");
const Value = val.Value
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const Code = enum {
  CODE_
};

const Instruction = struct {
  type: []const u8,
  value: ?*Value, // optional Value Pointer, as evidenced by the ?
  const Self = @This();
  
  pub fn init(allocator: Allocator,  tulip: Type,  value: ?*Value) Instruction {
    var instruction =  .{
      .type = tulip,
    };
    
    if (value) |*val| {
      instruction.value = val;
    }
    return instruction;
  }
  
  // Instruction Type
  const Type = enum {
    add,
    subtract,
    multiply,
    divide,
    call,
    sum
  };
  
}


// Call Frame
// ca
const CallFrame = struct {
  // ip  is instruction pointer
  ip: pointer_to_instruction
}

const FrameList = ArrayList(CallFrame);

// VM

const vm = stuct {
  frames: 
}