const vl = @import("../value.zig");
const Value = vl.Value;

const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const testing = std.testing;
const print = std.debug.print;

// TESTS
const expect = testing.expect;

// Parse a value into a value.

test "Values can be created" {
    const val = Value.ValueAs{ .int = 0 };
    const nilValueOne = Value.new(Value.Type.Nil, val);
    
    const nilValue = Value.init();
    
    const val2 = Value.ValueAs{ .int = 15 };
    const intValue = Value.new(Value.Type.Int, val2);

    try expect(nilValueOne.isNil());
    try expect(nilValue.isNil());
    try expect(intValue.isNumber());
    const numberValue = 15;
    try expect(intValue.as.int == numberValue);
    
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
