       Working-Storage Section.  
  
       Copy "ds-cntrl.mf".  
       Copy "dssysinf.cpy".  
       Copy "pan2link.cpy".  
  
       Copy "dsp2demo.cpb".  
  
      *-----------------------------------------------------------------  
  
       78 Dstrap                        Value "ds".  
       78 Dsrun                         Value "dsrun".  
       78 Panels2                       Value "PANELS2".  
  
       78 Dp-Screensetname              Value "dsp2demo".  
       78 Dp-Snlength                   Value 8.  
  
       78 Buffer-Max                    Value 2048.  
  
       78 Tab-Char                      Value X"09".  
       78 Cr-Char                       Value X"0A".  
  
       78 Scroll-Fraction               Value 10.  
       78 Page-Fraction                 Value 2.  
  
      *-----------------------------------------------------------------  
       78 Clip-Data-Start               Value Next.   
       01 Clip-Data-Area.  
          03 Clip-Data-1                Pic 9(4).  
          03 Filler                     Pic X Value Tab-Char.  
          03 Clip-Data-2                Pic 9(4).  
          03 Filler                     Pic X Value Tab-Char.  
          03 Clip-Data-3                Pic 9(4).  
          03 Filler                     Pic X Value Tab-Char.  
          03 Clip-Data-4                Pic 9(4).  
          03 Filler                     Pic X Value Cr-Char.  
       78 Clip-Data-Size                Value Next - Clip-Data-Start.  
  
      *-----------------------------------------------------------------  
  
       01 Char-Buffer                   Pic X(Buffer-Max).  
       01 Char-Array Redefines Char-Buffer.  
          03 Char-Array-Group Occurs Buffer-Max.  
             05 Char-Character          Pic X.  
       01 Char-Buffer-Length            Pic X(4) Comp-5.  
  
       01 Attribute-Count               Pic 9(4) Comp-5.  
       01 Attribute-Buffer.  
          03 Attribute-Array Occurs 1.  
             05 Attribute-Byte          Pic 9(2) Comp-5.  
  
      *-----------------------------------------------------------------  
       01 Terminate-Program             Pic 9(4) Value 0.  
          88 Terminate-Program-True     Value 1.  
  
       01 I                             Pic X(4) Comp-5.  
       01 J                             Pic X(4) Comp-5.  
       01 K                             Pic X(4) Comp-5.  
       01 Tmp-Var                       Pic X(4) Comp-5.  
  
       01 Event-Window-Handle           Pic 9(9) Comp-5.  
       01 Event-Inner-Window-Handle     Pic 9(9) Comp-5.  
  
       01 Event-Window-Width            Pic 9(4) Comp-5.  
       01 Event-Window-Height           Pic 9(4) Comp-5.  
       01 Event-Inner-Window-Width      Pic 9(4) Comp-5.  
       01 Event-Inner-Window-Height     Pic 9(4) Comp-5.  
       01 Event-Inner-Window-X          Pic S9(4) Comp-5 Value 0.  
       01 Event-Inner-Window-Y          Pic S9(4) Comp-5 Value 0.  
  
       01 Scroll-Amount-X               Pic 9(4) Comp-5.  
       01 Scroll-Amount-Y               Pic 9(4) Comp-5.  
       01 Scroll-Page-X                 Pic 9(4) Comp-5.  
       01 Scroll-Page-Y                 Pic 9(4) Comp-5.  
  
       01 Scroll-Horiz-Direction        Pic S9(4) Comp-5.  
       01 Scroll-Vert-Direction         Pic S9(4) Comp-5.  
       01 Scroll-Value                  Pic 9(4) Comp-5.  
  
       01 Scroll-Bar-Vert-Pos           Pic S9(4) Comp-5.  
       01 Scroll-Bar-Horiz-Pos          Pic S9(4) Comp-5.  
  
       01 Calc-Var                      Pic S9(4) Comp-5.  
       01 Rem-Var                       Pic S9(4) Comp-5.  
  
       01 Work-String                   Pic X(256).
      *-----------------------------------------------------------------  
 
       78 No-Of-Defined-Colors          Value 4. 
 
       01 Color-Table-Literals. 
          03 Filler                     Pic X(15) Value "RED". 
          03 Filler                     Pic 9(2) Comp-5 Value 3. 
          03 Filler                     Pic X(15) Value "GREEN". 
          03 Filler                     Pic 9(2) Comp-5 Value 5. 
          03 Filler                     Pic X(15) Value "BLUE". 
          03 Filler                     Pic 9(2) Comp-5 Value 4. 
          03 Filler                     Pic X(15) Value "BLACK". 
          03 Filler                     Pic 9(2) Comp-5 Value 5. 
 
       01 Color-Table Redefines Color-Table-Literals. 
         03 Color-Table-Item Occurs No-Of-Defined-Colors. 
          05 Color-Name                 Pic X(15). 
          05 Color-Length               Pic 9(2) Comp-5. 
 
       01 Color-Attribute-Table. 
          03 Cat-Item Occurs No-Of-Defined-Colors. 
             05 Colormap-Index          Pic 9(9) Comp-5. 

       01 Attrib-utes. 
          03 Attrib-Foreground          Pic 9(9) Comp-5.
          03 Attrib-Background          Pic 9(9) Comp-5.
          03 Attrib-Index               Pic 9(2) Comp-5.
      *-----------------------------------------------------------------  
       Linkage Section.  
       01 Clipboard-Area.  
          03 Clipboard-Data             Pic X(Buffer-Max).  
  
       01 Clipboard-Buffer.  
          03 Clipboard-Item-Array       Occurs 4.  
             05 Clipboard-Item          Pic 9(4).  
  
      *-----------------------------------------------------------------  
       Procedure Division.  
  
          Perform Initialise-Ds-P2  
          Perform Init-Palette
 
          Perform Until Terminate-Program-True  
  
             Perform Call-Dialog-System  
  
             Evaluate Dp-Retc-Reason  
  
             When "Exit"  
                Move 1 To Terminate-Program  
  
             When "Trace"  
                Perform Trace-On-Off  
  
             When "Color"  
                Perform Colorize-Objects  
  
             When "Clipbrd"  
                Perform Init-Clip-Data  
  
             When "Cut"  
                Perform Cut-Data  
  
             When "Copy"  
                Perform Copy-Data  
  
             When "Paste"  
                Perform Paste-Data  
  
             When "Event"  
                Perform Setup-For-Event  
  
             When "AnyEvent"  
                Perform Handle-Event  
  
             When Other  
                Perform Unknown-Function  
  
             End-Evaluate  
  
             Move Spaces To Dp-Retc-Reason  
  
          End-Perform  
  
          Stop Run.  
  
      *-----------------------------------------------------------------  
       Initialise-Ds-P2 Section.  
  
           Initialize Ds-Control-Block  
           Initialize Dp-Data-Block  
  
           Move Ds-New-Set         To Ds-Control  
           Move Dp-Screensetname   To Ds-Set-Name  
           Move Dp-Snlength        To Ds-Set-Name-Length  
           Move 3                  To Ds-Parameter-Count  
           Move Dp-Version-No      To Ds-Version-No  
           Move Dp-Data-Block-Version-No To  
                Ds-Data-Block-Version-No  
  
           Perform Call-Dialog-System  
  
           Move  Ds-Session-Id           To P2-Mf-Reserved  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Init-Palette Section.  
  
        Perform Varying I From 1 By 1   
          Until (I > No-Of-Defined-Colors)
  
           Move Pf-Name-To-Rgb       To P2-Function  
           Move Color-Name(I)        To Work-String  
           Move Color-Length(I)      To P2v-Color-Name-Length  
           Call Panels2 Using P2-Parameter-Block  
                              P2v-Attribute-Record  
                              Work-String  
           End-Call  
  
           Move Pf-Allocate-Color    To P2-Function  
           Move 1                    To P2v-Non-Exact-Match  
           Move 1                    To P2v-Table-Count  
           Call Panels2 Using P2-Parameter-Block  
                              P2v-Attribute-Record  
           End-Call  
  
           Move P2v-Color-Attribute To Colormap-Index(I)  
  
         End-Perform  
  
         Perform Varying I From 1 By 1
          Until (I > No-Of-Defined-Colors)
            Perform Varying J From 1 By 1
             Until (J > No-Of-Defined-Colors)
               Move I To Attrib-Index
               Multiply No-Of-Defined-Colors By Attrib-Index
               Add J To Attrib-Index

               Move Colormap-Index(I) To Attrib-Foreground
               Move Colormap-Index(J) To Attrib-Background

               Perform Set-Attributes

            End-Perform
         End-Perform

         Continue.  
  
      *----------------------------------------------------------------- 
       Set-Attributes Section. 
         Move Pf-Set-Attributes To P2-Function 
         Move Attrib-Index      To P2v-Attribute-Index 
         Move 1                 To P2v-Table-Count 
 
         Move Attrib-Foreground To P2v-Foreground-Color-Attribute 
         Move Attrib-Background To P2v-Background-Color-Attribute 
         Call Panels2 Using P2-Parameter-Block 
                            P2v-Attribute-Record 
         End-Call 

         Continue. 
 
      *-----------------------------------------------------------------  
       Colorize-Objects Section.  
  
          Move Pf-Set-Object-Color To P2-Function  
  
          Perform Test After Varying I From 1 By 1  
             Until I = Dp-Retc-Object-Count  
  
             Move Dp-Retc-Object(I) To P2-Descendant  
             Move Dp-Retc-Object-Parameter(I) To Attribute-Byte(1)  
             If (Attribute-Byte(1) = 0)
                Move 0 To Attribute-Count
             Else
                Move 1 To Attribute-Count  
             End-If
             Perform Panels2-Attribute-Call  
  
          End-Perform  
  
          Continue.  
  
      *-----------------------------------------------------------------  
       Init-Clip-Data Section.  
  
          Move 1234 To Dp-Clip-Item-1  
          Move 5678 To Dp-Clip-Item-2  
          Move 2468 To Dp-Clip-Item-3  
          Move 9630 To Dp-Clip-Item-4  
  
          Continue.  
  
      *-----------------------------------------------------------------  
       Cut-Data Section.  
  
           Perform Copy-Data  
  
           Move 0 To Dp-Clip-Item-1  
           Move 0 To Dp-Clip-Item-2  
           Move 0 To Dp-Clip-Item-3  
           Move 0 To Dp-Clip-Item-4  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Copy-Data Section.  
  
           Move Dp-Clip-Item-1 To Clip-Data-1  
           Move Dp-Clip-Item-2 To Clip-Data-2  
           Move Dp-Clip-Item-3 To Clip-Data-3  
           Move Dp-Clip-Item-4 To Clip-Data-4  
  
           Perform Send-To-Clipboard  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Paste-Data Section.  
  
           Set Address Of Clipboard-Area To  
               Address Of Char-Buffer  
  
           Set Address Of Clipboard-Buffer To  
               Address Of Dp-Clip-Item-Group  
  
           Move Pf-Clipboard-Initiate-Read To P2-Function  
           Move Cfmt-Text To P2c-Clipboard-Format  
           Perform Panels2-Clipboard-Call  
  
           If P2-Status = 0  
              Move Pf-Clipboard-Read To P2-Function  
              Move Buffer-Max To P2c-Clipboard-Text-Length  
              Perform Panels2-Clipboard-Call  
              Perform Get-From-Clipboard  
           End-If  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Get-From-Clipboard Section.  
  
           Move 1 To K  
           Move 1 To J  
           Move 1 To I  
  
           Perform Until I > 4  
              Perform Until Clipboard-Data(K:1) = Tab-Char Or  
                            Clipboard-Data(K:1) = Cr-Char Or  
                            K > P2c-Clipboard-Text-Length  
                    Add 1 To K  
              End-Perform  
              Move Clipboard-Data(J:k - J) To Clipboard-Item(I)  
              Add 1 To I  
              Add 1 To K  
              Move K To J  
           End-Perform  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Send-To-Clipboard Section.  
  
           Set Address Of Clipboard-Area To  
               Address Of Clip-Data-Area  
  
           Move Pf-Write-Clipboard To P2-Function  
           Move Cfmt-Text To P2c-Clipboard-Format  
           Move Clip-Data-Size To P2c-Clipboard-Text-Length  
           Perform Panels2-Clipboard-Call  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Setup-For-Event Section.  
  
           Move 0 To Event-Inner-Window-X  
           Move 0 To Event-Inner-Window-Y  
           Perform Update-Inner-Window  
  
           Move Pf-Get-Window-Info To P2-Function  
           Move Dp-Retc-Object(1) To Event-Window-Handle  
                                     P2-Descendant  
           Perform Panels2-Window-Call  
           Move P2p-Window-Width To Event-Window-Width  
           Move P2p-Window-Height To Event-Window-Height  
  
           Move Dp-Retc-Object(2) To Event-Inner-Window-Handle  
                                     P2-Descendant  
           Perform Panels2-Window-Call  
           Move P2p-Window-Width To Event-Inner-Window-Width  
           Move P2p-Window-Height To Event-Inner-Window-Height  
  
           Move Event-Inner-Window-Width To Calc-Var  
           Subtract Event-Window-Width From Calc-Var  
           Divide Calc-Var By Scroll-Fraction Giving Scroll-Amount-X  
                                              Remainder Rem-Var  
           Divide Calc-Var By Page-Fraction Giving Scroll-Page-X  
  
           If Rem-Var Not = 0  
              Add 1 To Scroll-Amount-X  
           End-If  
             
           Move Event-Inner-Window-Height To Calc-Var  
           Subtract Event-Window-Height From Calc-Var  
           Divide Calc-Var By Scroll-Fraction Giving Scroll-Amount-Y  
                                              Remainder Rem-Var  
           Divide Calc-Var By Page-Fraction Giving Scroll-Page-Y  
  
           If Rem-Var Not = 0  
              Add 1 To Scroll-Amount-Y  
           End-If  
  
           Move 1 To Scroll-Bar-Vert-Pos  
                     Scroll-Bar-Horiz-Pos  
  
           Move 0 To P2g-Scroll-Bar-Slider-Size  
           Move 1 To P2g-Scroll-Bar-Min  
           Move Scroll-Fraction To P2g-Scroll-Bar-Max  
           Add 1 To P2g-Scroll-Bar-Max  
           Move Scroll-Bar-Vert-Pos To P2g-Scroll-Bar-Slider-Posn  
           Move P2g-Vert-Scroll-Bar To P2g-Scroll-Bar-Type  
  
           Move 0 To P2-Descendant  
           Move Event-Window-Handle To P2-Ancestor  
           Move Pf-Set-Scroll-Bar-Range To P2-Function  
           Perform Panels2-Scroll-Bar-Call  
  
           Move 0 To P2g-Scroll-Bar-Slider-Size
           Move 1 To P2g-Scroll-Bar-Min  
           Move Scroll-Fraction To P2g-Scroll-Bar-Max  
           Add 1 To P2g-Scroll-Bar-Max  
           Move Scroll-Bar-Horiz-Pos To P2g-Scroll-Bar-Slider-Posn  
           Move P2g-Horiz-Scroll-Bar To P2g-Scroll-Bar-Type  
  
           Move 0 To P2-Descendant  
           Move Event-Window-Handle To P2-Ancestor  
           Move Pf-Set-Scroll-Bar-Range To P2-Function  
           Perform Panels2-Scroll-Bar-Call  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Handle-Event Section.  
  
           Evaluate Ds-Event-Type  
  
              When P2e-Gadget-Event  
                 Perform Handle-Gadget-Event  
  
           End-Evaluate  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Handle-Gadget-Event Section.  
  
           Evaluate Ds-Gadget-Command  
  
           When P2e-Sb-Line-Up  
               Move -1 To Scroll-Vert-Direction  
               Move Scroll-Amount-Y To Scroll-Value  
               Perform Reposition-Vert  
               Subtract 1 From Scroll-Bar-Vert-Pos  
               Perform Update-Scroll-Bars  
  
           When P2e-Sb-Line-Down  
               Move 1 To Scroll-Vert-Direction  
               Move Scroll-Amount-Y To Scroll-Value  
               Perform Reposition-Vert  
               Add 1 To Scroll-Bar-Vert-Pos  
               Perform Update-Scroll-Bars  
  
           When P2e-Sb-Page-Up  
               Move -1 To Scroll-Vert-Direction  
               Move Scroll-Page-Y To Scroll-Value   
               Perform Reposition-Vert  
               Subtract 5 From Scroll-Bar-Vert-Pos  
               Perform Update-Scroll-Bars  
  
           When P2e-Sb-Page-Down  
               Move 1 To Scroll-Vert-Direction  
               Move Scroll-Page-Y To Scroll-Value   
               Perform Reposition-Vert  
               Add 5 To Scroll-Bar-Vert-Pos  
               Perform Update-Scroll-Bars  
  
           When P2e-Sb-Line-Left  
               Move -1 To Scroll-Horiz-Direction  
               Move Scroll-Amount-X To Scroll-Value  
               Perform Reposition-Horiz  
               Subtract 1 From Scroll-Bar-Horiz-Pos  
               Perform Update-Scroll-Bars  
  
           When P2e-Sb-Line-Right  
               Move 1 To Scroll-Horiz-Direction  
               Move Scroll-Amount-X To Scroll-Value  
               Perform Reposition-Horiz  
               Add 1 To Scroll-Bar-Horiz-Pos  
               Perform Update-Scroll-Bars  
  
           When P2e-Sb-Page-Left  
               Move -1 To Scroll-Horiz-Direction  
               Move Scroll-Page-X To Scroll-Value   
               Perform Reposition-Horiz  
               Subtract 5 From Scroll-Bar-Horiz-Pos  
               Perform Update-Scroll-Bars  
  
           When P2e-Sb-Page-Right  
               Move 1 To Scroll-Horiz-Direction  
               Move Scroll-Page-X To Scroll-Value   
               Perform Reposition-Horiz  
               Add 5 To Scroll-Bar-Horiz-Pos  
               Perform Update-Scroll-Bars  
  
           End-Evaluate  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Reposition-Vert Section.  
  
           Move Scroll-Value To Calc-Var  
           Multiply Scroll-Vert-Direction By Calc-Var  
           Add Calc-Var To Event-Inner-Window-Y  
           Perform Update-Inner-Window  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Reposition-Horiz Section.  
  
           Move Scroll-Value To Calc-Var  
           Multiply Scroll-Horiz-Direction By Calc-Var  
           Add Calc-Var To Event-Inner-Window-X  
           Perform Update-Inner-Window  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Update-Inner-Window Section.  
  
           If Event-Inner-Window-Y < 0  
              Move 0 To Event-Inner-Window-Y   
           Else  
              If Event-Inner-Window-Y >  
                   Event-Inner-Window-Height - Event-Window-Height  
                 Move Event-Inner-Window-Height To Event-Inner-Window-Y  
                 Subtract Event-Window-Height From Event-Inner-Window-Y  
              End-If  
           End-If  
  
           If Event-Inner-Window-X < 0  
              Move 0 To Event-Inner-Window-X   
           Else  
              If Event-Inner-Window-X >  
                   Event-Inner-Window-Width - Event-Window-Width  
                 Move Event-Inner-Window-Width To Event-Inner-Window-X  
                 Subtract Event-Window-Width From Event-Inner-Window-X  
              End-If  
           End-If  
  
           Move 0 To P2p-Window-X  
           Move 0 To P2p-Window-Y  
           Subtract Event-Inner-Window-X From P2p-Window-X  
           Subtract Event-Inner-Window-Y From P2p-Window-Y  
  
           Move Event-Inner-Window-Handle To P2-Descendant  
           Move Pf-Move-Window To P2-Function  
           Perform Panels2-Window-Call  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Update-Scroll-Bars Section.  
  
           Move 0 To P2-Descendant  
           Move Event-Window-Handle To P2-Ancestor  
  
           If Scroll-Bar-Vert-Pos < 0  
              Move 1 To Scroll-Bar-Vert-Pos  
           Else  
              If Scroll-Bar-Vert-Pos > Scroll-Fraction + 1  
                 Move Scroll-Fraction To Scroll-Bar-Vert-Pos  
              End-If  
           End-If  
  
           Move Scroll-Bar-Vert-Pos To P2g-Scroll-Bar-Slider-Posn  
           Move P2g-Vert-Scroll-Bar To P2g-Scroll-Bar-Type  
           Move Pf-Set-Slider-Position To P2-Function  
  
           Move 0 To P2-Descendant  
           Move Event-Window-Handle To P2-Ancestor  
           Perform Panels2-Scroll-Bar-Call  
  
           If Scroll-Bar-Horiz-Pos < 0  
              Move 1 To Scroll-Bar-Horiz-Pos  
           Else  
              If Scroll-Bar-Horiz-Pos > Scroll-Fraction + 1  
                 Move Scroll-Fraction To Scroll-Bar-Horiz-Pos  
              End-If  
           End-If  
  
           Move Scroll-Bar-Horiz-Pos To P2g-Scroll-Bar-Slider-Posn  
           Move P2g-Horiz-Scroll-Bar To P2g-Scroll-Bar-Type  
           Move Pf-Set-Slider-Position To P2-Function  
  
           Move 0 To P2-Descendant  
           Move Event-Window-Handle To P2-Ancestor  
           Perform Panels2-Scroll-Bar-Call  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Unknown-Function Section.  
  
           Continue.  
  
      *-----------------------------------------------------------------  
       Panels2-Attribute-Call Section.  
  
           Call Panels2 Using P2-Parameter-Block  
                              Attribute-Count  
                              Attribute-Buffer.  
  
      *-----------------------------------------------------------------  
       Panels2-Clipboard-Call Section.  
  
          Call Panels2 Using P2-Parameter-Block  
                             P2c-Clipboard-Record  
                             Clipboard-Area.  
  
      *-----------------------------------------------------------------  
       Panels2-Window-Call Section.  
  
          Call Panels2 Using P2-Parameter-Block  
                             P2p-Parameter-Block.  
  
      *-----------------------------------------------------------------  
       Panels2-Scroll-Bar-Call Section.  
  
         Call Panels2 Using P2-Parameter-Block  
                            P2g-Scroll-Bar-Record  
           Continue.  
  
      *-----------------------------------------------------------------  
      * Handy little routine to switch the dialog trace on and off.  
  
       Trace-On-Off Section.  
  
           If Dp-Enter-Trap = 1  
              Move "T" To Ds-Control  
              Call Dsrun  Using Ds-Control-Block  
                                Dp-Data-Block  
                                Ds-Event-Block  
              Move "C" To Ds-Control  
           Else  
              Move "O" To Ds-Control  
              Call Dsrun  Using Ds-Control-Block  
                                Dp-Data-Block  
                                Ds-Event-Block  
              Move "C" To Ds-Control  
           End-If.  
  
      *-----------------------------------------------------------------  
       Call-Dialog-System Section.  
  
           Call Dsrun  Using Ds-Control-Block  
                             Dp-Data-Block  
                             Ds-Event-Block  
  
           If Ds-Error-Code Not = 0  
  
                 Display "dsrun error code"  
                         Ds-Error-Code        ", "  
                         Ds-Error-Details-1   ", "  
                         Ds-Error-Details-2  
  
                 Stop Run  
           End-If  
           .  
