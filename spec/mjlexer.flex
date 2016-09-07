package rs.ac.bg.etf.pp1;

import java_cup.runtime.Symbol;
import java.lang.StringBuilder;

%%

%{

	StringBuilder sb = new StringBuilder();

	// ukljucivanje informacije o poziciji tokena
	private Symbol new_symbol(int type) {
		return new Symbol(type, yyline+1, yycolumn);
	}
	
	// ukljucivanje informacije o poziciji tokena
	private Symbol new_symbol(int type, Object value) {
		return new Symbol(type, yyline+1, yycolumn, value);
	}

%}

%cup
%line
%column

%xstate COMMENT
%xstate CHARACTER
%xstate STRING

%eofval{
	return new_symbol(sym.EOF);
%eofval}

%%

" " 	{ }
"\b" 	{ }
"\t" 	{ }
"\r\n" 	{ }
"\f" 	{ }

"program"   { return new_symbol(sym.PROG, yytext()); }
"print" 	{ return new_symbol(sym.PRINT, yytext()); }
"read"		{ return new_symbol(sym.READ, yytext()); }
"return" 	{ return new_symbol(sym.RETURN, yytext()); }
"const"     { return new_symbol(sym.CONST, yytext()); }
"class"     { return new_symbol(sym.CLASS, yytext()); }
"extends"   { return new_symbol(sym.EXTENDS, yytext()); }
"new"		{ return new_symbol(sym.NEW, yytext()); }
"if"        { return new_symbol(sym.IF, yytext()); }
"else"      { return new_symbol(sym.ELSE, yytext()); }
"while"     { return new_symbol(sym.WHILE, yytext()); }
"break"     { return new_symbol(sym.BREAK, yytext()); }
"do"        { return new_symbol(sym.DO, yytext()); }
"void" 		{ return new_symbol(sym.VOID, yytext()); }

"+" 		{ return new_symbol(sym.PLUS, yytext()); }
"-"    		{ return new_symbol(sym.MINUS, yytext()); }
"*"    		{ return new_symbol(sym.MUL, yytext()); }
"/"    		{ return new_symbol(sym.DIV, yytext()); }
"%"    		{ return new_symbol(sym.MOD, yytext()); }
"=" 		{ return new_symbol(sym.EQUAL, yytext()); }

"&&"    	{ return new_symbol(sym.AND, yytext()); }
"||" 		{ return new_symbol(sym.OR, yytext()); }

"=="    	{ return new_symbol(sym.EQ, yytext()); }
"!="    	{ return new_symbol(sym.NEQ, yytext()); }
">"			{ return new_symbol(sym.GT, yytext()); }
">="		{ return new_symbol(sym.GE, yytext()); }
"<"         { return new_symbol(sym.LT, yytext()); }
"<="		{ return new_symbol(sym.LE, yytext()); }

"++"    	{ return new_symbol(sym.PLUSPLUS, yytext()); }
"--" 		{ return new_symbol(sym.MINUSMINUS, yytext()); }

";" 		{ return new_symbol(sym.SEMI, yytext()); }
"," 		{ return new_symbol(sym.COMMA, yytext()); }
"(" 		{ return new_symbol(sym.LPAREN, yytext()); }
")" 		{ return new_symbol(sym.RPAREN, yytext()); }
"{" 		{ return new_symbol(sym.LBRACE, yytext()); }
"}"			{ return new_symbol(sym.RBRACE, yytext()); }
"[" 		{ return new_symbol(sym.LSQBRACE, yytext()); }
"]"			{ return new_symbol(sym.RSQBRACE, yytext()); }
"." 		{ return new_symbol(sym.DOT, yytext()); }

"//" 		     { yybegin(COMMENT); }
<COMMENT> .      { yybegin(COMMENT); }
<COMMENT> "\r\n" { yybegin(YYINITIAL); }

"true"	{ return new_symbol (sym.BOOL, yytext()); }
"false"	{ return new_symbol (sym.BOOL, yytext()); } 

[0-9]+  { return new_symbol(sym.NUMBER, new Integer (yytext())); }
([a-z]|[A-Z])[a-z|A-Z|0-9|_]* 	{return new_symbol (sym.IDENT, yytext()); }



"\'"	{ yybegin(CHARACTER); }
<CHARACTER> {

	[^\r\n\']"\'"	{ yybegin(YYINITIAL); return new_symbol(sym.CHAR, yytext().charAt(0)); }
	
	"\\b" { yybegin(YYINITIAL); return new_symbol(sym.CHAR, '\b'); }
  	"\\t" { yybegin(YYINITIAL); return new_symbol(sym.CHAR, '\t'); }
  	"\\n" { yybegin(YYINITIAL); return new_symbol(sym.CHAR, '\n'); }
  	"\\f" { yybegin(YYINITIAL); return new_symbol(sym.CHAR, '\f'); }
  	"\\r" { yybegin(YYINITIAL); return new_symbol(sym.CHAR, '\r'); }
  	"\\\"" { yybegin(YYINITIAL); return new_symbol(sym.CHAR, '\"'); }
  	"\\'" { yybegin(YYINITIAL); return new_symbol(sym.CHAR, '\''); }
 	 "\\\\" { yybegin(YYINITIAL); return new_symbol(sym.CHAR, '\\'); }
 	 
  	. {
		yybegin(YYINITIAL);
		System.err.println("Leksicka greska ("+yytext()+") u liniji "+(yyline+1));
		}
  
  	\\. { 
		yybegin(YYINITIAL); 
		System.err.println("Leksicka greska ("+yytext()+") u liniji "+(yyline+1));
		}
  	
  	"\r\n" { 
		yybegin(YYINITIAL); 
		System.err.println("Leksicka greska ("+yytext()+") u liniji "+(yyline+1));
		}
		
	<<EOF>> { 
		yybegin(YYINITIAL); 
		System.err.println("Leksicka greska (End of file) u liniji "+(yyline+1));
		}
	
	}	

	
    
"\""	{ yybegin(STRING); sb.setLength(0); }
<STRING> {
	"\""	{ yybegin(YYINITIAL); return new_symbol(sym.STRING, sb.toString()); }
	
	[^\r\n\"]+ { sb.append(yytext()); }
	
	"\\b" 	{ sb.append( '\b' ); }
  	"\\t" 	{ sb.append( '\t' ); }
  	"\\n" 	{ sb.append( '\n' ); }
  	"\\f" 	{ sb.append( '\f' ); }
  	"\\r" 	{ sb.append( '\r' ); }
  	"\\\"" 	{ sb.append( '\"' ); }
  	"\\'" 	{ sb.append( '\'' ); }
  	"\\\\" 	{ sb.append( '\\' ); }
  	
  	\\.  { 
		yybegin(YYINITIAL); 
		System.err.println("Leksicka greska ("+ "\"" + sb.toString() +") u liniji "+(yyline+1));
		}

	
	"\r\n" { 
		yybegin(YYINITIAL); 
		System.err.println("Leksicka greska ("+ "\"" + sb.toString() +") u liniji "+(yyline+1));
		}
		
	<<EOF>> { 
		yybegin(YYINITIAL); 
		System.err.println("Leksicka greska (End of file) u liniji "+(yyline+1));
		}
  	
	}


<<EOF>> { return new_symbol(sym.EOF); }

. { System.err.println("Leksicka greska ("+yytext()+") u liniji "+(yyline+1)); }