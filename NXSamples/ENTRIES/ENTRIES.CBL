      $set ans85
       identification division.

       program-id. race-entries.


       environment division.

       input-output section.
       file-control.
           select entry-file assign "entries.dat"
           access is sequential.


       data division.

       file section.
       fd  entry-file.
       01  entry-record.
           03  file-name               pic x(15).
           03  file-male               pic 9.
           03  file-address            pic x(100).
           03  file-club               pic x(30).
           03  file-code               pic x(3).

       working-storage section.

           copy "ds-cntrl.mf".
           copy "entries.cpb".

       77  display-error-no            pic 9(4).


       procedure division.

       main-process section.

           perform program-initialize
           perform program-body until entry-exit-flg-true
           perform program-terminate.

      *---------------------------------------------------------------*

       program-initialize section.

           initialize entry-data-block
           initialize ds-input-fields
           move entry-data-block-version-no
                                 to ds-data-block-version-no
           move entry-version-no to ds-version-no
           open output entry-file
           perform load-screenset.

      *---------------------------------------------------------------*

       program-body section.

           evaluate true
               when entry-save-flg-true
                   perform save-record
               when entry-clr-flg-true
                   perform clear-record
           end-evaluate
           perform clear-flags
           perform call-dialog-system.

      *---------------------------------------------------------------*

       program-terminate section.

           close entry-file
           stop run.

      *---------------------------------------------------------------*

       save-record section.

           if (entry-name    <> spaces) and
              (entry-address <> spaces) and
              (entry-club    <> spaces) and
              (entry-code    <> spaces)
               move entry-name    to file-name
               move entry-male    to file-male
               move entry-address to file-address
               move entry-club    to file-club
               move entry-code    to file-code
               write entry-record
           else
               move "show-save-error" to ds-procedure
           end-if.

      *---------------------------------------------------------------*

       clear-record section.

           initialize entry-record
           initialize entry-data-block
           perform set-up-for-refresh-screen.

      *---------------------------------------------------------------*

       clear-flags section.

           initialize entry-flag-group.

      *---------------------------------------------------------------*

       set-up-for-refresh-screen section.

           move "refresh-data" to ds-procedure.

      *---------------------------------------------------------------*

       load-screenset section.

           move ds-new-set to ds-control
           move "entriesx"  to ds-set-name
           perform call-dialog-system.

      *---------------------------------------------------------------*

       call-dialog-system section.

           call "dsrun" using ds-control-block,
                              entry-data-block.
           if not ds-no-error
               move ds-error-code to display-error-no
               display "DS ERROR NO:   " display-error-no
               perform program-terminate
           end-if.
