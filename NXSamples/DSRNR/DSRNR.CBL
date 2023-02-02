      * -----------------------------------------------------------
      * D S R N R - Example of program to work with DSRUNNER
      * -----------------------------------------------------------
       Working-Storage Section.

       01 Handle-Error-Count              Pic 9 Value 0.

       01 Display-Ds-Error.
         03 Error-Number                  Pic 9(4).  
         03 Error-Details1                Pic 9(4).  
         03 Error-Details2                Pic 9(4).  

      * -----------------------------------------------------------
       Linkage Section.

      * Data block from screenset
       Copy "dsrnr.cpb".

      * (optional) dsrunner info and ds event blocks
       Copy "dsrunner.cpy".
       Copy "dssysinf.cpy".
       
      * -----------------------------------------------------------
       Procedure Division Using Data-Block
                                Dsrunner-Info-Block
                                Ds-Event-Block.
       Main Section.
      * Put out a message if we are run from the command line
      * instead of being called by DSRUNNER.
          If (Address of Data-Block = Null)
             Display "This is a sub-program, and must be CALLed"
             Display "(Preferably from DSRUNNER!)."
             Exit Program
             Stop Run
          End-If

          Move 0 To Return-Code

      * Determine if this is the first time we've been called with
      * this data block. We can do thi sby checking the data block
      * for low values, which is what DSRUNNER initialises all data
      * block with.
          If (Data-Block = All Low-Values)
      *      This is the first time we have been called with this
      *      Screenset/Data-Block. Perform any initialisation, 
      *      and then exit. The screenset is not loaded (and no
      *      SCREENSET-INITIALIZED event occurs) until after
      *      we return from here.
             Perform Initialisation
          Else
      *      This is not the first time we have been called, 
      *      therefore do our normal handling.
             Perform Handle-Screenset-Request
          End-If

          Continue.

       Exit-Main.

          Exit Program
          Stop Run.

      * -----------------------------------------------------------
       Initialisation Section.
      * Perform any pre-screenset initialisation here.

          Initialize Data-Block
          Move Dsrunner-Screenset-Instance to My-Instance-No

          Continue.

      * -----------------------------------------------------------
       Handle-Screenset-Request Section.
      * We end up here whenever the screenset does a RETC, or
      * a DSRUN error has occured, and DSRUNNER is calling us to 
      * do any error handling before we get terminated.

      * Have we been called because our screenset caused an error?
          If (Dsrunner-Error-Code Not = 0)
      *      Yes, so handle it.
             Perform Handle-Dsrun-Error
             Exit Section
          End-If
      * Have we been called becuase of a validation error?
          If (Dsrunner-Validation-Error-No Not = 0)
      *      Yes, so handle it.
             Perform Handle-Validation-Error
             Exit Section
          End-If

      *   Must have been a normal RETC from our screenset, so 
      *   just service the screenset request.

          Move "Successful" To Program-String

          Evaluate Reason-For-Returning
          When "+"
               Add Program-Value-1 To Program-Value-2 
                   Giving Result-Value

          When "-"
               Subtract Program-Value-2 From Program-Value-1 
                   Giving Result-Value

          When "*"
               Multiply Program-Value-1 By Program-Value-2 
                   Giving Result-Value

          When "/"
               Divide Program-Value-1 By Program-Value-2 
                   Giving Result-Value
               On Size Error
                   Move "Bad result from divide" to Program-String

          When Other
               Move "Sorry, unsupported function" to Program-String

          End-Evaluate

          Continue.

      * -----------------------------------------------------------
       Handle-Dsrun-Error Section.
      * We end up here when a DSRUN error occurs in the screenset.
      * In this example I am deciding to display the error message 
      * myself. If this is the first time this has occured, I
      * continue, otherwise I set the RETURN-CODE indicating that
      * DSRUNNER should terminate me. If the return-code is zero
      * DSRUNNER would continue as if nothing had happened.

          Move Dsrunner-Error-Code To Error-Number  
          Move Dsrunner-Error-Details-1 To Error-Details1  
          Move Dsrunner-Error-Details-2 To Error-Details2  
          Display "DSRNR: "
                  "DSRUN Error " Error-Number  
                  ", "        Error-Details1  
                  ", "        Error-Details2  

          If (Handle-Error-Count = 0)
             Add 1 To Handle-Error-Count
          Else
      *      This will force DSRUNNER to terminate me
             Move 1 To Return-Code
          End-If

          Continue.

      * -----------------------------------------------------------
       Handle-Validation-Error Section.
      * We end up here when a screenset validation error has occured.
      * Same rules apply here as for above.

           Move Dsrunner-Validation-Error-No To Error-Number

           Display "DSRNR: Validation error code ", Error-Number

      * This will force DSRUNNER to terminate me
          Move 1 To Return-Code

          Continue.
