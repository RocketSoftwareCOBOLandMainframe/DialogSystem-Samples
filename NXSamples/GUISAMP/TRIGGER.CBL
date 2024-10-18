      *>---------------------------------------------------------------*
      *> This is a basic trigger program for a GUI application.
      *>
      *> This particular one goes with the Help\Demonstration programs
      *> which demonstrate the use of various GUI controls, but can be
      *> Adapted for any application.
      *>
      *> It creates the main window of the application and sets a
      *> message processing loop into action (anEventManager)
      *>
      *> Note that this is a normal cobol program rather than a class
      *>
      *> (C) 1996-2024 Rocket Software, Inc. or its affiliates. All    
      *> Rights Reserved. 
      *----------------------------------------------------------------*

       program-id. Trigger.

       object section.
       class-control.
           EventManager        is class "p2emgr"
           MainWindow          is class "MainWin"
          .

       working-storage section.
       01 wsEventManager           object reference.
       01 wsWindow                 object reference.
       01 wsDesktop                object reference.

       procedure division.

      *--> Load GUI class library
           call "apigui"

      *--> Get and initialize an EventManager
           invoke EventManager   "New" returning wsEventManager
           invoke wsEventManager "Initialize"
           invoke wsEventManager "GetDesktop" returning wsDesktop

      *--> Create the GUI component of the application
           invoke MainWindow "New" using wsDesktop
                               returning wsWindow

      *--> Create the displayable window object and display it
           invoke wsWindow "create"
           invoke wsWindow "show"

      *--> Start processing events.
           invoke wsEventManager "run"

           stop run.

