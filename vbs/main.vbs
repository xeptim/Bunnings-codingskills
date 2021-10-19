Option Explicit
'! Script: Bunnings-codingskills
'!
'! @author Tim Davison
'! @date created 19/10/2021

Log.Info "Catalgoue merge starting..."

Dim objStream : Set objStream = FileUtil.OpenFile(".\input\barcodesA.csv")
Do Until objStream.EOS
	Log.Debug FileUtil.ReadLine(objStream)
Loop

Log.Info "Catalgoue merge complete."
Log.RunTime