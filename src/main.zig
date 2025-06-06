const std = @import("std");
const stdout = std.io.getStdOut().writer();
const builtin = @import("builtin");
const Role = enum { SE, DPE, DE, DA, PM, PO, KS };

pub fn main() !void {
    try stdout.print("Mage Running...\n", .{});
}
