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
// All values, save for functions, are Box types. Copying the Value
// copies the value. Functions are reference types.

const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const ObjType = enum {
    function,
    string,
};

const Obj = struct {
    type: ObjType,
    isDark: bool,
    next: *Obj,
    
    const Self = @This();
};

pub const ValueType = enum {
    val_false,
    val_nil,
    val_true,
    val_num,
    val_obj,
};

pub const Value = struct {
    type: ValueType,
    as: As,

    const Self = @This();

    pub const As = union(enum) {
        num: f64,
        obj: *Obj,
    };

    pub fn init(value: As, val_type: ValueType) Value {
        return .{.as = value, .type = val_type};
    }

    pub const new = struct {
        pub fn FALSE() Value {
            return Value.init(.{.num = 0}, .val_false);
        }
        pub fn NIL() Value {
            return Value.init(.{.num = 0}, .val_nil);
        }
        pub fn TRUE() Value {
            return Value.init(.{.num = 1}, .val_true);
        }
        pub fn NUMBER(number: f64) Value {
            return Value.init(.{.num = number}, .val_num);
        }
        pub fn OBJECT(obj: f64) Value {
            return Value.init(.{.obj = obj}, .val_obj);
        }
    };

    // value.isBool(), or .isNumber(), returns true or false statement thingys
    pub fn isBool(self: Self) bool {
        switch (self.type) {
            .val_false, .val_true => return true,
            else => return false,
        }
    }
    
    pub fn isNil(self: Self) bool {
        switch (self.type) {
            .val_nil => return true,
            else => return false,
        }
    }
    
    pub fn isNumber(self: Self) bool {
        switch (self.type) {
            .val_num => return true,
            else => return false,
        }
    }
    
    pub fn isFalsy(self: Self) bool {
        switch (self.type) {
            .val_false, .val_nil => { return true; },
            .val_num => {
                switch (self.as) {
                    .num => { if (self.as.num == 0) {
                        return true;
                    } },
                    else => { return false; }
                }
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
    values: Values,
    
    pub fn init(allocator: Allocator) !ValueArray {
        return .{
            .capacity =  0,
            .count =  0,
            .values =  Values.init(allocator),
        };
    }
};
