const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const allocator = testing.allocator;
const expect = testing.expect;
const print = std.debug.print;

const chk = @import("../chunk.zig");
const Chunk = chk.Chunk;
const Op = chk.Op;

const vl = @import("../value.zig");
const Value = vl.Value;

test "Basic Chunk Functions" {
    var chunk = try Chunk.init(allocator);
    defer chunk.deinit();
    try chunk.write(Op.RETURN);
    try expect(chunk.code.items.len == 1);
    
    const operation: u8 = 0x17;
    expect(Op.RETURN == operation) catch {
      print("Wrong Token; Found [{s}], expected: [{s}].\n", .{ Op.to_str(Op.RETURN), Op.to_str(operation)});
    };
    
    chunk.disassemble("app.mage");
}

test "Adding Constants" {
  var chunk = try Chunk.init(allocator);
  defer chunk.deinit();
  
  const constant_index = try chunk.addConstant(Value.new.NUMBER(25));
  try chunk.write(Op.constant);
  try chunk.write(constant_index);
  
  chunk.disassemble("app.mage");
}
