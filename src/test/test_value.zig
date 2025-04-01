const vl = @import("../value.zig");
const Value = vl.Value;
// const Obj = vl.Obj;

const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const testing = std.testing;
const print = std.debug.print;

// Parse a value into a value.


test "Values can be created from strings" {

    // make some strings with values
    // 15
    // 19.99
    // "you suck"
    // main
    // true
    // false

    // Expected values:
    //
    // value { type: .Int, as: ValueAs{.int: 15}}
    // value { type: .Float, as: ValueAs{.int: 19.99}}

}
