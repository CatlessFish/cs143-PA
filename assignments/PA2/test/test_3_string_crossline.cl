-- Cross-line string tests.
-- Be aware whether NEWLINE is represented by CRLF(\r\n) or LF(\n)

"hello\
world"				

"hello\
	  world  world"	
	  
"hello\

world"

"hello
	world"
