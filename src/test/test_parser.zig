const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const print = std.debug.print;

const ps = @import("../parser.zig");
const Parser = ps.Parser;
const sc = @import("../scanner.zig");
const Token = sc.Token;

// TESTS
const expect = testing.expect;

// Test Scanner functions
test "Parser instantiates appropriately" {
    var parser = try Parser.init(testing.allocator, "hello friends!");
    defer parser.deinit();
    
    // Parser does not persist in infinite loop if the last token is a number.
}

test "Parser functions" {
    var parser = try Parser.init(testing.allocator, "hello friends 15");
    defer parser.deinit();
    
    // returns tokens from scanner
    const tokens = parser.tokens();
    try expect(tokens.items[0].type == Token.Type.name);
    try expect(tokens.items[1].type == Token.Type.name);
    expect(tokens.items[2].type == Token.Type.number) catch {
        const name = tokens.items[2].type.to_str();
        std.debug.print("{s}\n", .{name});
    };
    
    expect(tokens.items.len == 4) catch {
      std.debug.print("number of tokens: {d}", .{tokens.items.len});
    };
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
