%option noyywrap

%{
#include<stdio.h>    
#include "parsertest.tab.h"
#include<stdlib.h>
#include<string.h>
%}





digit [0-9]
letter [a-zA-Z]
id (_|{letter})({letter}|{digit})*
number ({digit})+
integer [+-]?({digit})+
floating_point [+-]?({digit})*[.]({digit})+ 
ws [\t\n]
delim ({ws})*


%%
{ws}  {}
"#include" {return HEADER;}
"//.*"  {return COMMENT;}  
"[/][+].*[+][\]" {return MULTICOMMENT;}  
"main" {return MAIN;}
"int" {return INT;}
"float" {return FLOAT;}
"char"  {return CHAR_TYPE;}
"string" {return STRING_TYPE; }
"function" {return FUNCTION;} 
"print"   {return PRINT;}
"input"   {return INPUT;}
"switch"  {return SWITCH;}
"case"    {return CASE;}
"break"  {return BREAK;}
"default" {return DEFAULT;}
"max"       {return MAX;}
"min"       {return MIN;}
"return"    {return RETURN;}
"="     {return ASSIGN;}
"=="     {return EQUAL;}
"("      {return LPAREN;}
")"      {return RPAREN;}
"{"      {return LBRACE;}
"}"      {return RBRACE;}
"["      {return LBRACKET;}
"]"      {return RBRACKET;}
"\""     {return QUOTATION;}
"&"      {return AND;}
"if"     {return IF;}
"else"   {return ELSE;}
"while"   {return WHILE;}
"for"     {return FOR;}
"+"       {return ADD;}
"-"       {return SUB;}
"*"         {return MUL;}
"/"       {return DIV;}
"%"         {return PERCENT;}
"**"       {return POW;}
";"       {return SEMI;}
">"       {return GT;}
"<"       {return LT;}
","      {return COMMA;}
":"        {return COLON;}
{id}     {yylval.stringValue = strdup(yytext);return ID;}
({digit})+ {yylval.intValue = atoi(yytext);return INT_NUM;}
{floating_point} {yylval.intValue = atof(yytext);return FLOAT_NUM;}
\"[^\"]*\"      {yylval.stringValue = strdup(yytext);return STRING;}
"'"              {return SINGLE_QUOTATION;}

%%

int main()
{
     yyin=fopen("input.txt","r");
    yyparse();
    printf("finished");
    return 0;
}