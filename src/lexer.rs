// lexer.rs
// use std::fmt;

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

// impl fmt::Display for Token {
// 	fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
// 		match self {
// 			Token::Atom(i) => write!(f, "{}", i)
// 		}
// 	}
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

// pub struct Program {
// 	Source(&str),
// 	Tokens
// }

pub enum LexemeType {
	Number,
	String,
	Name,
	Operator,
}


pub struct Lexeme<'a> {
	pub raw: &'a str,
	pub length: usize,
	pub variant: LexemeType
}

pub struct Lexer {
	pub source: String,
	pub start: usize,
	pub current: usize,
	pub line: usize,
}

pub fn is_alpha(c: &char) -> bool {
	match c {
		'a'..='z' | 'A'..='Z' => true,
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
		let str = "a";
		let s = str.chars().next().unwrap();
		assert!(is_alpha(&s));
	}
	
	#[test]
	fn lexer_fn_is_alpha() {
		let str = "1";
		let s = str.chars().next().unwrap();
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
	fn lexer_fn_is_at_end_works() {
		let mut lexer = Lexer::new("hello");
		assert_eq!(lexer.advance(), 'h');
		assert_eq!(lexer.advance(), 'e');
		assert_eq!(lexer.advance(), 'l');
		assert_eq!(lexer.advance(), 'l');
		assert_eq!(lexer.advance(), 'o');
		assert!(lexer.is_at_end());
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
