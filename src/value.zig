// Value.zig
// Values represent values in Mage
//
// Types of Values:
//  * Integer
//  * Float
//  * Boolean
//  * Nil
//  * Function
//

const std = @import("std");
const ArrayList = std.ArrayList;

pub const Value = struct {
    as: As,

    const Self = @This();

    pub const As = union(enum) {
        int: i64,
        float: f64,
        boolean: bool,
        nil: void,
    };

    // makes a new Value:
    //
    // const value1 = Value.init(.nil);
    // const value2 = Value.init(.{.int = 15});
    // const value3 = Value.init(.{.float = 0.99});
    pub fn init(value: As) Value {
        return .{.as = value};
    }
    
    pub fn new(value: As) Value {
        return Value.init(value);
    }

    // value.isBool(), or .isNumber(), returns true or false statement thingys
    pub fn isBool(self: Self) bool { 
        switch (self.as) {
            .boolean => return true,
            else => return false,
        }
    }
    
    pub fn isNil(self: Self) bool { 
        switch (self.as) {
            .nil => return true,
            else => return false,
        }
    }
    
    pub fn isNumber(self: Self) bool { 
        switch (self.as) {
            .float, .int => return true,
            else => return false,
        }
    }
    
    pub fn isFalsy(self: Self) bool { 
        const it = self.as;
        switch (it) {
            .float => |floating_point| {
                if (floating_point > 0) { return false; }
                
            }, .int => |integer| {
                if (integer > 0) { return false; }
                
            },
            .boolean => |bl| {
                if (bl == true) { return false; }
            },
            else => return false,
        }
        return true;
    }
    
    pub fn isTruthy(self: Self) bool { 
        return (!self.isFalsy());
    }

};

pub const Values = ArrayList(Value);

pub const ValueArray = struct {
    capacity: usize,
    count: usize,
    values: Values
};
