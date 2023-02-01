      $set mfoo OOCTRL(+p)
      $set remove(object-reference)
       program-id. gridctrl.
       class-control.
           OLEControlSite is class "olectlst"
           Window is class "window"
           Dictionary is class "dictinry"
           Association is class "associtn"
           CobolComp5 is class "comp5"
           CharacterArray is class "chararry"
           EntryCallback is class "entrycll"
           Color is class "color"
           Mouse is class "mouse"
           EventManager is class "p2emgr"
           OLEStream is class "olestm"
           olesafearray is class "olesafea"
           olesup is class "olesup"
           .




      *   This file provides the generic working storage data
          copy "strcture.cpy".

      *   OLE data and safearray copyfiles
          copy "mfole.cpy".
          copy "olesafea.cpy".

      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".


      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
       78 ProgramID                value "gridctrl".

      *   OCX control specific data items
       01 anOLEStream          usage object reference.
       01 anOLEControlSite     usage object reference.
       01 anOLEDocument        usage object reference.
       01 aPROGID              usage object reference.
       01 entryName            pic X(255).
       01 CodeName            pic X(255).
       01 eventIndex           pic s9(9) comp-5.
       01 ReturnValue          PIC X Comp-5.
       01 ObjEmphasis          PIC X(4) comp-5 VALUE 0.

       78 WS-CLIPCHILDREN      VALUE h"02000000".
       78 useDataBlock         VALUE 1.

       01 saBound            SAFEARRAYBOUND.
       01 Group1SafeArray    object reference.
       01 tmpArray           object reference.
       01 CDims              PIC 9(9) comp-5.
       01 ColIndex           pic x(4) comp-5.
       01 hResult            pic x(4) comp-5.
       01 thevarType         pic 9(4) comp-5.

       01 theData            POINTER.
       01 theOLEDate         Comp-2.
       01 aSingle            Comp-1.

       01 aRowObject         object reference.
       01 RowSet             Object reference.
       01 GridView           object reference.

       01 theRow             pic x(4) comp-5 value 0.
       01 TimeThru           PIC X    Comp-5 value 0.

       01 Property-Name      PIC X(30).
       78 ID-Change                        value 6.
       78 ID-DeletedRow                    value 18.
       78 ID-RowSel                        value 29.
       78 ID-RowUnSel                      value 32.

       01 evtRow                           pic s9(9) comp-5.
       01 evtColumn                        pic s9(9) comp-5.

       01 Date-Data.
          03 Date-YYYYMMDD   PIC 9(8) VALUE 0.
          03 Date-Time       PIC 9(8) VALUE 0.
          03 Local-Ind       PIC X VALUE SPACE.
          03 Local-Diff      PIC 9(4) VALUE 0.

       01 TheOrd-No.
          03 Order-Number    PIC X(6).
          03                 PIC X VALUE X"00".

       01 v                  VARIANT.

       01 dtAfterLast        PIC X(4) comp-5.

       01 rowCount binary-long.

      *   The Callout control block - We need the P2-MF-reserved
      *   value that this gives us
          copy "ds-call.cpy".

       local-storage section.
      *   Although no local-storage is used, this section is needed to 
      *   allow Entrycallback based recursive calls to the entry points 
      *   of this program.


       linkage section.

      * Linkage Items:

      *   The object reference of the object receiving an event for
      *   which a callback will be defined

       01 anEvent              object reference.

      *   This file defines the interface for integration of this
      *   control with the Dialog System runtime
          copy "userctrl.cpy".

      *   Data from the screenset used to invoke methods / set properties
      *   This datablock includes the generic interface to the
      *   template program - passed here as linkage.

      *   NOTE this is the screenset copyfile generated WITHOUT the
      *   screenset ID prefixes. This enables this program and its
      *   copyfiles to act as a  generic code template that
      *   you may tailor more easily.
          copy "custgridnp.cpb".


       PROCEDURE DIVISION USING DSC-Control-Block Data-block.


      *   Convert the Call-Function to Uppercase
          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                          BY VALUE Function-Length.

          EVALUATE Call-Function
          WHEN "GRID-FROM-GROUP"
          WHEN "DELETE-ROW"

               PERFORM Do-ActiveX-Function

          WHEN OTHER

               DISPLAY Invalid-Function, " ", Call-Function
               GO TO ActiveX-Program-Exit
          END-EVALUATE.

       ActiveX-Program-Exit.

          EXIT PROGRAM.


       Create-Entry-Point Section.
       Entry "C" & ProgramID USING EntryPoint-Data.

          PERFORM Create-ActiveX-Instance
          invoke anOLEControlSite "GetDomainObject"
                             returning GridView

          invoke GridView "GetRowSet" returning RowSet

          EXIT PROGRAM
          .

        copy "CreateActiveX.cpy".

      *    Register this event after creation because DataTableV5 fires
      *    immediately on create to remove rows... we're not interested
      *    in those events yet.
           move ID-DeletedRow to eventIndex
           move programID & z"OnDeletedRow" to entryName
           invoke anOLEControlSite "setEventToEntry"
                                              using eventIndex
                                                    entryName
           .

      *------------------------------------------------------------


       Resize-Entry-Point Section.
       Entry "R" & ProgramID USING EntryPoint-Data.

          PERFORM Resize-Routine
          EXIT PROGRAM
          .

       Register-Callbacks section.

          PERFORM SetEvent-Input
          PERFORM SaveDataBlockPointer.


       Do-ActiveX-function section.

            IF TimeThru = 0
               MOVE -2 to dtAfterLast
               ADD 1 TO TimeThru
            END-IF

            EVALUATE  Call-Function
            WHEN "GRID-FROM-GROUP"
                 PERFORM Set-Grid-From-Group

            WHEN "DELETE-ROW"
                 PERFORM Delete-A-Row

            WHEN "GROUP-ELEMENT-DELETE"
                 PERFORM Delete-Group-Element

            WHEN "DATA-FROM-ROW"
                 PERFORM Update-Data-From-Grid-Row

            WHEN OTHER
                 CONTINUE

            END-EVALUATE
            .


       copy "gridocx.cpy".

      *------------------------------------------------------------

       Set-Grid-From-Group Section.

      *     The DataTable OCX control takes a variant containing an
      *     array of variants to populate the row/columns with data.
      *     COBOL OLE support allows us to create variant arrays - so

            PERFORM GetNew-SafeArray

      *     Clear out the table

            MOVE 0 TO i
            INVOKE RowSet "setCount" USING i

      *     For each column, populate the safearry with data from Group
      *     5 Columns - maximum 10 Rows

            PERFORM VARYING j FROM 1 BY 1 UNTIL j = 10
                              OR Ord-No(j) = 0

                PERFORM Set-Group-Into-Array

      *         Insert the new row object and give it the variant
      *         array for this group occurs item.

                INVOKE RowSet "add" USING dtAfterLast
                                   BY VALUE Group1SafeArray

            END-PERFORM

            INVOKE Group1SafeArray "finalize" RETURNING Group1Safearray

            .


      *------------------------------------------------------------

       Delete-A-Row Section.

      *     Note that this section deletes the row from the grid control

      *     The data is synchronized after the DeletedRow callback event
      *     occurs

            MOVE -1 TO theRow

      *     This method enables us to call a method prefixed with "Get"
            INVOKE olesup "SetDispatchType" USING BY VALUE 0

            INVOKE RowSet "GetSelect" USING theRow
                                    RETURNING Numeric-Value

            INVOKE RowSet "Remove" USING Numeric-Value

            .

      *------------------------------------------------------------

       Delete-Group-Element Section.

      *     Given the row index that has been removed, loop down
      *     the group moving data up one index...

            PERFORM GetNew-SafeArray

      *     Determine the number of rows now in the array
            INVOKE RowSet "getCount" RETURNING i

            PERFORM VARYING j FROM Numeric-Value
                BY 1 UNTIL j = i

                ADD 1 TO j GIVING k
                INITIALIZE Group-001-Item(k)

                INVOKE RowSet "getItem" USING j
                                      RETURNING aRowObject
                INVOKE aRowObject "getValue" RETURNING Group1SafeArray

                PERFORM Set-Array-Into-Group

            END-PERFORM

            ADD 1 TO j GIVING k
            INITIALIZE Group-001-Item(k)

            INVOKE Group1SafeArray "finalize" RETURNING Group1Safearray

            .

      *------------------------------------------------------------

       Update-Data-From-Grid-Row section.

      *     Given the row & column, get the object reference for the
      *     cell and place its value in the correct datablock field

            set tmpArray to Group1SafeArray
            invoke RowSet "getItem" USING Numeric-Value
                                    RETURNING aRowObject

            INVOKE aRowObject "getValue" RETURNING Group1SafeArray

            ADD 1 to Numeric-Value GIVING k
            PERFORM Set-Array-Into-Group

      *     The cell datablock item is now updated, refresh
      *     the whole row and recalculate the Order Balance if required

            PERFORM GetNew-SafeArray

            COMPUTE ord-bal(k) = ord-val(k) - pay-val(k)
                               
            MOVE k to j
            PERFORM Set-Group-Into-Array

      *     Get the row object given the row index, and update the whole
      *     row with the new data

            INVOKE RowSet "getItem"    USING Numeric-Value
                                     RETURNING aRowObject
            INVOKE aRowObject "setValue" USING Group1SafeArray

            INVOKE Group1SafeArray "finalize" RETURNING
                                                  Group1Safearray
            set Group1SafeArray to tmpArray
            .

      *------------------------------------------------------------

       GetNew-SafeArray section.

      *     Create a VARIANT based OLESafeArray to contain
      *     the column datatypes in our group to go in the grid
      *

      *     1 dimensional, 10 occurs

            MOVE VT-VARIANT TO thevarType
            MOVE 1  TO cDims
            MOVE 10 TO cElements OF saBound
            MOVE 0  TO llBound OF saBound
            INVOKE olesafearray  "new" USING
                                    BY VALUE thevarType
                                    BY VALUE cDims
                                BY REFERENCE saBound
                                   RETURNING Group1SafeArray

           .
      *------------------------------------------------------------

       Set-Group-Into-Array section.

      *     Strings require conversion to unicode by OLE,
      *     so the Safearray instance method does this for us.

            MOVE 0 TO ColIndex

      *     Ord-No is a numeric, but we will treat it as a string for
      *     this demo - to get the preceeding zeroes

            MOVE Ord-No(j) TO Order-Number
            INVOKE Group1SafeArray "putStringasVariant"
                                                      USING ColIndex
                                                   BY VALUE 7 SIZE 4
                                               BY REFERENCE TheOrd-No
                                                  RETURNING hresult

      *     Dates require slightly different treatment by OLE, they
      *     consist of a double precision floating point number(comp-2)
      *     as an index to the number of days since 01/01/1900...
      *     so the COBOL OLE support gives us a means to get this

      *     If this is a new row, use todays date as default

            IF Ord-Date(j) = 0
               MOVE FUNCTION CURRENT-DATE TO Date-Data
               MOVE Date-YYYYMMDD(1:4) TO Ord-Date(j)(5:4)
               MOVE Date-YYYYMMDD(5:2) TO Ord-Date(j)(3:2)
               MOVE Date-YYYYMMDD(7:2) TO Ord-Date(j)(1:2)
            END-IF

            INVOKE olesup "formatDateToOLE" USING
                                               Ord-Date(j)(1:2)
                                               Ord-Date(j)(3:2)
                                               Ord-Date(j)(5:4)
                                               theOLEDate

      *     Now place the OLE format date in the safearray
            ADD 1 TO ColIndex
            MOVE theOLEDate TO Variant-VT-DATE OF v
            MOVE VT-DATE    TO Variant-vartype OF v
            SET theData TO ADDRESS OF v
            INVOKE Group1SafeArray "putElement" USING ColIndex
                                             BY VALUE theData
                                            RETURNING hresult

      *     The remaining 3 columns are s9(4)v99 which can map to Single
      *     precision, floating point number (comp-1) used by the grid

            ADD 1 TO ColIndex
            MOVE Ord-Val(j) TO Variant-VT-R4 OF v
            MOVE VT-R4      TO Variant-vartype OF v
            INVOKE Group1SafeArray "putElement" USING ColIndex
                                             BY VALUE theData
                                            RETURNING hresult

            ADD 1 TO ColIndex
            MOVE Pay-Val(j) TO Variant-VT-R4 OF v
            INVOKE Group1SafeArray "putElement" USING ColIndex
                                             BY VALUE theData
                                            RETURNING hresult

            ADD 1 TO ColIndex
            MOVE Ord-Bal(j) TO Variant-VT-R4 OF v
            INVOKE Group1SafeArray "putElement" USING ColIndex
                                             BY VALUE theData
                                            RETURNING hresult

            .

      *------------------------------------------------------------

       Set-Array-Into-Group section.


            MOVE 0 TO ColIndex

      *     Ord-No is a numeric, but we will treat it as a string for
      *     this demo - to get the preceeding zeroes

            INVOKE Group1SafeArray "getStringFromVariant" USING ColIndex
                                            BY VALUE 7 SIZE 4
                                        BY REFERENCE TheOrd-No
                                           RETURNING hresult

            MOVE Order-Number TO Ord-No(k)

      *     Dates require slightly different treatment by OLE, they
      *     consist of a double precision floating point number(comp-2)
      *     as an index to the number of days since 01/01/1900...
      *     so the COBOL OLE support gives us a means to get this

      *     If this is a new row, use todays date as default

      *     Now get the OLE format date from the safearray
            ADD 1 TO ColIndex

            SET theData TO ADDRESS OF v
            INVOKE Group1SafeArray "getElement" USING ColIndex
                                             BY VALUE theData
                                            RETURNING hresult
            MOVE Variant-VT-DATE OF v TO theOLEDate
            INVOKE olesup "formatOLEToDate" USING
                                               Ord-Date(k)(1:2)
                                               Ord-Date(k)(3:2)
                                               Ord-Date(k)(5:4)
                                               theOLEDate

      *     The remaining 3 columns are s9(4)v99 which need to be
      *     translated from Single precision, floating point number
      *     (comp-1) used by the grid

            ADD 1 TO ColIndex
            INVOKE Group1SafeArray "getElement" USING ColIndex
                                             BY VALUE theData
                                            RETURNING hresult
            MOVE Variant-VT-R4 OF v TO Ord-Val(k)


            ADD 1 TO ColIndex
            INVOKE Group1SafeArray "getElement" USING ColIndex
                                             BY VALUE theData
                                            RETURNING hresult
            MOVE Variant-VT-R4 OF v  TO Pay-Val(k)



            ADD 1 TO ColIndex
            INVOKE Group1SafeArray "getElement" USING ColIndex
                                             BY VALUE theData
                                            RETURNING hresult
            MOVE Variant-VT-R4 OF v TO Ord-Bal(k)

            .

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


