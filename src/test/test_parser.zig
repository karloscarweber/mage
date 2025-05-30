const ps = @import("../parser.zig");
const Parser = ps.Parser;
const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const print = std.debug.print;

// TESTS
const expect = testing.expect;

// Test Scanner functions
// Scanner.isAtEnd()
test "Parser functions" {
    var parser = try Parser.init(testing.allocator, "hello friends!");
    defer parser.deinit();
    try expect(parser.parse());
}

test "Parser parses comments correctly" {
    var parser = try Parser.init(testing.allocator, "hello friends!");
    defer parser.deinit();
    try expect(parser.parse());
}
//
// test "Parser does something with our matchers" {
//     var parser = try Parser.init(testing.allocator, "hello friends!");
//     defer parser.deinit();
//     try expect(parser.parse());
// }
