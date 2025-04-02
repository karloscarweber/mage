// Value.zig
// Values represent values in Mage
//
// Types of Values:
//  * Integer
//  * Float
//  * String
//  * Object - maybe not use this? I don't know
//  * Function
//

// const Obj = struct {
//     name: []const u8,
// };

const std = @import("std");
const ArrayList = std.ArrayList;

pub const Value = struct {
    type: Type,
    as: ValueAs,

    const Self = @This();

    pub const Type = enum {
        Nil,
        Bool,
        Int,
        Float,
    };
    
    pub const ValueAs = union {
        int: i64,
        float: f64
    };

    // Value.init()
    pub fn init() Value {
        return .{
            .type = Type.Nil,
            .as = ValueAs{ .int = 0 }
        };
    }
    
    pub fn new(tyyp: Type, value: ValueAs) Value {
        return .{
            .type = tyyp,
            .as = value
        };
    }
    
    // pub fn deinit(self: *Self) void {
    //     // release everything.
    //     // self.lexer.deinit();
    // }
    
    // value.isBool(), or .isNumber(), returns true or false statement thingys
    pub fn isBool(self: Self) bool { return (self.type == Type.Bool);}
    pub fn isNil(self: Self) bool { return (self.type == Type.Nil);}
    pub fn isNumber(self: Self) bool { return (self.type == Type.Int or self.type == Type.Float);}
};

pub const Values = ArrayList(Value);

pub const ValueArray = struct {
    capacity: usize,
    count: usize,
    values: Values
};