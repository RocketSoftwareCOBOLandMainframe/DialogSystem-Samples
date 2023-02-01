       class-id MicroFocus.VisualCOBOL.WPFSampleGridView is partial
                 inherits type System.Windows.Forms.UserControl.
                 
       01 GridHost type System.Windows.Forms.Integration.ElementHost.
       01 wpfUserControl1 type WindowsFormsControlLibrary2.WPFUserControl.
       01 components type System.ComponentModel.IContainer.
      
      *> Required method for Designer support - do not modify
      *> the contents of this method with the code editor.
       method-id InitializeComponent private.
       procedure division.
       set GridHost to new System.Windows.Forms.Integration.ElementHost
       set wpfUserControl1 to new WindowsFormsControlLibrary2.WPFUserControl
       invoke self::SuspendLayout
      *> 
      *> GridHost
      *> 
       set GridHost::BackColor to type System.Drawing.SystemColors::ButtonFace
       set GridHost::Dock to type System.Windows.Forms.DockStyle::Fill
       set GridHost::Location to new System.Drawing.Point( 0 0)
       set GridHost::Name to "GridHost"
       set GridHost::Size to new System.Drawing.Size( 549 169)
       set GridHost::TabIndex to 0
       set GridHost::Text to "elementHost1"
       set GridHost::Child to wpfUserControl1
      *> 
      *> WPFSampleGridView
      *> 
       set self::AutoScaleDimensions to new System.Drawing.SizeF( 6 13)
       set self::AutoScaleMode to type System.Windows.Forms.AutoScaleMode::Font
       invoke self::Controls::Add(GridHost)
       set self::Name to "WPFSampleGridView"
       set self::Size to new System.Drawing.Size( 549 169)
       invoke self::add_Load(new System.EventHandler(self::WPFSampleGridView_Load))
       invoke self::ResumeLayout(False)
       end method.

      *> Clean up any resources being used.      
       method-id Dispose override protected.
       local-storage section.
       linkage section.
       procedure division using by value disposing as condition-value.
           if disposing then
               if components not = null then
                   invoke components::Dispose()
               end-if
           end-if
           invoke super::Dispose(by value disposing)
           goback.
       end method.

       end class.
