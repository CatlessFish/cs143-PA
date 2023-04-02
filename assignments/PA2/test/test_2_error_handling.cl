-- Error handling tests.

-- Error: ">"
if (2 > 1)

-- Error: "?"
a <- b ? c : d

-- Error: "!"
a <- !b

-- Unterminated string
a <- "hello world
"

-- Other tests for strings are in test_string.cl and test_string_crossline.cl

-- Unmatched '*)'
(*This is a comment*)*)

-- EOF in comment
(*This is a comment
  and another line
  with EOF behind