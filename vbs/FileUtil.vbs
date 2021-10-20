Option Explicit
'! Class encapsulating all file utilities.  Created as a static class/self-instantiated namespace reference from global variable 'FileUtil'.
'! Uses ADODB.Stream so can process UTF-8 formatted files.
'!
'! @author Tim Davison
'! @date created 19/10/2021
Class FileUtilImpl

	'! Opens a file for reading.
	'! @param filepath <String> relative path to file to open
	'! @return <ADODB.Stream> open stream ready for reading
	Public Function OpenFileForReading(filepath)
		Dim objStream : Set objStream = CreateObject("ADODB.Stream")
		objStream.CharSet = "utf-8"
		objStream.Open
		objStream.LoadFromFile(filepath)
		Set OpenFileForReading = objStream
	End Function

	'! Read a line from the supplied file stream
	'! @param objStream <ADODB.Stream> open stream that can be read from
	'! @return <String> contents of the next line of the file
	Public Function ReadLine(objStream)
		ReadLine = objStream.ReadText(adReadLine)
	End Function

	'! Opens a file for writing.
	'! @return <ADODB.Stream> open stream ready for writing
	Public Function OpenFileForWriting()
		Dim objStream : Set objStream = CreateObject("ADODB.Stream")
		objStream.CharSet = "utf-8"
		objStream.Open
		Set OpenFileForWriting = objStream
	End Function

	'! Writes a line to the supplied file stream.
	'! @param objStream <ADODB.Stream> open stream that can be written to
	'! @return <String> contents of the next line to write to file
	Public Function WriteLine(objStream, text)
		objStream.WriteText text & vbCrLf
	End Function

	'! Saves the contents of the supplied file output stream to a physical file.  Replaces any existing file if present.
	'! @param objStream <ADODB.Stream> open stream that has been written to
	'! @param filepath <String> relative path to file to save
	Public Function SaveFile(objStream, filepath)
		objStream.SaveToFile filepath, adSaveCreateOverWrite
		objStream.Close
		Set objStream = Nothing
	End Function

	'! Constructor
	Private Sub Class_Initialize()
	End Sub

	'! Destructor
	Private Sub Class_Terminate()
	End Sub

End Class
Dim FileUtil : Set FileUtil = New FileUtilImpl