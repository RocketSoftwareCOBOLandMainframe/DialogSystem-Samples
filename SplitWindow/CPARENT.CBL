      $set mfoo
       program-id. "cparent".

       class-control.
           splitView is class "vspwndow"
           .


       WORKING-STORAGE SECTION.
       01 splitter-window object reference.
       01 Position-X      PIC X(4) comp-5.

       LINKAGE section.
       01 Window-Handle   PIC X(4) comp-5.
       01 tView           object reference.
       01 lview           object reference.


       PROCEDURE DIVISION USING Window-Handle
                                tview
                                lview.

           INVOKE splitView "fromHandlewithClass" USING window-Handle
                                                        splitView
                                              returning splitter-Window

           INVOKE Splitter-window "registerLeftView"  USING tView
           INVOKE Splitter-window "registerRightView" USING lview

           *> X point on DS window where tree/list controls edges meet
           MOVE 796 TO POSITION-X
           INVOKE Splitter-Window "scaleXDown" USING Position-X
           INVOKE Splitter-window "setInitialSplitPos" USING Position-X

           INVOKE Splitter-window "show"

           EXIT PROGRAM
           .

