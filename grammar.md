# Grammar

Not sure how to describe the grammar.

I think this does it.
```
comment         -> '#' + (anytext)* + newline
tableLiteral    -> { ( '"' anytext '"' )*  }
expression      -> (name | number | call)
call            -> funcName + parameters
function        -> name + paremeterList + funcbody
parameters      -> (expression + ',')*
paremeterList   -> '(' (name)* ')'
funcbody        -> '{' expressions '}'
newline         -> '\n'
whitespace      -> ( ' ' | '\r' | '\t' )*
anytext         -> (name | whitespace | number) not newline
name            -> letter + ( letter | '_' | digit )
number          -> ('0'..'9' | "0x") + (digit | '_') | digit + '.' + digit
letter          -> ('a'..'z' | 'A'..'Z')*
digit           -> ('0'..'9')*
```
Alright so the syntax is simple. We've got numbers, and some words and stuff. functions are very simple. just expressions. newlines are important. expressions on a new line that resolve to numbers, are preserved in that line number as the result. The `sum`, `average`, and `mean` keywords

You can output tables, You create a table object, and then insert tuples, and then, out comes a table object. If you place the name of the table object with some empty parens behind it then, voila, it should spit out a representation of that table. adding rows to a table is achieved by adding a tuple in it's parens.

keywords:
	fun
	break
	continue
	loop
	
