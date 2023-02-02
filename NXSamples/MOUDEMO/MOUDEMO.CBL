      $set ans85
       identification division.

       program-id. moudemo.


       environment division.


       data division.

       working-storage section.

           copy "ds-cntrl.mf".
           copy "moudemo.cpb".


       procedure division.

       main-process.

           perform program-initialize
           perform call-screen-manager
           stop run.

      *---------------------------------------------------------------*

       program-initialize.

           initialize moudemo-data-block
           initialize ds-control-block
           move ds-new-set to ds-control
           move moudemo-data-block-version-no to
                 ds-data-block-version-no
           move moudemo-version-no to ds-version-no
           move "moudemo" to ds-set-name.

      *---------------------------------------------------------------*

       call-screen-manager.

           call "dsrun" using ds-control-block,
                              moudemo-data-block.

