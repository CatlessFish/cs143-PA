-- Escape tests.
-- Empty
""				

-- Normal escape. Should be "agag\a\g"
"ag\a\g\\a\\g"		

-- Special escape. Should be "nt{NEWLINE}{TAB}\n\t"
"nt\n\t\\n\\t"	

-- Null escape. Should be "1230"	
"123\0"				

-- Null escape. Should be "1230123"
"123\0123"		    

-- Null escape. Should be "123\0"
"123\\0"			

-- Null escape. Should be "123\0123"
"123\\0123"		    

-- Slash escape. Should be "123\0"
"123\\\0"			

-- Slash escape. Should be "123\\0"
"123\\\\0"			

-- Error: String contains null character
"hello world"		

-- Error: String contains escaped null character
"hello\ world"		

-- String length limit tests.
-- Error: String too long (1200+)
"vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitoj vdskhv jsdslkhlb elfjldasjv aljaljdvlk lkdvjsldkvjsad dlkhfaj reitojvdskhv jsdslkhlb elfjldas"
