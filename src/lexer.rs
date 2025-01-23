// lexer.rs
use std::fmt;

// So this is the lexer.
// We're going to lex stuff, from a simple Grammar.

// null terminating byte
const EOF: char = '\0';

//
// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
// pub struct Token {
// 	start: i32,
// 	length: i32,
// 	lexeme: String,
// }

//
// pub enum TokenType {
// 	Name,
// 	Number, //
// 	Plus, // +
// 	Minus, // -
// 	Star, // *
// 	Slash, // /
// 	Modulo, // %
// 	LeftParen, // (
// 	RightParen, // )
// 	LeftCurly, // {
// 	RightCurly, // }
// 	Equals, // =
// 	Pound, // #
//  Newline, // \n, newlines end expressions/statements.
// 	// keywords
// 	Fun, // "fun", function declaration
// 	Sum, // "sum" the stuff up.
// }

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TokenType {
	Dot, Minus, Plus, Bang, Slash, Modulo,
	
	LeftParen, RightParen,
	LeftBrace, RightBrace,
	Equal, Hash, Comma,
	
	Name, String, Number,
	
	Fun, Newline,
	
	Error, Eof
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Token {
	pub typ: TokenType,
	pub start: usize,
	pub length: usize,
	pub line: usize,
}

impl fmt::Display for Token {
	fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
		match self.typ {
			TokenType::Name => write!(f, "{}", "[Name]"),
			TokenType::String => write!(f, "{}", "[String]"),
			TokenType::Number => write!(f, "{}", "[Name]"),
			_ => write!(f, "{}", "well this is awkward.")
		}
	}
}

pub struct Lexer {
	pub source: String,
	pub start: usize,
	pub current: usize,
	pub line: usize,
	pub tokens: Vec<Token>,
}

pub fn is_alpha(c: char) -> bool {
	match c {
		'a'..='z' | 'A'..='Z' | '_' => true,
		_ => false
	}
}

pub fn is_digit(c: char) -> bool {
	match c {
		'0'..='9' => true,
		_ => false
	}
}

impl Lexer {
	pub fn new(input: &str) -> Lexer {
		let source = input.to_string();
		
		// let length = source.len();
		Lexer {
			source,
			start: 0, // is current or start
			current: 0,
			line: 1,
			tokens: vec![]
		}
	}
	
	pub fn is_at_end(&self) -> bool {
		self.current == self.source.len()
	}
	
	// returns a legit character, or the EOF null terminating byte.
	fn char_at(&self, index: usize) -> char {
		if index < self.source.len() {
			return self.source[index..=index].chars().next().unwrap()
		}
		EOF
	}
	
	pub fn current(&self) -> char {
		self.char_at(self.current)
	}
	
	pub fn advance(&mut self) -> char {
		self.current += 1;
		self.char_at(self.current-1)
	}
	
	pub fn peek(&self) -> char {
		self.char_at(self.current)
	}
	
	fn peek_next(&self) -> char {
		if self.is_at_end() {
			return EOF
		}
		self.char_at(self.current+1)
	}
	
	fn make_token(&self, typ: TokenType) -> Token {
		Token {
			typ,
			start: self.start,
			length: self.current - self.start,
			line: self.line,
		}
	}
	
	// pushes a token onto the stack.
	fn push(&mut self, typ: TokenType) {
		self.tokens.push(Token {
			typ,
			start: self.start,
			length: self.current - self.start,
			line: self.line,
		});
	}
	
	// pub fn lexeme(&mut self) -> &str {
	// 	&self.source[self.start..=self.next]
	// }
	
	fn skip_whitespace(&mut self) {
		loop {
			let c = self.peek();
			match c {
				' ' | '\r' | '\t' => {
					self.advance();
				},
				'\n' => {
					self.line += 1;
					self.advance();
				},
				'/' => {
					if self.peek_next() == '/' {
						while self.peek() != '\n' && !self.is_at_end() {
							self.advance();
						}
					} else {
						return
					}
				},
				_ => {
					return
				}
			}
		}
	}
	
	fn identifier(&mut self) {
		while is_alpha(self.peek()) || is_digit(self.peek()) { self.advance(); }
		self.push(self.identifier_type())
	}
	
	fn identifier_type(&self) -> TokenType {
		return match self.char_at(self.start) {
			'f' => {
				self.check_keyword("fn", TokenType::Fun)
			},
			_ => TokenType::Name,
		}
	}
	
	fn check_keyword(&self, expected: &str, typ: TokenType) -> TokenType {
		let lexeme = &self.source[self.start..=self.current];
		if expected == lexeme {
			return typ
		}
		TokenType::Name
	}
	
	fn number(&mut self) {
		while is_digit(self.peek()) { self.advance(); }
		
		if self.peek() == '.' && is_digit(self.peek_next()) {
			self.advance();
			
			while is_digit(self.peek()) { self.advance(); }
		}
		
		self.push(TokenType::Number)
	}
	
