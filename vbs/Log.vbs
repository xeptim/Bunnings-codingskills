Option Explicit
'! Class encapsulating all logging behaviours.  Created as a static class/self-instantiated namespace reference from global variable 'Log'.
'!
'! @author Tim Davison
'! @date created 19/10/2021
Class LogImpl

	'! Writes a debug statement.  Debug statements are only written to screen, not to the log file.
	Public Function Debug(msg)
		WScript.Echo Timestamp & " [DEBUG] - " & msg
	End Function

	'! Writes an info message to the logfile.
	'! @param msg <String> message to write to logfile
	Public Function Info(msg)
		LogToFile " [INFO] - " & msg
	End Function

	'! Writes an error message to the logfile.
	'! @param msg <String> message to write to logfile
	Public Function Error(msg)
		LogToFile " [ERROR] - " & msg
	End Function

	'! Writes the current execution time for the script.
	Public Function RunTime()
		LogToFile " Duration: " & Int((Timer - m_intRunStart) * 1000) & " ms"
	End Function

	'! Writes a message to the logfile.  Private so must use an exposed logging function.
	'! @param prefix <String> Prefix to apply before the message
	Private Function LogToFile(msg)
		If m_objLogFile Is Nothing Then
			Dim x : x = Now()
			Dim strFilepath : strFilepath = ".\log\" & DateStamp & ".log"

			' ensure logging folder is created
			Dim objFSO : Set objFSO = CreateObject("Scripting.FileSystemObject")
			If objFSO.FolderExists(".\log\") <> True Then
				objFSO.CreateFolder(".\log\")
			End If

			Set m_objLogFile = objFSO.OpenTextFile(strFilepath, 8, True)
		End If

		If Len(msg) > 0 Then
			WScript.Echo Timestamp & Replace(msg, vbCrLf, " ")
			m_objLogFile.WriteLine(Timestamp & Replace(msg, vbCrLf, " "))
		End If
	End Function

	'! Returns a basic timestamp string
	'! @return <String> current date and time
	Public Function Timestamp()
		Dim x : x = Now()
		Dim t : t = Timer()
		Dim ms : ms = Int( (t - Int(t)) * 1000 )  ' need to get milliseconds from Timer - not available from Now
		Timestamp = Year(x) & "-" & ZPad(Month(x), 2) & "-" & ZPad(Day(x), 2) & " " & ZPad(Hour(x), 2) & ":" & ZPad(Minute(x), 2) & ":" & ZPad(Second(x), 2) & ":" & ZPad(ms, 3)
  	End Function

	'! Returns a basic datestamp string
	'! @return <String> current date
	Public Function DateStamp()
		Dim x : x = Now()
		DateStamp = Year(x) & "-" & ZPad(Month(x), 2) & "-" & ZPad(Day(x), 2)
	End Function

	'! Pads a string with a zero's to the left (i.e. right-justified).
	'! @param str <String> string to pad
	'! @param length <int> length of the padded string to return
	'! @return <String> original string wouth padded zero's
	Function ZPad(str, length)
		ZPad = String(length - Len(str), "0") & str
	End Function

	Private m_intRunStart
	Private m_objLogFile

	'! Constructor
	Private Sub Class_Initialize()
		m_intRunStart = Timer()  ' record the time the script started so we can record duration
		Set m_objLogFile = Nothing
	End Sub

	'! Destructor
	Private Sub Class_Terminate()
		' if logging enabled close log file
		If Not m_objLogFile Is Nothing Then
			m_objLogFile.WriteLine(String(80, "-"))
	  		m_objLogFile.Close
			Set m_objLogFile = Nothing
		End If
	End Sub

End Class
Dim Log : Set Log = New LogImpl