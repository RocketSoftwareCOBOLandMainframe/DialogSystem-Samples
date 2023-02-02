      $IF SYS-CONSTANTS NOT DEFINED
       01  SYS-CONSTANTS.
           03  SYS-NULL       PIC 9(8) COMP-X VALUE H"01000000".
           03  SYS-CONTROL    PIC 9(8) COMP-X VALUE H"02000000".
           03  SYS-WINDOW     PIC 9(8) COMP-X VALUE H"03000000".
      $END

       01  filler.

       03  MAIN-WINDOW                     PIC 9(8) COMP-X VALUE 1.
       03  EF-FIRST-FOCUS                  PIC 9(8) COMP-X VALUE 2.
       03  PB-NORTH                        PIC 9(8) COMP-X VALUE 10.
       03  PB-SOUTH                        PIC 9(8) COMP-X VALUE 11.
       03  PB-EAST                         PIC 9(8) COMP-X VALUE 12.
       03  PB-WEST                         PIC 9(8) COMP-X VALUE 13.
       03  DIALOG-BOX                      PIC 9(8) COMP-X VALUE 19.
       03  ORDER-BOX                       PIC 9(8) COMP-X VALUE 20.
       03  TOTAL                           PIC 9(8) COMP-X VALUE 26.
       03  CHANGE-ORDER                    PIC 9(8) COMP-X VALUE 30.
       03  FIELD-ERROR                     PIC 9(8) COMP-X VALUE 38.
