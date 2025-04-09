const std = @import("std");
const stdout = std.io.getStdOut().writer();
const builtin = @import("builtin");
const Role = enum { SE, DPE, DE, DA, PM, PO, KS };

const lexer = @import("lexer.zig");

pub fn main() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();

    var area: []const u8 = undefined;
    const role = Role.KS;
    switch (role) {
        .PM, .SE, .DPE, .PO => {
            area = "Platform";
        },
        .DE, .DA => {
            area = "Data & Analytics";
        },
        .KS => {
            area = "Sales";
        },
    }
    try stdout.print("{s}\n", .{area});
    lexer.lex();
}
