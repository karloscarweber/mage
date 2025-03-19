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
// const EnumField = std.builtin.Type.EnumField;
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

pub const Local = struct {
    name: Token,
    depth: usize,
    isCaptured: bool,
};

pub const Upvalue = struct {
    index: usize,
    isLocal: bool,
};

pub const FunctionType = enum { function, initializer, method, script };

// parsers make AST?
// Compiler takes AST and makes chunks of OpCodes.
pub const Parser = struct {
    lexer: Lexer,
    source: []const u8,
    current: usize = 0,
    previous: usize = 0,
    hadError: bool = false,
    panic: bool = false,

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

    /// Compiler functions

    //
    // pub fn grouping(self: *Self, canAssign: bool) bool {
    pub fn grouping(self: *Self) void {
        self.expression();
        self.consume(.leftParen, "Expect ')' after expression");
    }

    pub fn expression(self: *Self) void {
        self.parsePrecedence(.assignment);
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

    pub fn match(self: *Self, typ: Token.Type) bool {
        if (!self.check(typ)) {
            return false;
        }
        self.advance();
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
    // emitByte
    // emitBytes
    // emitLoop
    // emitJump
    // emitReturn
    // makeConstant
    // emitConstant
    // patchJupm
    // initCompiler
    // endCompiler
    // beginScope
    // endScope
    // expression
    // statement
    // declaration
    // getRule
    // parsePrecedence
    // identifierConstant
    // identifiersEqual
    // resolveLocal
    // addLocal
    // declareVariable
    // parseVariable
    // markInitialized
    // defineVariable
    // argumentList
    // and_
    // binary
    // call
    // dot
    // literal
    // grouping
    // number
    // or_
    // string
    // namedVariable
    // variable
    // sytheticToken
    // super_
    // this_
    // unary
    // parsePrecedence
    // getRule
    // -- // expression
    // block
    // function
    // method
    // classDeclaration
    // funDeclaration
    // varDeclaration
    // expressionStatement
    // forStatement
    // printStatement
    // returnStatement
    // whileStatement
    // synchronize
    // declaration
    // statement
    // compile
    // markCompilerRoots

    //beginScope
    //endScope

    const ParseFn = fn (canAssign: bool) void;

    pub const ParseRule = struct { prefix: ?ParseFn, infix: ?ParseFn, precedence: Precedence };

    pub const rules = EnumMap(Token.Type, ParseRule).init(.{
        .leftParen = .{ grouping, null, .CALL }, // .leftParen,
        .rightParen = .{ null, null, .NONE }, // .rightParen,
        .leftBrace = .{ null, null, .NONE }, // .leftBrace,
        .rightBrace = .{ null, null, .NONE }, // .rightBrace,
        .leftBracket = .{ null, null, .NONE }, // .leftBracket,
        .rightBracket = .{ null, null, .NONE }, // .rightBracket,
        .name = .{ null, null, .NONE }, // .name
        .number = .{ null, null, .NONE }, // .number
        .symbol = .{ null, null, .NONE }, // .symbol
        .newline = .{ null, null, .NONE }, // .newline
        .keyword = .{ null, null, .NONE }, // .keyword
        .comment = .{ null, null, .NONE }, // .comment
    });

    pub fn parsePrecedence(self: *Self, precedence: Precedence) void {
        self.advance();
        const prefixRule: ParseFn = getRule(parse.previous.type).prefix;
        if (prefixRule == null) {
            self.errorr("Expect expression.", .{});
            return;
        }

        const canAssign: bool = precedence <= Precedence.ASSIGNMENT;
        prefixRule(canAssign);

        while (precedence <= self.getRule(self.current.type).precedence) {
            self.advance();
            const infixRule = getRule(self.previous.type).infix;
            infixRule(canAssign);
        }

        if (canAssign and match(.equal)) {
            self.errorr("Invalid assignment target.");
        }
    }

    pub fn getRule(self: *Self, typ: Token.type) *ParseFn {
        return &self.rules[typ];
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

    // error utilities
    pub fn errorAt(self: *Self, token: *Token, message: []const u8) !void {
        if (self.panicMode) {
            return;
        }
        self.panicMode = true;
        puts("[line {d}] Error", .{token.line});

        switch (token.type) {
            Token.Type.eof => puts(" at end", .{}),
            Token.Type.err => {},
            else => {
                puts(" at\n", .{token.line});
                puts(" at '%s'", .{token.literal});
            },
        }

        puts(": %s\n", .{message});
    }

    pub fn errorr(self: *Self, message: []const u8) void {
        self.errorAt(&self.previous, message);
    }

    pub fn errorAtCurrent(self: *Self, message: []const u8) void {
        self.errorAt(&self.current, message);
    }
};

// # AST
// The AST separates between scope, names, files, etc...
// Each Chunk belongs to a scope. A scope of 0 means it's
// a file, A global Chunk. Each chunk has a filename too.
// Recompilation of an AST from the same file overwrites
// existing definitions in the Global Scope.
