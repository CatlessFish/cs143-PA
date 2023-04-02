/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

int num_comment_nested = 0;
int string_too_long;
int string_contains_null = 0;
int string_contains_escaped_null = 0;

/* #define DEBUG_ECHO_STRING */

%}

/*
 * Define names for regular expressions here.
 */

/* Symbols */
DARROW          =>

/* Operators */
PLUS            \+
MINUS           \-
STAR            \*
SLASH           \/
EQUALS          =
LESS_THAN       <
LE              <=
ASSIGN          <-

/* Constants */
INT_CONST       [0-9]+
TRUE            t(?i:rue)
FALSE           f(?i:alse)

/* Identifiers */
TYPEID          [A-Z][A-Za-z0-9_]*
OBJECTID        [a-z][A-Za-z0-9_]*
SELF_TYPE       SELF_TYPE
SELF            self

/* Keywords */
CLASS           (?i:class)
ELSE            (?i:else)
FI              (?i:fi)
IF              (?i:if)
IN              (?i:in)
INHERITS        (?i:inherits)
LET             (?i:let)
LOOP            (?i:loop)
POOL            (?i:pool)
THEN            (?i:then)
WHILE           (?i:while)
CASE            (?i:case)
ESAC            (?i:esac)
OF              (?i:of)
NEW             (?i:new)
ISVOID          (?i:isvoid)
NOT             (?i:not)

/* White Space */
WHITESPACE      [ \f\r\t\v]+

%option noyywrap

%x COMMENT
%x NESTED_COMMENT
%x STRING

%%

 /*
  *  Keywords
  *  Keywords are case-insensitive except for the values true and false,
  *  which must begin with a lower-case letter.
  */

{CLASS}     { return (CLASS); }
{ELSE}      { return (ELSE); }
{FI}        { return (FI); }
{IF}        { return (IF); }
{IN}        { return (IN); }
{INHERITS}  { return (INHERITS); }
{LET}       { return (LET); }
{LOOP}      { return (LOOP); }
{POOL}      { return (POOL); }
{THEN}      { return (THEN); }
{WHILE}     { return (WHILE); }
{CASE}      { return (CASE); }
{ESAC}      { return (ESAC); }
{OF}        { return (OF); }
{NEW}       { return (NEW); }
{ISVOID}    { return (ISVOID); }
{NOT}       { return (NOT); }

 /* 
  *  ID and Const
  */

{INT_CONST} { cool_yylval.symbol = inttable.add_string(yytext); return (INT_CONST); }
{TRUE}      { cool_yylval.boolean = 1; return (BOOL_CONST); }
{FALSE}     { cool_yylval.boolean = 0; return (BOOL_CONST); }
{TYPEID}    { cool_yylval.symbol = idtable.add_string(yytext); return (TYPEID); }
{OBJECTID}  { cool_yylval.symbol = idtable.add_string(yytext); return (OBJECTID); }

 /*
  *  Whitespace
  */

\n          { curr_lineno++; /* ECHO; */ }
{WHITESPACE} { }

 /*
  *  Symbols and Operators
  *  return themselves
  */

{DARROW}   { return (DARROW); }
{PLUS}     { return int('+'); }
{MINUS}    { return int('-'); }
{STAR}     { return int('*'); }
{SLASH}    { return int('/'); }
{EQUALS}   { return int('='); }
{LESS_THAN} { return int('<'); }
{LE}       { return int(LE); }
{ASSIGN}   { return int(ASSIGN); }
"."        { return int('.'); }
";"        { return int(';'); }
","        { return int(','); }
"("        { return int('('); }
")"        { return int(')'); }
"{"        { return int('{'); }
"}"        { return int('}'); }
":"        { return int(':'); }
"@"        { return int('@'); }
"~"        { return int('~'); }

 /*
  *  Comments
  */

--            { BEGIN(COMMENT); }
<COMMENT>.    { /* ECHO; */ }
<COMMENT>\n   { curr_lineno++; BEGIN(INITIAL); /* ECHO; */ }

