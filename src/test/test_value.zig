const vl = @import("../value.zig");
const Value = vl.Value;

const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const testing = std.testing;
const print = std.debug.print;
// const NIL = vl.NIL;

// TESTS
const expect = testing.expect;

// Parse a value into a value.

pub const Ass = union(enum) {
    int: i64,
    float: f64,
    boolean: bool,
    nil,
};

test "Figure out unions" {
    const thing = Ass{ .int = 10 };
    try expect(thing.int == 10);
}

test "Values can be created" {
    const nilValue = Value.new(.nil);
    const intValue = Value.init(.{ .int = 15 });
    const floatValue = Value.init(.{ .float = 15.55 });

    try expect(nilValue.isNil());
    try expect(intValue.isNumber());
    try expect(floatValue.isNumber());

    const numberValue = 15;
    try expect(intValue.as.int == numberValue);

    const floatTest = 15.55;
    try expect(floatValue.as.float == floatTest);
}

test "Bool Values can be created" {
    const boolValue = Value.init(.{ .boolean = false });
    try expect(boolValue.isFalsy());
    try expect(!boolValue.isTruthy());

    const trueValue = Value.init(.{ .boolean = true });
    try expect(trueValue.isTruthy());

    const falseValue = Value.init(.{ .boolean = false });
    try expect(falseValue.isFalsy());

    const wrong = Value{ .as = .{ .boolean = false } };
    try expect(wrong.isFalsy());

    const whatever = Value.new(.{ .boolean = false });
    try expect(whatever.isFalsy());
}

test "Values can be made from strings" {
    // make values with strings
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
