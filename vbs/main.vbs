Option Explicit
'! Script: Bunnings-codingskills
'! Generates a merged superset catalogue given multiple
'!
'! @author Tim Davison
'! @date created 19/10/2021

Log.Info "Catalgoue merge starting..."

' load the catalogue and supplier info for the company first
Dim objSrcCatalog : Set objSrcCatalog = LoadCatalog
Dim objSrcSuppliers : Set objSrcSuppliers = LoadSuppliers


Dim i : For Each i In objSrcCatalog.Keys
	WScript.Echo i & " " & objSrcCatalog.Item(i)
Next


'Dim i :
For Each i In objSrcSuppliers.Keys
	WScript.Echo i & " " & objSrcSuppliers.Item(i)
Next


Log.Info "Catalgoue merge complete."
Log.RunTime

'! @todo
Function LoadCatalog()
	Dim objData : Set objData = CreateObject("Scripting.Dictionary")
	Dim objStream : Set objStream = FileUtil.OpenFile(".\input\catalogA.csv")

	Do Until objStream.EOS
		Dim arrVals : arrVals = Split(FileUtil.ReadLine(objStream), ",")

		' ignore the header rows
		If arrVals(0) <> "SKU" Then
			objData.Add arrVals(0), arrVals(1)
		End If

	Loop
	Set LoadCatalog = objData
End Function


'! @todo
Function LoadSuppliers()
	Dim objData : Set objData = CreateObject("Scripting.Dictionary")
	Dim objStream : Set objStream = FileUtil.OpenFile(".\input\suppliersA.csv")

	Do Until objStream.EOS
		Dim arrVals : arrVals = Split(FileUtil.ReadLine(objStream), ",")

		' ignore the header rows
		If arrVals(0) <> "ID" Then
			objData.Add arrVals(0), arrVals(1)
		End If

	Loop
	Set LoadSuppliers = objData
End Function