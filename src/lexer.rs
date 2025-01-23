// lexer.rs
use std::fmt;

// So this is the lexer.
// We're going to lex stuff, from a simple Grammar.

// const EOF = "EOF";
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
	
	Fun,
	
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
			TokenType::Name => write!(f, "{}", "TOKEN_Name"),
			TokenType::String => write!(f, "{}", "TOKEN_Name"),
			TokenType::Number => write!(f, "{}", "TOKEN_Name"),
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

pub fn is_alpha(c: &char) -> bool {
	match c {
		'a'..='z' | 'A'..='Z' | '_' => true,
		_ => false
	}
}

pub fn is_digit(c: &char) -> bool {
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
	
	fn char_at(&self, index: usize) -> char {
		self.source[index..=index].chars().next().unwrap()
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
			return '\0'
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
	
	// pub fn lexeme(&mut self) -> &str {
	// 	&self.source[self.start..=self.next]
	// }
	
	// scans everything and makes tokens.
	pub fn scan(&mut self) {
		while !self.is_at_end() {
			
		}
		
	}
	
}

#[cfg(test)]
mod tests {
	use super::*;
	
	#[test]
	fn lexer_fn_is_digit() {
		let s = "a".chars().next().unwrap();
		assert!(is_alpha(&s));
	}
	
	#[test]
	fn lexer_fn_is_alpha() {
		let s = "1".chars().next().unwrap();
		assert!(is_digit(&s));
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
	
	// #[test]
	// fn lexer_can_return_current() {
	// 	let mut lexer = Lexer::new("hello world");
	// 	assert_eq!(lexer.current(), "h");
	// 	lexer.advance();
	// 	assert_eq!(lexer.current(), "e");
	// }
	
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
	
	#[test]
	fn lexer_fn_make_token() {
		let mut lexer = Lexer::new("let me = 'go'");
		assert_eq!(lexer.advance(), 'l');
		assert_eq!(lexer.advance(), 'e');
		assert_eq!(lexer.advance(), 't');
		lexer.tokens.push(lexer.make_token(TokenType::Name));
		assert_eq!(lexer.tokens[0].typ, TokenType::Name);
	}
	
	// #[test]
	// fn lexer_can_get_lexeme() {
	// 	let mut lexer = Lexer::new("hello loser");
	// 	lexer.advance();
	// 	lexer.advance();
	// 	lexer.advance();
	// 	lexer.advance();
	// 	assert_eq!(lexer.lexeme(), "hello");
	// 	lexer.advance();
	// 	lexer.advance();
	// 	lexer.start = lexer.next;
	// 	lexer.advance();
	// 	lexer.advance();
	// 	lexer.advance();
	// 	lexer.advance();
	// 	assert_eq!(lexer.lexeme(), "loser");
	// }
	
	// #[test]
	// fn lexer_scan() {
	// 	let mut lexer = Lexer::new("hello loser");
	// 	lexer.scan();
	// 	assert_eq!(1,1);
	// }
	
}
