# Dialog System CALLDEMO sample

This sample is the original CALLDEMO sample that was supplied with Dialog System.
All that has been changed is the creation of a Visual COBOL project to replace
the Net Express project. The sample uses the DSCOBCAL Dialog System Extension to 
call the COBOL routine CBL_GET_OS_INFO to retrieve information about your
system. The information is then displayed in a window.

## How to Run the Sample

To run this sample in Visual Studio:

1. Open CALLDEMO.sln.
2. Select Start external program on the Debug property page.
3. Select dsrunner.exe from your product installation.
4. Type '/l CALLDEMO' in the Command line arguments.
5. Start debugging.
