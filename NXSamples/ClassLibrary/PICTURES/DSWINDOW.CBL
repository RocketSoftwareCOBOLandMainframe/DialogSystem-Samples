       copy "windows.cpy".
      *>-----------------------------------------------------------
      *> Class description
      *>-----------------------------------------------------------
       class-id. dswindow data is protected
                 inherits from Window with data.

       object section.
       class-control.
           dswindow is class "dswindow"
           Window is class "window"
      *>---USER-CODE. Add any additional class names needed below.

           .

      *>-----------------------------------------------------------
       working-storage section. *> Definition of global data
      *>-----------------------------------------------------------

      *>-----------------------------------------------------------
       class-object.   *> Definition of class data and methods
      *>-----------------------------------------------------------
       object-storage section.


       end class-object.

      *>-----------------------------------------------------------
       object.         *> Definition of instance data and methods
      *>-----------------------------------------------------------
       object-storage section.

       01 rcBounds         RECTL.
       01 anOLEPicture     object reference.

      *>---------------------------------------------------------------
       method-id. "Paint".
       local-storage Section.
       linkage Section.
       01 lnkDrawingSurface      object reference.

       procedure division using lnkDrawingSurface.

           INVOKE anOLEPicture "draw" USING lnkDrawingSurface
                                            rcBounds
                                            anOLEPicture
           INVOKE super "paint" USING lnkDrawingSurface

       exit method.
       end method "Paint".

      *>---------------------------------------------------------------
       method-id. "setPicture".
       local-storage Section.
       linkage Section.
       01 lnkRcBounds            RECTL.
       01 lnkPicture             object reference.
       procedure division using lnkRcBounds
                                lnkPicture.

          MOVE lnkRcBounds TO rcBounds
          SET anOLEPicture TO lnkPicture

       exit method.
       end method "setPicture".
      *>---------------------------------------------------------------

       end object.

       end class dswindow.
