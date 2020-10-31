grammar simplyversion1;

program
    : (use | function)*
    ;

use
    : 'use' ID EOL
    ;

function
    : 'function' ID '(' 'input' ':'  argumentList ')' 'output' ':' functionReturnDtype block
    ;

argumentList
    : arg? (',' arg)*
    ;

arg
    : dtype ID
    ;

dtype
    : 'int'
    | 'float'
    | 'string'
    | 'bool'
    ;

functionReturnDtype
    : 'int'
    | 'float'
    | 'string'
    | 'bool'
    | 'nothing'
    ;

block
    : '{' stat* '}'
    ;

stat
    : block
    | display
    | varDecl                   // declare, declare and assign
    | listDecl                  // declare, declare and assign
    | constDecl                 // declare and assign
    | checkStmt
    | whileStmt
    | forStmt
    | returnStmt
    | expr '=' expr EOL         // assign
    | expr EOL                  // func call
    ;

display
    : 'display' '(' expr ')' EOL
    ;

varDecl
    : dtype? ID ('=' expr)? EOL
    ;

listDecl
    : ('list' ':' dtype)? ID ('=' expr )? EOL
    ;

constDecl
    : 'const' dtype ID '=' expr EOL
    ;

expr
    : '(' expr ')'
    | '[' literal? (',' literal)* ']'       //list element assign
    | 'keyin' '(' (literal) ')'             //keyboard input
    | ID ('++' | '--')
    | ID '.' ID '(' exprList ')'            //function call
    | ('++' | '--') ID
    | '!' expr
    | expr '**' expr
    | expr '%' expr
    | expr '*' expr
    | expr '/' expr
    | expr '+' expr
    | expr '-' expr
    | expr '<' expr
    | expr '<=' expr
    | expr '>' expr
    | expr '>=' expr
    | expr '==' expr
    | expr '!=' expr
    | expr 'and' expr
    | expr 'or' expr
    | ID
    | literal
    ;

exprList
    : expr? (',' expr)*
    ;

literal
    : INTEGER_LITERAL
    | FLOAT_LITERAL
    | STRING_LITERAL
    | BOOL_LITERAL
    | NULL_LITERAL
    ;

checkStmt
    : 'check' '(' expr ')' 'then' block otherwiseCheck* ('otherwise' block)?
    ;

otherwiseCheck
    : 'otherwise' 'check''(' expr ')' 'then' block
    ;

whileStmt
    : 'repeat' '(' expr ')' block
    ;

forStmt
    : 'repeat' '(' forControl ')' block
    ;

forControl
    : varDecl 'range' ':' INTEGER_LITERAL 'to' INTEGER_LITERAL EOL 'change' ':' INTEGER_LITERAL
    ;

returnStmt
    : 'return' expr EOL
    ;

INTEGER_LITERAL: '1'..'9' '0'..'9'* ;

FLOAT_LITERAL: (INTEGER_LITERAL | '0') '.' '0'..'9'+ ;

STRING_LITERAL
    : '"' (ESC | .)*? '"'
    ;

fragment ESC: '\\"' | '\\\\' ;

BOOL_LITERAL: 'true' | 'false' ;

NULL_LITERAL: 'NULL';

ID
    : ('a'..'z' | 'A'..'Z') ('_' | 'a'..'z' | 'A'..'Z' | '0'..'9')*
    ;

EOL
    : ';'
    ;

LINE_COMMENT
    : '#' .*? '\r'? '\n' -> skip
    ;

MULTI_LINE_COMMENT
    : '/*' .*? '*/' -> skip
    ;

WS
    : [ \t\r\n\u000C]+ -> skip
    ;