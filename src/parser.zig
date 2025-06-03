const std = @import("std");
const stdout = std.io.getStdOut().writer();
const scn = @import("scanner.zig");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Scanner = scn.Scanner;
pub const Tokens = scn.Tokens;
pub const Token = scn.Token;
pub const TokenType = Token.Type;
const printer = @import("printer.zig");
const puts = printer.puts;
const EnumMap = std.builtin.Type.EnumMap;

// token, shorthand, re-declarations
const BANG_EQUAL = Token.Type.bang_equal;
const EQUAL_EQUAL = Token.Type.equal_equal;
const GREATER = Token.Type.greater;
const GREATER_EQUAL = Token.Type.greater_equal;
const LESS = Token.Type.less;
const LESS_EQUAL = Token.Type.less_equal;

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

// opcodes
pub const OPCode = enum(u8) {
  ERR, // ERROR
  NUM, // NUMBER
  TRU, // TRUE
  FAL, // FALSE
  NAM, // NAME
  ADD, // ADD
  SUB, // SUBTRACT
  MUL, // MULTILPLY
  DIV, // DIVIDE
  MOD, // MODULO
  EOF, // END OF FILE
  
  // const Self = @This();
  
  pub fn to_str(self: OPCode) []const u8 {
    return @tagName(self);
  }
};

pub const OPCodes = ArrayList(OPCode);

// Parsers make an AST? from a series of Tokens found in a Scanner
// So a Scanner is important. It gives us raw tokens. Here we make some sense
// of things, and put together some raw source code. Compiler takes AST and
// makes chunks of OpCodes. In our case, our parser is making those opcodes.
// Kona's interpreter has two modes:, dynamic, and optimized. This Parser spits
// out dynamic OPCodes. The Compiler is more like a JIT compiler, It will
// interpret and optimize our dynamic opcode data as our program runs, and rewrite
// those operations to be Harder, Better, Faster, Stronger.
pub const Parser = struct {
    vm: MageVM,
    scanner: Scanner,
    source: []const u8,
    current: usize = 0,
    previous: usize = 0,
    numParens: usize = 0,
    hasError: bool = false,
    bytecode: OPCodes,
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator, source: []const u8) !Parser {
        var scanner = try Scanner.init(allocator, source);
        try scanner.scan();
        return .{
            .scanner = scanner,
            .source = source,
            .bytecode = OPCodes.init(allocator),
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.scanner.deinit();
    }
    
    // Helper function to get tokens.
    pub fn tokens(self: *Self) Tokens {
        return self.scanner.tokens;
    }

    pub fn isAtEnd(self: *Self) bool {
        return self.current == self.tokens().items.len;
    }
    
    // returns the current token as a token.
    pub fn currentToken(self: *Self) Token {
      return self.tokenAt(self.current);
    }

    // Gets the token at an index,
    // but doesn't get the token if the index is greater than, or equal to
    // the length of the tokens list.
    // Returns a reference.
    pub fn tokenAt(self: *Self, index: usize) Token {
        if (index < self.tokens().items.len) {
            return self.tokens().items[index];
        }
        
        return self.tokens().getLast();
    }
    
    pub fn advance(self: *Self) Token {
        defer self.current += 1;
        return self.tokenAt(self.previous);
    }
    pub fn previousToken(self: *Self) Token {
        return self.tokenAt(self.previous);
    }
    pub fn peek(self: *Self) Token {
        return self.tokenAt(self.current);
    }
    pub fn peekNext(self: *Self) Token {
        return self.tokenAt(self.current + 1);
    }
    pub fn peekNextNext(self: *Self) Token {
        return self.tokenAt(self.current + 2);
    }
    
    /// Error functions
    pub fn errorr(self: *Self, message: []const u8) void {
      self.errorAt(self.tokenAt(self.previous), message);
    }
    
    pub fn errorAtCurrent(self: *Self, message: []const u8) void {
      self.errorAt(self.currentToken(), message);
    }
    
    pub fn errorAt(self:*Self, token: *Token, message: []const u8) !void {
      if (self.panicMode) { return; }
      self.panicMode = true;
      std.debug.print("[line {d}] Error", .{token.line});
      
      switch (token.type) {
          TokenType.EOF => std.debug.print(" at end", .{}),
          TokenType.err => {},
          else => {
              std.debug.print(" at\n", .{token.line});
              std.debug.print(" at '%s'", .{token.literal});
          },
      }
    
      std.debug.print(": %s\n", .{message});
    }

    /// Parsing functions
    
    fn printError(self: *Self, label: []const u8, comptime format: []const u8, args: anytype) !void {
      const al = self.allocator;
      self.parser.hasError = true;
      if (!self.parser.printErrors) return;
      
      const error_message = try std.fmt.allocPrint(al, format, args);
      defer al.free(error_message);
      
      const mod_name = "Main";
      
      const message = try std.fmt.allocPrint(al, "{s}-{s}:{s}", .{label, mod_name,error_message});
      defer al.free(message);
      
      std.debug.print("\n{s}\n", .{message});
    }
    
    // Output a lexical error. That's an error where what the programmer wrote,
    // is clearly wrong. How dare you.
    fn lexError(self: *Self, comptime format: []const u8, args: anytype) void {
      
      // print error
      self.printError("Error", format, args) catch {
        
      };
      
    }
    
    // If we encounter a name,
    fn name(self: *Self) {
      // check for the name in the
      
    }
    
    // parse() represents not just the start of the parsing party,
    // but also the entry to our recursive structures. We use the
    // base token types to enter unique functions that parse out
    // the more complex grammar.
    pub fn parse(self: *Self) !void {
      
      
      
      
      while (!self.isAtEnd()) {
        
        if (self.isAtEnd()) {
          break;
        }
        
        const t = self.advance();
    
        switch (t.type) {
          .name => self.name(),
          // ')' => self.push(.rightParen),
          // '{' => self.push(.leftBrace),
          // '}' => self.push(.rightBrace),
          // '[' => self.push(.leftBracket),
          // ']' => self.push(.rightBracket),
          // '-' => self.push(.minus),
          // '+' => self.push(.plus),
          // '*' => self.push(.star),
          // '/' => {
          //     if (self.peek() == '/') {
          //         continue;
          //     }
          // },
          // '%' => self.push(.modulo),
          // '!' => {
          //     if (self.peek() == '=') {
          //         _ = self.advance();
          //         self.push(.bang_equal);
          //     } else {
          //         self.push(.not);
          //     }
          // },
        }
      }
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
};
