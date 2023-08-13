%{
#include <string>

%}

ESPACO [ \t]
DIGITO [0-9]
LETRA [A-Za-z_]
SINAL [-]


DELIM {ESPACO}+
NUM ({SINAL}({DIGITO}+)|{DIGITO}+)
REAL {NUM}+("."{NUM}+)?
CHAR \'({LETRA}|{NUM})\'
ID {LETRA}({LETRA}|{NUM})*
COMENTT ({LETRA}|{NUM}|{ESPACO})*
STRING \"({LETRA}|{NUM}|{ESPACO})*\"


%%

"\n"		{contador_linha();}

{DELIM} 	{}

"main"		{return TK_MAIN;}

"int"		{return TK_TIPO_INT;}

"float"		{return TK_TIPO_FLOAT;}

"char"		{return TK_TIPO_CHAR;}

"string"	{return TK_TIPO_STRING;}

"bool"      {return TK_TIPO_BOOL;}

"||"        {return TK_OR;}

"&&"        {return TK_AND;}

"if"        {return TK_IF;}

"for"       {adiciona_loop(); return TK_FOR;}

"else"      {return TK_ELSE;}

"switch"    {return TK_SWITCH;}

"case"      {return TK_CASE;}

"default"   {return TK_DEFAULT;}

"while"     {adiciona_loop(); return TK_WHILE;}

"do"        {return TK_DO;}

"break"     {return TK_BREAK;}

"continue"  {return TK_CONTINUE;}

"scanf"     { return TK_SCANF; }

"printf"    { return TK_PRINTF; }

"function"  { return TK_FUNCTION; }

"return"    { return TK_RETURN;}

"matrix"    {return TK_MATRIX;}

"vector"    {return TK_VECTOR;}

"{"         { adiciona_contexto(); return *yytext;}

"}"         { retira_contexto(); return *yytext;}


[()[\];,:]	{ return *yytext; }

[+\-*/%]	{ return *yytext; }

[<]         { return *yytext; }
[>]         { return *yytext; }
"<="        { yylval.traducao = " <= "; return TK_MENOR_IGUAL; }
"=>"        { yylval.traducao = " => "; return TK_MAIOR_IGUAL; }
"!="        { yylval.traducao = " != "; return TK_DIFERENTE; }
"=="        { yylval.traducao = " == "; return TK_IGUALDADE; }
"++"        {yylval.traducao = "++" ; return TK_MAIS_MAIS;}  
"--"        {yylval.traducao = "--"; return TK_MENOS_MENOS;}
"**"        {yylval.traducao = "**"; return TK_POTENCIA;}
"+="        {yylval.traducao = "+="; return TK_MAIS_IGUAL;}
"-="        {yylval.traducao = "-="; return TK_MENOS_IGUAL;}
"*="        {yylval.traducao = "*="; return TK_MULTI_IGUAL;}
"/="        {yylval.traducao = "/="; return TK_DIV_IGUAL;}
"="         { return '='; }

"true"   	{ yylval.traducao = "true"; return TK_LOGICO; }
"false"   	{ yylval.traducao = "false"; return TK_LOGICO; }



{NUM}		{ yylval.traducao = yytext; return TK_NUM; }
{REAL}      { yylval.traducao = yytext; return TK_REAL; }
{CHAR}		{ yylval.traducao = yytext; return TK_CHAR;}
{STRING}    { yylval.traducao = yytext; return TK_STRING;}
{ID}		{ yylval.label = yytext; return TK_ID; }



.			{ *yytext; }

%%
