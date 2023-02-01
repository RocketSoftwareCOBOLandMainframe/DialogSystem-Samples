# .NET Customer

This sample is the original Customer sample that was supplied with Dialog System.
The key difference with this sample is that it is compiled to .NET code and
run under .NET. The existing Dialog System runtime calls remain but are automatically
converted to Platform Invoke calls into native code.

## How to Run the Sample

To run this sample in Visual Studio:

1. Open ManagedCustomer.sln.
2. Build and run the application.

The customer data file (cust.ism) has been pre-populated with data.
The customer data file is prepopulated with data.
For example, enter 12345 in the 'Customer Code' field and click 'Load'.

## Sample Description

This simple project contains the code from the original Customer sample that shipped
with the graphical version of Dialog System. The project is a .NET code project and
so compiles to a .NET assembly. The existing call to the Dialog System runtime is
converted to a Platform Invoke call and will still execute in native code. To accomplish
this the project has added a reference to the Dialog System runtime which you can see
if you expand the 'References' folder in Solution Explorer. The call to Dialog System
has been modified to correct the case of the main entry point and must also supply
all parameters that Dialog System may expect.
