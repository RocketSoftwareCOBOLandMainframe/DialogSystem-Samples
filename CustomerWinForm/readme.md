#Customer + .NET WinForm

This sample takes the original Customer sample and replaces the Orders dialog
with a more modern .NET Windows Forms. The main Customer application remains largely unchanged,
so this application becomes a native code main program calling .NET code to handle the
Orders form.

## How to Run the Sample

To run this sample in Visual Studio:

1. Open CustomerWinForm.sln.
2. Build and run the application.

The customer data file is prepopulated with data.
For example, enter 12345 in the 'Customer Code' field and click 'Load'. 
Then click 'Orders' to show the .NET Windows Forms version of the Orders dialog</step>

It is not possible to debug both native and .NET COBOL in the same session. 
You can debug them separately as follows:

To debug the native side, set the Customer project as the start up project. 
Right-click the project, click 'Set as StartUp project'.

To debug the .NET  side, set the OrderFormsLibrary project as the start up project.

Building for Debug registers the .Net component OrderFormsLibrary.dll as a COM object. 

The Release build is not configured to do this, so if you wish to run the Release version you must register it manually:

1. Build the Release version of the project.
2. Start a Visual Studio command prompt in administrator mode.
3. Go to the directory containing OrderFormsLibrary.dll (OrderFormsLibrary\bin\x86\Release under the sample directory).
4. Run the command "regasm OrderFormsLibrary.dll /codebase" to register the COM object.
5. Run the Customer application.

## Sample Description

This sample takes the customer project and removes the Orders dialog from the screenset.
The OrderFormsLibrary project contains a replacement Orders form which is written in
.NET COBOL. It is invoked from the main customer window, by clicking the 'Orders' button.
