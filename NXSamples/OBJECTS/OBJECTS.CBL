       working-storage section.

           copy "ds-cntrl.mf".
           copy "dssysinf.cpy".
           copy "objects.cpb".
           copy "primwin.cpb".
           copy "secwin.cpb".
           copy "dlgbox.cpb".
           copy "msgbox.cpb".
           copy "entry.cpb".
           copy "pushb.cpb".
           copy "radiob.cpb".
           copy "checkb.cpb".
           copy "listbox.cpb".
           copy "selbox.cpb".
           copy "multentr.cpb".
           copy "scroll.cpb".
           copy "vscroll.cpb".
           copy "text.cpb".
           copy "grpbox.cpb".
           copy "bitmap.cpb".
           copy "tabctl.cpb".

       78 dialog-system            value "dsrun".
       78 wb-info                  value "Some workbench info".
       78 anim-info                value "Some animator info".
       78 edit-info                value "Some editor info".
       78 screen-info              value "Some screens info".
       78 help-info                value "Some help info".

       01 exit-flag                pic 9    value 0.

       procedure division.

       main-process.
           initialize ds-control-block, objects-data-block
           move objects-version-no to ds-version-no
           move objects-data-block-version-no to
               ds-data-block-version-no
           move ds-new-set to ds-control
           move "objects" to ds-set-name
           move 3 to ds-parameter-count
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move zero to exit-flag
           perform until exit-flag = 1
               evaluate objects-menu-selection
                   when 0
                       move 1 to exit-flag
                   when 1
                       perform prim-window-selected
                   when 2
                       perform sec-window-selected
                   when 3
                       perform dialog-box-selected
                   when 4
                       perform message-box-selected
                   when 5
                       perform entry-field-selected
                   when 6
                       perform multi-line-entry-selected
                   when 7
                       perform push-button-selected
                   when 8
                       perform radio-button-selected
                   when 9
                       perform check-box-selected
                   when 10
                       perform list-box-selected
                   when 11
                       perform selection-box-selected
                   when 12
                       perform v-scroll-bar-selected
                   when 13
                       perform scroll-bar-selected
                   when 14
                       perform text-selected
                   when 15
                       perform group-box-selected
                   when 16
                       perform bitmap-selected
                   when 17
                       perform tab-control-selected
               end-evaluate
               if exit-flag = 0
                   call dialog-system using ds-control-block
                                            objects-data-block
                                            ds-event-block
               end-if
           end-perform
           stop run.

       prim-window-selected.
           initialize primwin-data-block
           move primwin-version-no to ds-version-no
           move primwin-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "primwin" to ds-set-name
           call dialog-system using ds-control-block
                                    primwin-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.

       sec-window-selected.
           initialize secwin-data-block
           move secwin-version-no to ds-version-no
           move secwin-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "secwin" to ds-set-name
           call dialog-system using ds-control-block
                                    secwin-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.

       dialog-box-selected.
           move dlgbox-version-no to ds-version-no
           move dlgbox-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "dlgbox" to ds-set-name
           call dialog-system using ds-control-block
                                    dlgbox-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       message-box-selected.
           move msgbox-version-no to ds-version-no
           move msgbox-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "msgbox" to ds-set-name
           call dialog-system using ds-control-block
                                    msgbox-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.

       entry-field-selected.
           move entry-version-no to ds-version-no
           move entry-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "entry" to ds-set-name
           call dialog-system using ds-control-block
                                    entry-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       push-button-selected.
           move pushb-version-no to ds-version-no
           move pushb-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "pushb" to ds-set-name
           call dialog-system using ds-control-block
                                    pushb-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       radio-button-selected.
           move radiob-version-no to ds-version-no
           move radiob-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "radiob" to ds-set-name
           call dialog-system using ds-control-block
                                    radiob-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       check-box-selected.
           move checkb-version-no to ds-version-no
           move checkb-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "checkb" to ds-set-name
           call dialog-system using ds-control-block
                                    checkb-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       list-box-selected.
           initialize listbox-data-block
           move listbox-version-no to ds-version-no
           move listbox-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "listbox" to ds-set-name
           call dialog-system using ds-control-block
                                    listbox-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.

       selection-box-selected.
           move selbox-version-no to ds-version-no
           move selbox-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "selbox" to ds-set-name
           call dialog-system using ds-control-block
                                    selbox-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.

       multi-line-entry-selected.
           move spaces to multentr-large-entry-field
           move multentr-version-no to ds-version-no
           move multentr-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "multentr" to ds-set-name
           call dialog-system using ds-control-block
                                    multentr-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       scroll-bar-selected.
           move scroll-version-no to ds-version-no
           move scroll-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "scroll" to ds-set-name
           call dialog-system using ds-control-block
                                    scroll-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       v-scroll-bar-selected.
           move vscroll-version-no to ds-version-no
           move vscroll-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "vscroll" to ds-set-name
           call dialog-system using ds-control-block
                                    scroll-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       text-selected.
           move text-version-no to ds-version-no
           move text-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "text" to ds-set-name
           call dialog-system using ds-control-block
                                    text-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       group-box-selected.
           move grpbox-version-no to ds-version-no
           move grpbox-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "grpbox" to ds-set-name
           call dialog-system using ds-control-block
                                    grpbox-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.


       bitmap-selected.
           move bitmap-version-no to ds-version-no
           move bitmap-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "bitmap" to ds-set-name
           call dialog-system using ds-control-block
                                    bitmap-data-block
                                    ds-event-block
           move zero to bitmap-exit-flag
           perform until bitmap-exit-flag = 1
               evaluate ds-descendant
                   when bitmap-wb-handle
                       move wb-info to bitmap-info-text
                       move "show-wb" to ds-procedure
                   when bitmap-anim-handle
                       move anim-info to bitmap-info-text
                       move "show-anim" to ds-procedure
                   when bitmap-edit-handle
                       move edit-info to bitmap-info-text
                       move "show-edit" to ds-procedure
                   when bitmap-screen-handle
                       move screen-info to bitmap-info-text
                       move "show-screen" to ds-procedure
                   when bitmap-help-handle
                       move help-info to bitmap-info-text
                       move "show-help" to ds-procedure
               end-evaluate
               call dialog-system using ds-control-block
                                        bitmap-data-block
                                        ds-event-block
           end-perform
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.

       tab-control-selected.
           move tabctl-version-no to ds-version-no
           move tabctl-data-block-version-no to
               ds-data-block-version-no
           move ds-push-set to ds-control
           move 1 to ds-control-param
           move "tabctl" to ds-set-name
           call dialog-system using ds-control-block
                                    tabctl-data-block
                                    ds-event-block
           move ds-quit-set to ds-control
           call dialog-system using ds-control-block
                                    objects-data-block
                                    ds-event-block
           move ds-continue to ds-control.
