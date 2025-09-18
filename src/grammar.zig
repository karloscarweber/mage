// grammar.zig
const std = @import("std");
const stdout = std.io.getStdOut().writer();
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const printer = @import("printer.zig");
const puts = printer.puts;

const grammar =
\\  Mage {
\\    Expr = number
\\
\\    //+ 15, 16.99, 0x45
\\    number = digit+
\\
\\    //+ "x", "élan", "_", "_99"
\\    //- "1", "$nope"
\\    identifier = ~keyword identStart identPart*
\\    identStart = letter | "_"
\\    identPart = identStart | digit
\\    Type = Capital identPart*
\\  }
\\
;