"(*"                  { BEGIN(NESTED_COMMENT); num_comment_nested++; }
"*)"                  { cool_yylval.error_msg = "Unmatched *)"; BEGIN(INITIAL); return (ERROR); }
<NESTED_COMMENT>"*)"  { num_comment_nested--; if (num_comment_nested == 0) BEGIN(INITIAL); }
<NESTED_COMMENT>"(*"  { num_comment_nested++; }
<NESTED_COMMENT><<EOF>> { cool_yylval.error_msg = "EOF in comment"; BEGIN(INITIAL); return (ERROR); }
<NESTED_COMMENT>\n    { curr_lineno++; /* ECHO; */ }
<NESTED_COMMENT>.     { /* ECHO; */ }

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

 /* Begin of string */
\"                      {
  BEGIN(STRING);
  string_buf_ptr = string_buf;
  string_too_long = 0;
  string_contains_null = 0;
  string_contains_escaped_null = 0;
}

 /* Cross-line string */
<STRING>\\\r?\n            { 
  curr_lineno++; 
  if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1) {
    string_too_long = 1;
  }
  else {
    *string_buf_ptr++ = '\n'; 
  }
}

 /* Normal character but '\', '\n', null('\0') or '"' */
<STRING>[^\\\n\0\"]       {
  if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1) {
    string_too_long = 1;
  }
  else {
    *string_buf_ptr++ = yytext[0]; 
  }
}

 /* Normal escape sequence, return "x" for "\x" */
<STRING>\\[^\n\0ntbf] {
  if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1) {
    string_too_long = 1;
  }
  else {
    *string_buf_ptr++ = yytext[1]; 
  }
}

 /* Special escape sequence, replace "\n"(2 chars) with a special char NEWLINE */
<STRING>\\[ntbf]       {
  if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1) {
    string_too_long = 1;
  }
  else { 
    switch (yytext[1]) {
      case 'n': *string_buf_ptr++ = '\n'; break;
      case 't': *string_buf_ptr++ = '\t'; break;
      case 'b': *string_buf_ptr++ = '\b'; break;
      case 'f': *string_buf_ptr++ = '\f'; break;
      default: cool_yylval.error_msg = "unknown escape sequence"; BEGIN(INITIAL); return (ERROR);
    }
  }
}

 /* String contains NULL */
<STRING>\0              {
  string_contains_null = 1;
  *string_buf_ptr++ = '\0';
}

 /* String contains escaped NULL */
<STRING>\\\0            {
  string_contains_escaped_null = 1;
  *string_buf_ptr++ = '\0';
}

 /* Newline in string without '\' */
<STRING>\n              {
  cool_yylval.error_msg = "Unterminated string constant";
  curr_lineno++;
  BEGIN(INITIAL);
  return (ERROR);
}

 /* EOF */
<STRING><<EOF>>         {
  cool_yylval.error_msg = "EOF in string constant";
  BEGIN(INITIAL);
  return (ERROR);
}

 /* End of string */
<STRING>\"              { 
  BEGIN(INITIAL);
  if (string_too_long) {
    cool_yylval.error_msg = "String constant too long";
    return (ERROR);
  } else if (string_contains_escaped_null) {
    cool_yylval.error_msg = "String contains escaped null character.";
    return (ERROR);
  } else if (string_contains_null) {
    cool_yylval.error_msg = "String contains null character.";
    return (ERROR);
  } else {
    *string_buf_ptr = '\0';
    yylval.symbol = stringtable.add_string(string_buf);

    #ifdef DEBUG_ECHO_STRING
    printf("string: %s\n", string_buf);
    #endif

    return (STR_CONST);
  }
}

 /*
  *  Error
  *  Any other unmatched characters
  */

  [^{WHITESPACE}\n] {
    char* msg = new char[100];
    /* sprintf(msg, "illegal character: %s", yytext); */
    sprintf(msg, "%s", yytext);
    cool_yylval.error_msg = msg;
    return (ERROR);
  }

%%