	// scans everything and makes tokens.
	pub fn scan(&mut self) {
		while !self.is_at_end() {
			self.skip_whitespace();
			self.start = self.current;
			
			if self.is_at_end() { self.push(TokenType::Eof); break; }
			
			let c = self.advance();
			
			if is_alpha(c) { self.identifier(); continue; }
			if is_digit(c) { self.number(); continue; }
			
			match c {
				'.' => self.push(TokenType::Dot),
				'-' => self.push(TokenType::Minus),
				'+' => self.push(TokenType::Plus),
				'*' => self.push(TokenType::Bang),
				'/' => self.push(TokenType::Slash),
				'%' => self.push(TokenType::Modulo),
				
				'(' => self.push(TokenType::LeftParen),
				')' => self.push(TokenType::RightParen),
				'{' => self.push(TokenType::LeftBrace),
				'}' => self.push(TokenType::RightBrace),
				
				'=' => self.push(TokenType::Equal),
				'#' => self.push(TokenType::Hash),
				',' => self.push(TokenType::Comma),
				
				// TODO: later, add function and new line support.
				// Fun, Newline,
				
				// '"' => self.string(),
				
				_ => self.push(TokenType::Error),
			}
			
		}
		
	}
	
}

#[cfg(test)]
mod tests {
	use super::*;
	
	#[test]
	fn lexer_fn_is_alpha() {
		let s = "a".chars().next().unwrap();
		assert!(is_alpha(s));
	}
	
	#[test]
	fn lexer_fn_is_digit() {
		let s = "1".chars().next().unwrap();
		assert!(is_digit(s));
	}
	
	#[test]
	fn lexer_gets_char_at() {
		let lexer = Lexer::new("hello world");
		assert_eq!(lexer.char_at(1), 'e');
	}
	
	#[test]
	fn lexer_gets_started() {
		let lexer = Lexer::new("hello world");
		let str = String::from("hello world");
		assert_eq!(lexer.source, str);
	}
	
	#[test]
	fn lexer_can_return_current() {
		let mut lexer = Lexer::new("hello world");
		assert_eq!(lexer.current(), 'h');
		lexer.advance();
		assert_eq!(lexer.current(), 'e');
	}
	
	#[test]
	fn lexer_can_advance() {
		let mut lexer = Lexer::new("hello world");
		assert_eq!(lexer.advance(), 'h');
		assert_eq!(lexer.peek(), 'e');
		assert_eq!(lexer.advance(), 'e');
		assert_eq!(lexer.peek(), 'l');
	}
	
	#[test]
	fn lexer_can_peek() {
		let lexer = Lexer::new("hello world");
		assert_eq!(lexer.peek(), 'h');
	}
	
	#[test]
	fn lexer_can_peek_next() {
		let lexer = Lexer::new("hello world");
		assert_eq!(lexer.peek_next(), 'e');
	}
	
	#[test]
	fn lexer_fn_is_at_end_works() {
		let mut lexer = Lexer::new("hello");
		assert_eq!(lexer.advance(), 'h');
		assert_eq!(lexer.advance(), 'e');
		assert_eq!(lexer.advance(), 'l');
		assert_eq!(lexer.advance(), 'l');
		assert_eq!(lexer.advance(), 'o');
		assert!(lexer.is_at_end());
	}
	
	// test this with the print statement.
	// cargo t make_token -q --lib -- --nocapture
	#[test]
	fn lexer_fn_make_token() {
		let mut lexer = Lexer::new("let me = 'go'");
		assert_eq!(lexer.advance(), 'l');
		assert_eq!(lexer.advance(), 'e');
		assert_eq!(lexer.advance(), 't');
		lexer.tokens.push(lexer.make_token(TokenType::Name));
		assert_eq!(lexer.tokens[0].typ, TokenType::Name);
		println!("{}",lexer.tokens[0]);
	}
	
	#[test]
	fn lexer_fn_skip_whitespace() {
		let mut lexer = Lexer::new("    hello");
		lexer.skip_whitespace();
		lexer.start = lexer.current;
		assert_eq!(lexer.peek(), lexer.advance());
		
		let mut lexer = Lexer::new("
   bro hello");
		lexer.skip_whitespace();
		lexer.start = lexer.current;
		assert_eq!('b', lexer.advance());
	 
	 let mut lexer = Lexer::new("   \r\n hello");
		lexer.skip_whitespace();
		lexer.start = lexer.current;
		assert_eq!('h', lexer.advance());
	}
	
	#[test]
	fn lexer_print_tokens() {
		let mut lexer = Lexer::new("let me = 'go'");
		assert_eq!(lexer.advance(), 'l');
		assert_eq!(lexer.advance(), 'e');
		assert_eq!(lexer.advance(), 't');
		lexer.tokens.push(lexer.make_token(TokenType::Name));
		println!("{}",lexer.tokens[0]);
	}
	
	#[test]
	fn lexer_scan() {
		let mut lexer = Lexer::new("hello loser");
		lexer.scan();
		assert_eq!(lexer.tokens.len(),2);
		
		let token1 = Token {
			typ: TokenType::Name,
			start: 0,
			length: 5,
			line: 1,
		};
		let token2 = Token {
			typ: TokenType::Name,
			start: 6,
			length: 5,
			line: 1,
		};
		assert_eq!(lexer.tokens[0],token1);
		assert_eq!(lexer.tokens[1],token2);
		
		let mut lexer = Lexer::new("thing = 5 + 6");
		lexer.scan();
		let token1 = Token { typ: TokenType::Equal, start: 6, length: 1, line: 1, };
		let token2 = Token { typ: TokenType::Number, start: 8, length: 1, line: 1, };
		let token3 = Token { typ: TokenType::Plus, start: 10, length: 1, line: 1, };
		assert_eq!(lexer.tokens[1],token1);
		assert_eq!(lexer.tokens[2],token2);
		assert_eq!(lexer.tokens[3],token3);

		// let mut lexer = Lexer::new("fn person(name, age) {  }");
	}
	
}
