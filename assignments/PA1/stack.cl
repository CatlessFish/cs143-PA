(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

(*
 *  Class List, Class Cons
 *    from examples/list.cl
 *)

class List {
   -- Define operations on empty lists.

   isNil() : Bool { true };

   head()  : String { { abort(); ""; } };

   tail()  : List { { abort(); self; } };

   cons(i : String) : List {
      (new Cons).init(i, self)
   };

};

class Cons inherits List {

   car : String;	-- The element in this list cell

   cdr : List;	-- The rest of the list

   isNil() : Bool { false };

   head()  : String { car };

   tail()  : List { cdr };

   init(i : String, rest : List) : List {
      {
	 car <- i;
	 cdr <- rest;
	 self;
      }
   };

};

class Stack inherits IO{
   data : List;
   top : Int;

   initStack() : Stack {
      {
         data <- (new List).cons("#");
         top <- 0;
         self;
      }
   };

   isEmpty() : Bool {
      top = 0
   };

   pop() : String {
      let res : String <- data.head() in {
         data <- data.tail();
         res;
      }
   };

   push(s : String) : Stack {
      {
         data <- data.cons(s);
         top <- top + 1;
         -- out_string("(debug) Pushed: ").out_string(s).out_string("\n");
         self;
      }
   };

   swap() : Stack {
      (let t1 : String <- self.pop() in 
         (let t2 : String <- self.pop() in {
            self.push(t1);
            self.push(t2);
         })
      )
   };

   evaluate() : Stack {
      (let t : String <- self.pop() in
         if t = "+" then 
            -- Add
            let z : A2I <- new A2I in 
               let a : Int <- z.a2i(self.pop()) in 
                  let b : Int <- z.a2i(self.pop()) in
                     self.push(z.i2a(a + b))
         else if t = "s" then
            -- Swap
            self.swap()
         else
            -- Bottom of Stack, or an Int
            self.push(t)
         fi fi
      )
   };

   printAll() : Stack {
      let cur : List <- data in {
         while not cur.tail().isNil() loop
         {
            out_string(cur.head()).out_string("\n");
            cur <- cur.tail();
         }
         pool;
         self;
      }
   };

};

class Main inherits IO {

   main() : Object {
      -- out_string("Nothing implemented\n")
      (let stack : Stack <- (new Stack).initStack() in
         (let flag : Int <- 1 in
            {
               while 1 = flag loop
               {
                  out_string(">");
                  let s : String <- in_string() in
                  {
                     -- out_string(s).out_string("\n");
                     if s = "e" then
                        stack.evaluate()
                     else if s = "d" then
                        stack.printAll()
                     else if s = "x" then
                        flag <- 0
                     else
                        -- + s Int
                        stack.push(s)
                     fi fi fi;
                  };
               }
               pool;
               out_string("Quit.\n");
               -- stack.printAll();
            }
         )
      )
   };

};
