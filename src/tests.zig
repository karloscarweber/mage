const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const print = std.debug.print;
const stdout = std.io.getStdOut().writer();

// for tests
comptime {
    // _ = @import("test/test_root.zig");
    _ = @import("test/test_scanner.zig");
    _ = @import("test/test_parser.zig");
    // _ = @import("test/test_value.zig");
    // _ = @import("test/test_object.zig");
}
