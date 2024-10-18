      *>--------------------------------------------------------------
      *> ClientDisplay Class :
      *>
      *> This is a subclass of subpane which overrides the "paint"
      *> method to paint to the client area of the window which
      *> invokes it. This class demonstrates how to:
      *>
      *>    - invoke an instance of the brush class and give it a color
      *>    - set the brush on the client area
      *>    - draw shapes such as ellipes on the client area using the
      *>    - brush
      *>
      * (C) 1996-2024 Rocket Software, Inc. or its affiliates. All    
      * Rights Reserved. 
      *>--------------------------------------------------------------

      *>------------------<CLASSS PROGRAM DEFINITION>-----------------
       class-id. ClientDisplay
                 inherits from Subpane.

       class-control.                                                   *> Declare the classes that this class uses directly
          ClientDisplay is class "cdisp"                                *> Our own class
          SubPane is class "subpane"                                    *> From the class library - our class inherits the behaviour of this class
          Color is class "color"                                        *> From the class library - we use this class to create color objects to set the brush to.
          brush  is class "brush"                                       *> From the class library - we use this class to create instance of the class brush
          .

      *--------------< COMMON CLASS & INSTANCE DATA >------------------*
       working-storage section.
      *> None at the moment

      *--------------------< CLASS DEFINITION >------------------------*
       class-object.

      *----------------------< CLASS DATA >----------------------------*
       object-storage section.
      *> None at the moment

      *---------------------< CLASS METHODS >--------------------------*
      *> None at the moment

       End class-object.

      *-------------------< INSTANCE DEFINITION >----------------------*
       Object.

      *---------------------< INSTANCE DATA >--------------------------*
       Object-Storage Section.

      *--> our colors and brushes declared as objects
       01 osColor1         object reference.
       01 osColor2         object reference.
       01 osColor3         object reference.
       01 osBlueBrush      object reference.
       01 osRedBrush       object reference.
       01 osGreenBrush     object reference.

      *--------------------< INSTANCE METHODS >------------------------*
      *----------------------------------------------------------------*
      *> "Paint"
      *>---------------------------------------------------------------*
      *>    - invokes 3 instances of the brush class and gives them a
      *>      color
      *>    - set the brushes on the client area
      *>    - draw an green rectangle on top of a red circle on top of
      *>      a blue ellipe
      *>---------------------------------------------------------------*
       method-id. "Paint".

       local-storage section.
       01 lsY                      pic x(4) comp-5.
       01 lsX                      pic x(4) comp-5.
       01 lsX1                     pic x(4) comp-5.
       01 lsY1                     pic x(4) comp-5.
       01 lsBlueBrush              object reference.
       01 lsRedBrush               object reference.
       01 lsGreenBrush             object reference.


       linkage section.
       01 lnkDrawingSurface        object reference.

       procedure division using lnkDrawingSurface.
      *----Create a color for the brush
                 invoke Color "Blue" returning osColor1
      *--------Create osBlueBrush
                 invoke brush "new" returning osBlueBrush
      *----Set the color of osBlueBrush to oscolor1
                 invoke osBlueBrush "setColor" using osColor1

                 invoke Color "Red" returning osColor2
                 invoke brush "new" returning osRedBrush
                 invoke osRedBrush "setColor" using osColor2

                 invoke Color "Green" returning osColor3
                 invoke brush "new" returning osGreenBrush
                 invoke osGreenBrush "setColor" using osColor3


      *------Get the height and width of the client area
             invoke self "getClientWidthHeight" using lsX lsY
             divide lsX by 2 giving lsX1
             divide lsY by 2 giving lsY1
             divide lsX by 3 giving lsX
             divide lsY by 3 giving lsY

      *------Set the brush on the DrawingSurface
             invoke lnkDrawingSurface "setBrush" using osBlueBrush
                                           returning lsBlueBrush
      *----Draw blue ellipse
             invoke lnkDrawingSurface "ellipse" using lsX1 lsY1 lsX lsY

      *----Draw red circle
             invoke lnkDrawingSurface "setBrush" using osRedBrush
                                           returning lsRedBrush
             invoke lnkDrawingSurface "circle" using lsX1 lsY1 lsY

      *----Draw green rectangle
             invoke lnkDrawingSurface "setBrush" using osGreenBrush
                                           returning lsGreenBrush
             invoke lnkDrawingSurface "rectangle"
                                      using lsX lsY lsX lsY

      *----Finalize brush and colour objects used in this method
             invoke osColor1     "finalize" returning osColor1
             invoke osColor2     "finalize" returning osColor2
             invoke osColor3     "finalize" returning osColor3
             invoke osBlueBrush  "finalize" returning osBlueBrush
             invoke osRedBrush   "finalize" returning osRedBrush
             invoke osGreenBrush "finalize" returning osGreenBrush

       Exit method
       End method "Paint".

       End object.
       End class ClientDisplay.
