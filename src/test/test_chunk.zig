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

test "Scanner functions" {
    var chunk = try Chunk.init(allocator);
    defer chunk.deinit();
    try chunk.write(Op.RETURN);
    try expect(chunk.count() == 1);
    
    expect(@intFromEnum(Op.RETURN) == 24) catch {
      const operation: Op = @enumFromInt(24);
      print("Wrong Token; Found [{s}], expected: [{s}].\n", .{ Op.RETURN.to_str(), operation.to_str()});
    };
    
    chunk.disassemble("app.kona");
}
