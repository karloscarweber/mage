// utils.zig
const std = @import("std");
const ArrayList = std.ArrayList;

const Buffer = ArrayList;

const BytBuffer = Buffer(u8);
const IntBuffer = Buffer(usize);
const StringBuffer = Buffer(String*);
