const std = @import("std");
const stdout = std.io.getStdOut().writer();
const lex = @import("lexer.zig");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Lexer = lex.Lexer;
pub const Tokens = lex.Tokens;
pub const Token = lex.Token;
const printer = @import("printer.zig");
const puts = printer.puts;
const EnumMap = std.builtin.Type.EnumMap;

pub const Precedence = enum {
    NONE,
    ASSIGNMENT,
    OR,
    AND,
    EQUALITY,
    COMPARISON,
    TERM,
    FACTOR,
    UNARY,
    CALL,
    PRIMARY,

    pub fn to_str(self: Precedence) []const u8 {
        return @tagName(self);
    }
};

// pub const FunctionType = enum { function, initializer, method, script };

// SyntaxCode = enum {
//
// };
// Nodes are linked list type of things. They have a type, an optional value, an
// optional name, and an optional list of sub nodes. Nodes behave differently
// based on their type. So a function node will have sub nodes, which is the
// parameters, and what is inside of the nodes. Displaying, or compiling
// different Node types
pub const Node = struct {
    type: Type, // value or operator
    value: ?Value,
    left: ?Node,
    right: ?Node,
    
    pub const Type = enum {
        VALUE, // has one node
            NUMBER,
            NAME,
        // CONDITIONAL, // it's a comparison thing i think
        OPERATOR, // has one node
            OP_ASSIGNMENT, // Assignment: number = 15
            OP_EQUAL, // Equal: 5 == 5
            OP_NOT_EQUAL, // Not Equal: true != false
            OP_GREATER_THAN, // Greater than: 100 > 99
            OP_GREATER_THAN_EQUAL, // Greater than equal: 19 >= 10
            OP_LESS_THAN, // Less than: 9 < 10
            OP_LESS_THAN_EQUAL, // Less than equal: 5 <= 10
            OP_SUB, // subtact 19 - 9
            OP_ADD, // add: 1 + 1
            OP_MUL, // multiply: 10 * 12
            OP_MOD, // modulo: 10 % 12
            OP_DIV, // divide: 5 / 10
            OP_NOT, // unary not: !variable
            OP_NEG, // unary Negative: -15
    };
};

pub const SyntaxNode = Node;

pub const Nodes = ArrayList(Node);

