      $SET ANS85 MF

       working-storage section.
           copy "ds-cntrl.mf".
           copy "pushmain.cpb".
           copy "filemgr.cpb".
           copy "printmgr.cpb".

       01 new-screenset-name           pic x(12).

       01 action                       pic 9.
           78 load-file                        value 1.
           78 load-print                       value 2.
           78 exit-program                     value 3.

       01 end-of-actions-flag          pic 9.
           88 end-of-actions                   value 1.

       procedure division.

       main-process.
           perform program-initialize
           call "dsrun" using ds-control-block,
                              pushmain-data-block
           perform process-actions until end-of-actions
           stop run.

       program-initialize.
           initialize ds-control-block
           initialize pushmain-data-block
           move ds-new-set to ds-control
           move pushmain-data-block-version-no to
                 ds-data-block-version-no
           move pushmain-version-no to ds-version-no
           move "pushmain" to ds-set-name
           move zero to end-of-actions-flag.

       process-actions.
           evaluate true
      *
               when pushmain-action = load-file
                   move "filemgr" to ds-set-name
                   move ds-push-set to ds-control
                   move 1 to ds-control-param
                   initialize filemgr-data-block
                   move filemgr-data-block-version-no to
                       ds-data-block-version-no
                   move filemgr-version-no to ds-version-no
                   call "dsrun" using ds-control-block,
                                      filemgr-data-block
                   perform file-mgr-stuff
               when pushmain-action = load-print
      *
                   move "printmgr" to ds-set-name
                   move ds-push-set to ds-control
                   move 1 to ds-control-param
                   initialize printmgr-data-block
                   move printmgr-data-block-version-no to
                       ds-data-block-version-no
                   move printmgr-version-no to ds-version-no
                   call "dsrun" using ds-control-block,
                                      printmgr-data-block
                   perform print-mgr-stuff
               when pushmain-action = exit-program
                   move 1 to end-of-actions-flag
           end-evaluate.

       file-mgr-stuff.
      *
           move ds-quit-set to ds-control
           call "dsrun" using ds-control-block,
                              filemgr-data-block

      *
           move ds-continue to ds-control
           call "dsrun" using ds-control-block,
                              pushmain-data-block.

       print-mgr-stuff.
      *
           move ds-quit-set to ds-control
           call "dsrun" using ds-control-block,
                              printmgr-data-block

           move ds-continue to ds-control
           call "dsrun" using ds-control-block,
                              pushmain-data-block.

