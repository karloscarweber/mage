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

const Value = struct {
    type: Type,
    as: ValueAs,

    const Type = enum {
        Bool,
        Int,
        Float,
        // Obj
    };
    const ValueAs = union {
        int: i64,
        float: f64
        // obj: *Obj
    };
}