// Parsers make an AST? from a series of Tokens found in a Lexer
// So a Lexer is important. It gives us raw tokens. Here we make some sense
// of things, and put together some raw source code.
// Compiler takes AST and makes chunks of OpCodes.
pub const Parser = struct {
    lexer: Lexer,
    source: []const u8,
    current: usize = 0,
    // previous: usize = 0,
    // hadError: bool = false,
    // panic: bool = false,

    const Self = @This();

    pub fn init(allocator: Allocator, source: []const u8) !Parser {
        const lexer = try Lexer.init(allocator, source);
        return .{
            .lexer = lexer,
            .source = source,
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.lexer.deinit();
    }
    
    // Helper function to get tokens.
    pub fn tokens(self: *Self) *Tokens {
        return &self.lexer.tokens;
    }

    pub fn isAtEnd(self: *Self) bool {
        return self.current == self.tokens().items.len;
    }

    // Gets the token at an index,
    // but doesn't get the token if the index is greater than, or equal to
    // the length of the tokens list.
    // Returns a reference.
    pub fn tokenAt(self: *Self, index: usize) *const Token {
        if (index >= self.tokens().items.len) {
            return &self.tokens().getLast();
        }
        return &self.tokens().items[index];
    }

    pub fn advance(self: *Self) *const Token {
        defer self.current += 1;
        return self.tokenAt(self.current);
    }

    pub fn peek(self: *Self) *Token {
        return self.tokenAt(self.current);
    }
    pub fn peekNext(self: *Self) *Token {
        return self.tokenAt(self.current + 1);
    }
    pub fn peekNextNext(self: *Self) *Token {
        return self.tokenAt(self.current + 2);
    }

    /// Parsing functions

    pub fn grouping(self: *Self) void {
        self.expression();
        self.consume(.leftParen, "Expect ')' after expression");
    }

    pub fn consume(self: *Self, typ: Token.Type, message: []const u8) void {
        if (self.current.type == typ) {
            self.advance();
            return;
        }
        self.errorAtCurrent(message);
    }

    pub fn check(self: *Self, typ: Token.Type) bool {
        return self.current.type == typ;
    }

    pub fn match(self: *Self, types: [Token.Type]) bool {
        if (!self.check(typ)) {
            return false;
        }
        self.advance();
        return true;
    }
    
    const BANG_EQUAL = Token.Type.equal;
    const EQUAL_EQUAL = Token.Type.equal;
    
    pub fn equality(self: *Self) Node {
        var expr = comparison()
        const sequence = [_]token{ BANG_EQUAL, EQUAL_EQUAL, 6 };
        while (match(BANG_EQUAL, EQUAL_EQUAL)) {
            const operator = previous();
            const right = comparision();
            expr = Node.Binary(expr, operator, right);
        }
        
        return expr;
    }
    
    pub fn expression(self: *Self) Node {
        return equality();
        // self.parsePrecedence(.assignment);
    }
    
    // parse() represents not just the start of the parsing party,
    // but also the entry to our recursive structures. We use the
    // base token types to enter unique functions that parse out
    // the more complex grammar.
    pub fn parse(self: *Self) bool {
        while (!self.isAtEnd()) {
            const t = self.advance();
            switch (t.type) {
                .name => {},
                .number => {},
                .newline => {},
                .keyword => {},
                .comment => {},
                else => {
                    continue;
                },
            }
        }
        return true;
    }

    // currentChunk
    // errorAt
    // error
    // errorAtCurrent
    // advance
    // consume
    // check
    // match
    
    
    // expression
    // statement
    // declaration
    // getRule
    // parsePrecedence
    
    
    // and_
    // binary
    // call
    // dot
    // literal
    // grouping
    // number
    // or_
    // string
    
    
    // unary
    // parsePrecedence
    // getRule
    // -- // expression
    
    // declaration
    // statement

    // const ParseFn = fn (canAssign: bool) void;

    // pub const ParseRule = struct { prefix: ?ParseFn, infix: ?ParseFn, precedence: Precedence };

    // pub const rules = EnumMap(Token.Type, ParseRule).init(.{
    //     .leftParen    = .{ grouping, null, .CALL }, // .leftParen,
    //     .rightParen   = .{ null, null, .NONE }, // .rightParen,
    //     .leftBrace    = .{ null, null, .NONE }, // .leftBrace,
    //     .rightBrace   = .{ null, null, .NONE }, // .rightBrace,
    //     .leftBracket  = .{ null, null, .NONE }, // .leftBracket,
    //     .rightBracket = .{ null, null, .NONE }, // .rightBracket,
    //     .name         = .{ null, null, .NONE }, // .name
    //     .number       = .{ null, null, .NONE }, // .number
    //     .symbol       = .{ null, null, .NONE }, // .symbol
    //     .newline      = .{ null, null, .NONE }, // .newline
    //     .keyword      = .{ null, null, .NONE }, // .keyword
    //     .comment      = .{ null, null, .NONE }, // .comment
    // });

//     pub fn parsePrecedence(self: *Self, precedence: Precedence) void {
//         self.advance();
//         const prefixRule: ParseFn = getRule(parse.previous.type).prefix;
//         if (prefixRule == null) {
//             self.errorr("Expect expression.", .{});
//             return;
//         }
//
//         const canAssign: bool = precedence <= Precedence.ASSIGNMENT;
//         prefixRule(canAssign);
//
//         while (precedence <= self.getRule(self.current.type).precedence) {
//             self.advance();
//             const infixRule = getRule(self.previous.type).infix;
//             infixRule(canAssign);
//         }
//
//         if (canAssign and match(.equal)) {
//             self.errorr("Invalid assignment target.");
//         }
//     }
//
//     pub fn getRule(self: *Self, typ: Token.type) *ParseFn {
//         return &self.rules[typ];
//     }

    // error utilities
//     pub fn errorAt(self: *Self, token: *Token, message: []const u8) !void {
//         if (self.panicMode) {
//             return;
//         }
//         self.panicMode = true;
//         puts("[line {d}] Error", .{token.line});
//
//         switch (token.type) {
//             Token.Type.eof => puts(" at end", .{}),
//             Token.Type.err => {},
//             else => {
//                 puts(" at\n", .{token.line});
//                 puts(" at '%s'", .{token.literal});
//             },
//         }
//
//         puts(": %s\n", .{message});
//     }
//
//     pub fn errorr(self: *Self, message: []const u8) void {
//         self.errorAt(&self.previous, message);
//     }
//
//     pub fn errorAtCurrent(self: *Self, message: []const u8) void {
//         self.errorAt(&self.current, message);
//     }
};

// # AST
// The AST separates between scope, names, files, etc...
// Each Chunk belongs to a scope. A scope of 0 means it's
// a file, A global Chunk. Each chunk has a filename too.
// Recompilation of an AST from the same file overwrites
// existing definitions in the Global Scope.
