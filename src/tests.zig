const std = @import("std");
const builtin = @import("builtin");

// for tests
comptime {
    _ = @import("test/test_root.zig");
    _ = @import("test/test_scanner.zig");
    // _ = @import("test/test_parser.zig");
    _ = @import("test/test_value.zig");
    _ = @import("test/test_chunk.zig");
    _ = @import("test/test_object.zig");
    _ = @import("test/test_vm.zig");
}
