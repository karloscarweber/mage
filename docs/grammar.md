# Grammar
So mage is a simple stack based virtual machine language thing, for fun, based on the [numi](numi.app). For fun. Purpose is to make a feature rich, but simple, easy to follow Scanner, Parser, and VM, and deploy this to the web to run a little math engine thing.

Multi line statements or expressions are not allowed, except for function declarations, which span multiple lines.

```grammar
declaration     	 → funDecl
									 | statement
funDecl            → "def" name parameterlist? block
name
block              → "{" declarations* "}"
function           → name parameters block
parameters         → param? ("," param)*
param              → name | number
arguments          → expression ( "," expression)*
```

## expressions
```grammar
expression         → assignment | number | name | call
assignment         → name "=" ( name | number )
term               → factor ( ( "-" | "+" ) factor )* ;
factor             → primary ( ( "/" | "*" | "%" ) primary )* ;
unary              → ( "-" ) primary | call ;
call               → name "(" parameters ")" ;
primary            → number | name | constant | "(" expression ")" ;
heading            → newline "#" ()*
```

## Lexical Grammer
```grammar
ws                 → " " | "  " | newline, "space, tab, or newline"
newline            → ``
name               → alpha ( alpha | digit )*
alpha              → a .. z | A .. Z | _
number             → digit+ ( "." digit+ )?
digit              → 0 .. 9
```
