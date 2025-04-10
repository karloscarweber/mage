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
    const nilValue = Value.new.NIL();
    const intValue = Value.new.NUMBER(15);
    const floatValue = Value.new.NUMBER(15.55);

    try expect(nilValue.isNil());
    try expect(intValue.isNumber());
    try expect(floatValue.isNumber());

    const numberValue = 15;
    try expect(intValue.as.num == numberValue);

    const floatTest = 15.55;
    try expect(floatValue.as.num == floatTest);
}

test "Bool Values can be created" {
    const boolValue = Value.new.FALSE();
    try expect(boolValue.isFalsy());
    try expect(!boolValue.isTruthy());

    const trueValue = Value.new.TRUE();
    try expect(trueValue.isTruthy());

    const falseValue = Value.new.FALSE();
    try expect(falseValue.isFalsy());

    const wrong = Value.new.FALSE();
    try expect(wrong.isFalsy());

    const whatever = Value.new.FALSE();
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
