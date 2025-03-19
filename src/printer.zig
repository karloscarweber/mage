const std = @import("std");
const stdout = std.io.getStdOut().writer();
const testing = std.testing;

pub inline fn puts(comptime format: []const u8, args: anytype) void {
    stdout.any().print(format, args) catch {
        std.debug.print("What's going on here?", .{});
    };
}
