1. Customer + WPF .NET GridView User Control

This sample is the original CUSTGRID sample that was supplied with Dialog System
that has been modified to replace the use of an ActiveX grid control with a new
.NET WPF user control written in COBOL.

# How to Run the Sample

To run this sample in Visual Studio:
1. Open WPFCustGrid.sln.
2. Build and run the application.

The customer data file is prepopulated with data.
For example, expand the names in the tree view control to see the customer code.
The customer code can be double-clicked to load the customer details.
This shows the WPF user control, which replaces the original ActiveX grid control.

It is not possible to debug both native and .NET COBOL in the same session. 
You can debug them separately as follows:

To debug the native side, set the WPFCustGrid project as the start up project. 
Right-click the project, click 'Set as StartUp project'.

To debug the .NET side, set the WPFGridViewUserControl project as the start up project. 
Open the project properties and in the debug settings change to 'Start external program:' and browse to find WPFCustGrid.exe
which is the output of WPFCustGrid project.
In the debug settings, also set the working directory to be the same folder as the location of WPFCustGrid.

Building for Debug registers the .Net component MicroFocus.WPFGridViewSample.dll as a COM object. 

The Release build is not configured to do this, so if you wish to run the Release version you must register it manually:

1. Build the Release version of the project.
2. Start a Visual Studio command prompt in administrator mode.
3. Go to the directory containing MicroFocus.WPFGridViewSample.dll (GridControl\bin\x86\Release under the sample directory).
4. Run the command "regasm MicroFocus.WPFGridViewSample.dll /codebase" to register the COM object.
5. Run the CustGridWPF application.

## Sample Description

The solution contains two projects, the main Customer Dialog System application and a 
new project that contains the code for a simple .NET WPF grid user control written in COBOL.
Dialog System can host ActiveX controls, so the user control is
built to be exposed as an ActiveX. The user control is not a complete implementation of
a grid control and the application is not a complete implementation. The sample is
designed to illustrate how a .NET WPF user control can be hosted, have method invoked and
fire events which can be consumed in the Dialog system application.
