       Working-Storage Section.

       01 Key-Num-Value-Value                Pic 9.
       01 Was-An-Equals                      Pic 9.
       01 Looper                             Pic 9(4) Comp-5.

       78 Max-Stack-Depth                    Value 10.

       01 Num-Value-Top                      Pic 9(4) Comp-5 Value 1.
       01 Num-Value-Stack Occurs Max-Stack-Depth.
         03 Num-Value                        Pic S9(18) Comp.

       01 Operation-Top                      Pic 9(4) Comp-5 Value 0.
       01 Operation-Stack Occurs Max-Stack-Depth.
         03 Operation                        Pic X.

      *--------------------------------------------------
       Linkage Section.

       Copy "ds-call.cpy".
       Copy "dscalc.cpb".

      *--------------------------------------------------
       Procedure Division Using Dsc-Control-Block Data-Block.
       Entry-Point Section.

         If (Address Of Dsc-Control-Block = Null)
            Display "This program should be run from DSRUNNER"
         End-If

          Exit Program
          Stop Run.

      *--------------------------------------------------
       Initialise Section.
       Entry "Initialise" Using Dsc-Control-Block Data-Block.

          Perform Clear

          Exit Program.

      *--------------------------------------------------
       Clear Section.

          Perform Varying Looper From 1 By 1 
             Until (Looper > Max-Stack-Depth)
             Move 0 To Num-Value(Looper)
             Move Space To Operation(Looper)
          End-Perform

          Move 0 To Display-Value

          Exit.

      *--------------------------------------------------
       Num-Value-Key Section.
       Entry "Numeric" Using Dsc-Control-Block Data-Block.

          If (Was-An-Equals = 1)
             Move 0 To Was-An-Equals
             Move 0 To Num-Value(Num-Value-Top)
          End-If

          If (Key-Value >= "0" And <= "9")
             Move Key-Value To Key-Num-Value-Value
             Multiply 10 By Num-Value(Num-Value-Top)
             If (Num-Value(Num-Value-Top) < 0)
                Subtract Key-Num-Value-Value From 
                         Num-Value(Num-Value-Top)
             Else
                Add Key-Num-Value-Value To 
                    Num-Value(Num-Value-Top)
             End-If
          Else
             Move 999 To Error-Code
          End-If
          
          Move Num-Value(Num-Value-Top) To Display-Value

          Exit Program.

      *--------------------------------------------------
       Binary-Operation Section.

       If (Operation-Top > 0)
          Evaluate Operation(Operation-Top)
             When "+"
                Add Num-Value(Num-Value-Top) To 
                    Num-Value(Num-Value-Top - 1)
             When "-"
                Subtract Num-Value(Num-Value-Top) From 
                         Num-Value(Num-Value-Top - 1) Giving 
                         Num-Value(Num-Value-Top - 1)
             When "*"
                Multiply Num-Value(Num-Value-Top) By 
                         Num-Value(Num-Value-Top - 1)
             When "/"
                If (Num-Value(Num-Value-Top) NOT = 0)
                   Divide Num-Value(Num-Value-Top) Into 
                          Num-Value(Num-Value-Top - 1)
                Else
                   Move 0 To Num-Value(Num-Value-Top - 1)
                End-If
             When Other
                Move 999 To Error-Code
          End-Evaluate
          Subtract 1 From Num-Value-Top
          Subtract 1 From Operation-Top
       End-If

       Exit.

      *--------------------------------------------------
       Unary-Operation-Key Section.
       Entry "Unary" Using Dsc-Control-Block data-Block.

          Move 0 To Was-An-Equals
          Evaluate Key-Value
          When "="
             Perform Binary-Operation
             Move 1 To Was-An-Equals
          When "S"
             Subtract Num-Value(Num-Value-Top) From 0 Giving
                      Num-Value(Num-Value-Top)
          When "@"
             Move 0 To Num-Value(Num-Value-Top)
          When "#"
             Perform Clear
          End-Evaluate

          Move Num-Value(Num-Value-Top) To Display-Value
          Exit Program.

      *--------------------------------------------------
       Binary-Operation-Key Section.
       Entry "Binary" Using Dsc-Control-Block Data-Block.

          Move 0 To Was-An-Equals

          Perform Binary-Operation
          Move Num-Value(Num-Value-Top) To Display-Value

          Add 1 To Num-Value-Top
          Move 0 To Num-Value(Num-Value-Top)
          Add 1 To Operation-Top
          Move Key-Value To Operation(Operation-Top)

          Exit Program.
