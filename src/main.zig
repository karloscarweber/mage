const std = @import("std");
const stdout = std.io.getStdOut().writer();
const builtin = @import("builtin");
const allocator = std.heap.page_allocator;

const mage_vm = @import("vm.zig");
const MageVM = mage_vm.MageVM;
const chunks = @import("chunk.zig");
const Chunk = chunks.Chunk;
const Op = chunks.Op;
const vl = @import("value.zig");
const Value = vl.Value;

pub fn main() !void {
    try stdout.print("Mage Running...\n", .{});
    
    var vm = MageVM.init(allocator);
    defer vm.deinit();
    
    var chunk = try Chunk.init(allocator);
    defer chunk.deinit();
    
    const ci = try chunk.addConstant(Value.new.NUMBER(25));
    try chunk.write(Op.constant, 123);
    try chunk.write(ci, 123);
    
    const oi = try chunk.addConstant(Value.new.NUMBER(99));
    try chunk.write(Op.constant, 123);
    try chunk.write(oi, 123);
      
    chunk.disassemble("app.mage");
    
    _ = vm.interpret(&chunk);
    
}
