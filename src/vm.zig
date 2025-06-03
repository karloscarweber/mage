const std = @import("std");
const builtin = @import("builtin");

const MageVM = struct {
  stack: []u8,
  chunks: []u8,
  mode: Mode,

  // Which mode we're running our interpreter in.
  const Mode = enum {
    web,
    mac,
    windows,
    linux,
  }
  
}
