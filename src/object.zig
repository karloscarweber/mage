// object.zig

// We'll be making objects, but they will be little ones. Like,
// just for functions and stuff.

const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub const ObjType = enum {
    function,
    string,
};

pub const String = ArrayList(u8);

// Strings support.
pub const ObjString = struct {
    obj: Obj,
    length: u32,
    hash: u32,
    value: String = undefined, // String, represents an

    const Self = @This();

    // makes an object string from an array of bytes
    pub fn init(allocator: Allocator, string: []const u8, object: *Obj) !ObjString {
        const str = String.init(allocator);
        try str.appendSlice(string);

        return .{
            .obj = object,
            .length = string.len,
            .hash = "FSADSiougy9huioj",
            .string = str
        };
    }
};

pub const ObjClass = struct {
    obj: Obj,
    superclass: ObjClass,
    name: *ObjString
};

pub const Obj = struct {
    type: ObjType,
    isDark: bool,
    classObj: ?*Obj,
    next: ?*Obj,
    
    const Self = @This();
    
    pub fn init(objType: ObjType) Obj {
        return .{
            .type = objType,
            .isDark = false,
            .classObj = null,
            .next = null,
        };
    }
};
