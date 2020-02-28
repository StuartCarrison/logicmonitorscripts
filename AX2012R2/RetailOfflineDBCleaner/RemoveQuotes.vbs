' Define needed constants
Const ForReading = 1
Const ForWriting = 2
Const TriStateUseDefault = -2

' Get input file name from command line parm, if 2 parms entered
' use second as new output file, else rewrite to input file
If (WScript.Arguments.Count > 0) Then
  sInfile = WScript.Arguments(0)
Else
  WScript.Echo "No filename specified."
  WScript.Quit
End If
If (WScript.Arguments.Count > 1) Then
  sOutfile = WScript.Arguments(1)
Else
  sOutfile = sInfile
End If

' Create file system object
Set oFSO = CreateObject("Scripting.FileSystemObject")

' Read entire input file into a variable and close it
Set oInfile = oFSO.OpenTextFile(sInfile, ForReading, False, TriStateUseDefault)
sData = oInfile.ReadAll
oInfile.Close
Set oInfile = Nothing

' Remove unwanted characters
sData = Replace(sData, """", "")

' Write file with any changes made
Set oOutfile = oFSO.OpenTextFile(sOutfile, ForWriting, True)
oOutfile.Write(sData)
oOutfile.Close
Set oOutfile = Nothing

' Cleanup and end
Set oFSO = Nothing
Wscript.Quit
