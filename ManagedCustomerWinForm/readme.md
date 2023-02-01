# .NET Customer + Win Form

This sample takes the .NET Customer sample and the .NET Order Forms Dialog
that is used in the Customer + WinForm sample and puts the two together to form
a sample where all the COBOL is compiled to .NET. The Dialog System UI remains in
native code. The advantage of moving all the code to .NET means that the native/.NET
interop via COM is no longer relevant which simplifies the sample greatly.
Compare this sample with the Customer + Win Form sample.

## How to Run the Sample

To run this sample in Visual Studio:

1. Open ManagedCustomerWinForm.sln.
2. Build and run the application.

The customer data file (cust.ism) has been pre-populated with data.
The customer data file is prepopulated with data. For example, enter 12345 in the 'Customer Code' field and click 'Load'.

## Sample Description

This simple project contains the code from the original Customer sample that shipped
with the graphical version of Dialog System. The project is a .NET code project and
so compiles to a .NET assembly. The existing call to the Dialog System runtime is
converted to a Platform Invoke call and will still execute in native code. To accomplish
this the project has added a reference to the Dialog System runtime which you can see
if you expand the 'References' folder in Solution Explorer. The call to Dialog System
has been modified to correct the case of the main entry point and must also supply
all parameters that Dialog System may expect.
The new Order Form dialog written in .NET COBOL is invoked from the main customer using
.NET COBOL syntax because this is now compiled to .NET code. This differs from the
Customer + Win Form sample which has to use native/.NET interop via COM to pass the
data between the main customer program and the new Order form. From the .NET side, the
Order Form no longer has to use .NET marshalling to get the data and can remove the COM
interfaces previously used to communicate with native code. Additionally, the project
no longer needs to set the project property 'Register For COM Interop'.
