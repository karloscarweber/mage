const lx = @import("../scanner.zig");
const Scanner = lx.Scanner;
const Token = lx.Token;
// const String = lx.String;

const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const testing = std.testing;
const print = std.debug.print;
// const printer = @import("../printer.zig");
// const puts = printer.puts;

// String comparison helper.
pub const String = struct {
    pub fn is_eq(str1: []const u8, str2: []const u8) bool {
        return std.mem.eql(u8, str1, str2);
    }
};

// TESTS
const expect = testing.expect;

// returns some tokens for tests.
fn ts_some_tokens() Token {
    const token: Token = Token{
        .type = Token.Type.name,
        .start = 15,
        .length = 2,
        .line = 1,
    };
    return token;
}

const small_source_code = "hello friends!";

// Test Scanner fucntiosn
// Scanner.isAtEnd()
test "Scanner functions" {
    var scanner = try Scanner.init(testing.allocator, small_source_code);
    defer scanner.deinit();
    try expect(!scanner.isAtEnd());
    try expect(scanner.peek() == 'h');
    try expect(scanner.advance() == 'h');
    try expect(scanner.advance() == 'e');
    try expect(scanner.advance() == 'l');
    try expect(scanner.peek() == 'l');
    try expect(!scanner.isAtEnd());
}

test "skips whitespace" {
    var scanner = try Scanner.init(testing.allocator, "  hello");
    defer scanner.deinit();

    try scanner.skipWhitespace();
    try expect(scanner.peek() == 'h');
}

fn debugScanner(scanner: *Scanner) void {
    for (scanner.tokens.items) |token| {
        const thing = token.to_str(&scanner.source) catch "shit";
        std.debug.print("{s}\n", .{thing});
    }
}

const big_source_code =
    \\"hello friends
    \\15 + 20
    \\99.999 + 0x0FF0
;

test "scanner scans source code" {
    var scanner = try Scanner.init(testing.allocator, small_source_code);
    defer scanner.deinit();
    try scanner.scan();
    // try debugScanner(&scanner);

    var bigScanner = try Scanner.init(testing.allocator, big_source_code);
    defer bigScanner.deinit();
    try bigScanner.scan();

    // try debugScanner(&bigScanner);

    // try expect(!scanner.isAtEnd());
    // try expect(scanner.peek() == 'h');
    // try expect(scanner.advance() == 'h');
    // try expect(scanner.advance() == 'e');
    // try expect(scanner.advance() == 'l');
    // try expect(scanner.peek() == 'l');
    // try expect(!scanner.isAtEnd());
}

const other_source_code =
    \\"hello friends
    \\15 + 20
    \\99.999 + 0x0FF0
    \\// This is a comment
    \\()
    \\99 - 22 * 11 % 44
    \\[]{}
    \\= something
    \\== !=
    \\ I love it here
    \\ > >= < <=
;

test "scanner scans more code" {
    var scanner = try Scanner.init(testing.allocator, other_source_code);
    defer scanner.deinit();
    try scanner.scan();

    const tokens = scanner.tokens.items;
    const tokenNumber = 48;
    
    expect(tokens.len == tokenNumber) catch {
        debugScanner(&scanner);
        print("[ERROR]: Incorrect number of tokens. Found {d}, expected: {d}.\n", .{ scanner.tokens.items.len, tokenNumber });
    };
}
