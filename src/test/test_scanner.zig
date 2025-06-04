const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const allocator = testing.allocator;
const expect = testing.expect;
const print = std.debug.print;

const lx = @import("../scanner.zig");
const Scanner = lx.Scanner;
const Token = lx.Token;

const small_source_code = "hello friends!";

test "Scanner functions" {
    var scanner = try Scanner.init(allocator, small_source_code);
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
    var scanner = try Scanner.init(allocator, "  hello");
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
    var scanner = try Scanner.init(allocator, small_source_code);
    defer scanner.deinit();
    try scanner.scan();
    // try debugScanner(&scanner);

    var bigScanner = try Scanner.init(allocator, big_source_code);
    defer bigScanner.deinit();
    try bigScanner.scan();
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
    var scanner = try Scanner.init(allocator, other_source_code);
    defer scanner.deinit();
    try scanner.scan();

    const tokens = scanner.tokens.items;
    const tokenNumber = 48;
    
    expect(tokens.len == tokenNumber) catch {
        debugScanner(&scanner);
        print("[ERROR]: Incorrect number of tokens. Found {d}, expected: {d}.\n", .{ scanner.tokens.items.len, tokenNumber });
    };
}

test "can end in numbers" {
  var scanner = try Scanner.init(allocator, "Hello Friends 15");
  try scanner.scan();
  defer scanner.deinit();
}

test "can end in hex numbers" {
  var scanner = try Scanner.init(allocator, "Hello Friends 0xAB");
  try scanner.scan();
  defer scanner.deinit();
}
