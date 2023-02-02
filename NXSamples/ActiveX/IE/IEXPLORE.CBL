      $set mfoo
      $set ooctrl(+p)
           program-id. "iexplore".
       class-control.
           OLEControlSite is class "olectlst"
           Window is class "window"
           Dictionary is class "dictinry"
           Association is class "associtn"
           CobolComp5 is class "comp5"
           CharacterArray is class "chararry"
           UniCodeString is class "unicode"
           EntryCallback is class "entrycll"
           Color is class "color"
           Mouse is class "mouse"
           EventManager is class "p2emgr"
           OLEStream is class "olestm"
           OLESafeArray is class "olesafea"
           OLEVariant is class "olevar"
           olesup is class "olesup"
           .

      *   This file provides the generic working storage data
          copy "strcture.cpy".

          copy "mfole.cpy".
          copy "olesafea.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
       78 ProgramID                    value "iexplore".

      *   ActiveX control specific data items
       01 anOLEStream          usage object reference.
       01 anOLEDocument        usage object reference.
       01 anOLEControlSite     usage object reference.
       01 aPROGID              usage object reference.
       01 aUCString            usage object reference.
       01 iVerb                pic s9(9) comp-5.
       01 CodeName             pic X(255).
       01 Numeric-2Bytes       pic 99.
       01 ReturnValue          PIC X Comp-5.
       01 ObjEmphasis          PIC X(4) comp-5 VALUE 0.
       01 ToolBar                          pic s9(9) comp-5.

       78 WS-CLIPCHILDREN      VALUE h"02000000".
       78 ID-BeforeNavigate2               value 250.
       78 ID-CommandStateChange            value 105.
       01 evtCommand                       pic s9(9) comp-5.
       01 evtEnable                        pic s9(4) comp-5.
       01 evtpDisp                         object reference.
       01 evtCancel                        pic s9(4) comp-5.
       78 CSC-NAVIGATEFORWARD              value 1.
       78 CSC-NAVIGATEBACK                 value 2.

       01 eventName            pic x(256).
       01 eventIndex           pic x(4) comp-5.
       01 entryName            pic x(256).

       01 theVarType           VARTYPE.
       01 cDims                UINT.
       01 saBound              SAFEARRAYBOUND.
       01 aSafeArray           object reference.
       01 aVariantObj          object reference.
       01 ilndices             pic x(4) comp-5.

       01 WebBrowser                   object reference.
       01 ws-Buffer            pic X(512).
       01 element-name         pic X(512).

          copy "ds-call.cpy"..
      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".

       local-storage section.
      *   This section is needed to
      *   allow Entrycallback based recursive calls to the entry points
      *   of this program.

       01 parameterIndex       pic x(4) comp-5.
       01 fMapVariant          pic x(4) comp-5.
       01 aVariant             VARIANT.
       01 aCOBVAR redefines aVariant COBVAR.
       01 hResult              pic x(4) comp-5.

       linkage section.

      * Linkage Items:

      *   The object reference of the object receiving an event for
      *   which a callback will be defined

       01 anEvent              object reference.

       01 evtURL                           VARIANT.
       01 evtFlags                         VARIANT.
       01 evtTargetFrameName               VARIANT.
       01 evtPostData                      VARIANT.
       01 evtHeaders                       VARIANT.

       01 lnk-buffer                      pic x(512).
      *   This file defines the interface for integration of this
      *   control with the Dialog System runtime
          copy "userctrl.cpy".

           copy "iedemo.cpb".

       PROCEDURE DIVISION USING DSC-Control-Block
                                Data-Block
                                .

          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                                   BY VALUE Function-Length
          EVALUATE Call-Function

          WHEN "NAVIGATE"
               invoke WebBrowser "Navigate" Using URL

          WHEN "BACK"
               invoke WebBrowser "GoBack"


          WHEN "FORWARD"
               invoke WebBrowser "GoForward"

          WHEN "HOME"
               invoke WebBrowser "GoHome"

          WHEN "STOP"
               invoke WebBrowser "Stop"

          WHEN "SEARCH"
               invoke WebBrowser "GoSearch"

          WHEN OTHER
               DISPLAY Invalid-Function, " ", Call-Function
               GO TO ActiveX-Program-Exit

          END-EVALUATE.


       ActiveX-Program-Exit.

          EXIT PROGRAM.

       Create-Entry-Point Section.
       Entry "C" & ProgramID USING EntryPoint-Data.

      * Data here is linkage passed by DSGRUN

          perform Create-ActiveX-Instance

          invoke anOLEControlSite "GetDomainObject"
                             returning WebBrowser

          EXIT PROGRAM
          .

          copy "createactivex.cpy".


       Resize-Entry-Point Section.
       Entry "R" & ProgramID USING EntryPoint-Data.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   is called by Dialog System runtime when a Window resized event
      *   occurs... the runtime calculates the correct new co-ordinates
      *   following the resize

          PERFORM Resize-Routine
          EXIT PROGRAM
          .

       Do-Example-Function section.
         continue
         .

       Register-Callbacks section.

      *    Registering a callback causes a block of your COBOL code
      *    to be executed when an event occurs on your ActiveX control

           move ID-BeforeNavigate2 to eventIndex
           move '"' & programID & z'OnBeforeNavigate2"' to entryName
           invoke anOLEControlSite "setEventToEntry"
                                              using eventIndex
                                                    entryName

           move ID-CommandStateChange to eventIndex
           move '"' & programID & z'OnCommandStateChange"' to entryName
           invoke anOLEControlSite "setEventToEntry"
                                              using eventIndex
                                                    entryName


      *    Always register a callback to delete the dictionary item
      *    when the containing window is deleted.
           MOVE '"' & ProgramID & z'OnDestroyed"' TO MessageName
           INVOKE EntryCallBack "new" USING MessageName
                                  RETURNING aCallback
           MOVE P2Ce-Destroyed TO i
           INVOKE anOLEControlSite "SetEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

           PERFORM SaveDataBlockPointer
           .

       OnBeforeNavigate2 section.
       entry programID & "OnBeforeNavigate2" using anEvent.
           perform GetDataBlockPointer

       *> The second parameter is the only one we're interested in as
       *> it contains the string needed to determine what has been
       *> selected in the browser window.

           MOVE 02 TO parameterIndex
           MOVE MAP-NONE TO fMapVariant
           INVOKE anEvent "getParameterTyped"
                           USING parameterIndex
                                 fMapVariant
                                 aVariant
                       RETURNING hResult
           SET ADDRESS OF evtURL
               to VARIANT-VT-BYREF of aVariant
           SET ADDRESS OF lnk-buffer TO VARIANT-VT-PBSTR OF evtURL
           move lnk-buffer to ws-buffer

           *> convert from unicode
           INVOKE UniCodeString "withUnicodeValue" USING ws-Buffer
                                        RETURNING aUCString
           MOVE LOW-VALUES TO ws-buffer
           INVOKE aUCString "asCharacterArray" RETURNING aChararray
           INVOKE aChararray "getValue" RETURNING ws-Buffer

           *> search for "?" which delimits the element name
           PERFORM VARYING i FROM 1 BY 1 UNTIL i > 512
           OR ws-Buffer(i:1) = "?"
              CONTINUE
           END-PERFORM

           *> If not found then don't do anything
           MOVE SPACES TO element-name
           IF i < 512
              ADD 1 TO i
              MOVE 0 TO j

              PERFORM VARYING i FROM i BY 1 UNTIL i > 512
              OR ws-buffer(i:1) = "." *> URL input image element delimiter
              OR ws-buffer(i:1) = "=" *> URL submit button element delimiter
                  ADD 1 TO j
                  MOVE ws-Buffer(i:1) TO element-name(j:1)
              END-PERFORM
           END-IF

           MOVE 0 TO Event-Type

           EVALUATE element-name
           WHEN "win2"
              MOVE 34321 TO Event-Type
           WHEN "win3"
              MOVE 34322 TO Event-Type
           END-EVALUATE

           IF Event-Type > 0
              *> post user event to screenset to show relevant window

              *> NOTE: we have the datablock available, so other COBOL
              *> sub-routines could be called if required
              PERFORM Post-User-Event-Routine
           END-IF

           exit program.

       OnCommandStateChange section.
       entry programID & "OnCommandStateChange" using anEvent.
           perform GetDataBlockPointer
           move 01 to parameterIndex
           invoke anEvent "getParameterAsInteger"
                           using parameterIndex
                       returning evtCommand

           move 02 to parameterIndex
           invoke anEvent "getParameterAsInteger"
                           using parameterIndex
                       returning evtEnable

           *> Check to see if state of Back button should change
           if evtCommand = CSC-NAVIGATEBACK
               move 34330 TO Event-Type
               move evtEnable to Numeric-Value
               perform Post-User-Event-Routine
           end-if

           *> Check to see if state of Forward button should change
           if evtCommand = CSC-NAVIGATEFORWARD
               move 34331 TO Event-Type
               move evtEnable to Numeric-Value2
               perform Post-User-Event-Routine
           end-if

           exit program.



       GetWindow-Instance-Routine section.

      *   Use the Correct handle Storage format for getting
      *   the object reference... This is not a new window, just
      *   obtaining an object reference for an existing window

           INVOKE Window "fromHandle" USING aHwnd
                                      RETURNING aWindow.

           .

       Resize-Routine Section.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   code is called by DSGRUN when a Window resized event occurs...
      *   the runtime calculates the correct new co-ordinates
      *   following the resize

      *   The EntryWindow-Data flag is used in this context, as a value to
      *   indicate whether to get or set the rectangle details.
      *   0 = Get/ 1 = Set

           IF EntryWindow-Data = 0

      *      The Dialog System Runtime needs to know the current
      *      coordinates of the object instance so it can apply an
      *      adjustment factor to the values that need to change.
              INVOKE EntryObject-Reference "getRectangle"
                                   USING EntryPosition-X EntryPosition-Y
                                        EntrySize-Width EntrySize-Height

           ELSE

      *      Invoke the setRectangle method of the object instance to
      *      reset the physical sizes following a window-sized event
              INVOKE EntryObject-Reference "setRectangle"
                                   USING EntryPosition-X EntryPosition-Y
                                        EntrySize-Width EntrySize-Height
           END-IF
          .


       Post-User-Event-Routine section.

      * The EntryCallback class has an extended method to enable
      * the posting of a user event to the panels2 module. The Dialog System
      * USER-EVENT dialog table may then act on this event

             INVOKE EntryCallback "PostP2Event" USING Queue-ID
                                                      aHwnd
                                                      Event-Type
             .


       Null-Terminate-Routine Section.

      *   This section loops back from the end of the field until it
      *   encounters a non space - & puts a null in the right place
      *---The buffer sizes used may require user defined values

           MOVE LENGTH OF Term-Field TO j
           PERFORM VARYING i FROM j BY -1 UNTIL i = 0
                IF Term-Field(i:1) NOT = Spaces
                 AND NOT = X"00"
                   ADD 1      TO i
                   MOVE x"00" TO Term-Field(i:1)
                   EXIT SECTION
                END-IF
           END-PERFORM
           MOVE x"00" TO Term-Field(j:1).


       SaveDataBlockPointer Section.

      *    Save a pointer to the datablock in a dictionary. This is
      *    so we can get at the correct datablock in the callback code.

      *    I.E. The datablock thats associated with the window on
      *    which an event occurs.

           IF 1stTimeThru

      *       First establish a class for creation of our Association
      *       template. Now PIC X(4) Comp-5 is a class instance
              MOVE 4 TO i
              INVOKE CobolComp5 "newClass" USING i
                                         RETURNING aStorageClass
      *       Now Create an association template using an object
      *       reference and a Pic X(4) Comp-5 data item.
              SET anObject TO NULL
              INVOKE Association "newClass" USING anObject aStorageClass
                                        RETURNING anAssocTemplate

      *       Now create our dictionary (upto 32 items) of associations
              MOVE 32 TO i
              INVOKE Dictionary "ofAssociations" USING anAssocTemplate
                                                       i
                                             RETURNING aDictionary
              SET Not1stTimeThru TO TRUE
            END-IF

      *    Insert the Window/datablock Pointer association into the
      *    dictionary

           SET DataBlock-Pointer TO EntryDatablock-pointer
           INVOKE aDictionary "atPut" USING aWindow DataBlock-Pointer
           .

       GetDataBlockPointer section.

      *     This re-sets this entry point program Datablock variable
      *     to the memory location where we know it exists - the
      *     original location identified by the pointer, retrieved from
      *     our dictionary
             INVOKE aDictionary "at" USING aWindow
                                 RETURNING DataBlock-Pointer

             SET ADDRESS OF Data-Block TO DataBlock-Pointer
             .

       The-Object-is-Destroyed section.
       Entry ProgramID & "OnDestroyed" USING anEvent.

          INVOKE anEvent "getObject" RETURNING anOLEControlSite
      *   Identify the window instance for this control
          INVOKE anOLEControlSite "getOLEDocument"
                                                 RETURNING anOLEDocument

          INVOKE anOLEDocument "GetActiveView" RETURNING aWindow

          SET DataBlock-Pointer TO NULL

          INVOKE aDictionary "AtOrNil" USING aWindow
                                RETURNING DataBlock-Pointer
          IF DataBlock-Pointer NOT = NULL
             INVOKE aDictionary "removeKey" USING aWindow
          END-IF
          SET aWindow TO NULL
          EXIT PROGRAM
          .


