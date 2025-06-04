// Test the root thing

const root = @import("../root.zig");
const Char = root.Char;
const String = root.String;

const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const print = std.debug.print;

test "Char helpers work" {
    const slicer = "Hello_Friends";
    try expect('H' == slicer[0]);
    try expect(Char.isAlphabetic(slicer[0]));
}

test "String helpers work" {
    const slicer = "jork_4794348";
    try expect(!String.isAlphabetic(slicer));

    try expect(String.isName("jork_"));

    const slicer3 = "jork _4794348";
    try expect(!String.isAlphanumeric(slicer3));
}
