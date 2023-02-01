# Customer with Visual Style

This sample is the original CUSTOMER sample that was supplied with Dialog System.
All that has been changed is the creation of a Visual COBOL project to replace
the Net Express project and the addition of a manifest to enable the Visual Style.

## How to Run the Sample

To run this sample in Visual Studio:

1. Open Customer.sln.
2. Build and run the application.

The customer data file is prepopulated with data.
For example, enter 12345 in the 'Customer Code' field and click 'Load'.

## Sample Description

This simple project contains the code from the original Customer sample that shipped
with the graphical version of Dialog System. It builds and runs exactly
as before, except that it uses the Visual COBOL version of the COBOL
and Dialog System runtime.
The project contains the screenset (CUSTOMER.GS) and the customer data file (CUST.ISM).
The properties of both these files have 'Build Action' set to 'Content' and 'Copy to Output Directory'
to 'Copy if Newer'. In general, screensets added to a Visual COBOL project always
have these properties set so that when the application is run, the screenset is
available from the build output folder.
You can double-click a screenset to launch the Dialog System designer and edit the screenset. 
