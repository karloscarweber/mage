// test_object.zig

const OBJ = @import("../object.zig");
const ObjType = OBJ.ObjType;
const String = OBJ.String;
const ObjString = OBJ.ObjString;
const ObjClass = OBJ.ObjClass;
const Obj = OBJ.Obj;

const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const testing = std.testing;
const print = std.debug.print;

// TESTS
const expect = testing.expect;

test "That Objects can be made" {
    const thing: Obj = .{
        .type = .function,
        .isDark = false,
        .classObj = null,
        .next = null,
    };
    
    try expect(!thing.isDark);
    
    const otherThing = Obj.init(.function);
    
    try expect(!otherThing.isDark);
}


// test "That Strings can be made" {
//     const stringThing: ObjString = .{
//
//     }
// }
