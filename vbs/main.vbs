Option Explicit
'! Script: Bunnings-codingskills/vbs/main.vbs
'! Generates a merged superset catalogue given multiple source catalogs.
'!
'! @author Tim Davison
'! @date created 19/10/2021

Log.Info "Catalgoue merge starting..."

Dim arrCompanyList : arrCompanyList = Array("A", "B")

' create a list of objects, this will be the master list
Dim objProducts : Set objProducts = CreateObject("Scripting.Dictionary")
Dim objCatalog : Set objCatalog =  CreateObject("Scripting.Dictionary")

' for each company provided
Dim i : For Each i In arrCompanyList
	Log.Info "Loading data for company '" & i & "'..."

	' load the catalogue and supplier info for the company first
	Dim objSrcCatalog : Set objSrcCatalog = LoadCatalog(i)
	Dim objSrcSuppliers : Set objSrcSuppliers = LoadSuppliers(i)

	' load and append the barcode info to the master list of products
	Call AddProducts(i)
Next

' write the master data (optional)
Log.Info "Generating master data..."
WriteMasterData()

' write catalog data
Log.Info "Generating catalog output..."
WriteCatalogData()

Log.Info "Catalgoue merge complete."
Log.RunTime

'! Writes the full set of master data to an output file.
Function WriteMasterData()
	Dim objStream : Set objStream = FileUtil.OpenFileForWriting()

	' write CSV headers
	FileUtil.WriteLine objStream, "Barcode,SKU,Description,SupplierID,SupplierName,CompanyID"

	Dim i : For Each i In objProducts
		Dim tmp: tmp = i
		tmp = tmp & "," & objProducts(i)("SKU")
		tmp = tmp & "," & objProducts(i)("Description")
		tmp = tmp & "," & objProducts(i)("SupplierID")
		tmp = tmp & "," & objProducts(i)("SupplierName")
		tmp = tmp & "," & objProducts(i)("CompanyID")

		FileUtil.WriteLine objStream, tmp
	Next

	FileUtil.SaveFile objStream, ".\output\master_data.csv"

End Function

'! Writes the merged catalog to an output file.
Function WriteCatalogData()
	Dim objStream : Set objStream = FileUtil.OpenFileForWriting()

	' write CSV headers
	FileUtil.WriteLine objStream, "SKU,Description,Source"

	Dim i : For Each i In objCatalog
		Dim tmp: tmp = objCatalog(i)("SKU")
		tmp = tmp & "," & objCatalog(i)("Description")
		tmp = tmp & "," & objCatalog(i)("Source")

		FileUtil.WriteLine objStream, tmp
	Next

	FileUtil.SaveFile objStream, ".\output\result_output.csv"

End Function

'! Adds products for the specified company to the list of products in the fill master data list.  Duplicate barcodes are ignored/skipped.
'! @param companyID <String> identifies the company to load products for
Function AddProducts(companyID)
	Dim objStream : Set objStream = FileUtil.OpenFileForReading(".\input\barcodes" & companyID & ".csv")

	Do Until objStream.EOS
		Dim arrVals : arrVals = Split(FileUtil.ReadLine(objStream), ",")

		' ignore the header rows
		If arrVals(0) <> "SupplierID" Then

			' only add the product if the barcode does not already exist
			If Not objProducts.Exists(arrVals(2)) Then

				' add to products master data
				objProducts.Add arrVals(2), CreateObject("Scripting.Dictionary")
				objProducts(arrVals(2)).Add "SupplierID", arrVals(0)
				objProducts(arrVals(2)).Add "SKU", arrVals(1)
				objProducts(arrVals(2)).Add "SupplierName", objSrcSuppliers(arrVals(0))
				objProducts(arrVals(2)).Add "Description", objSrcCatalog(arrVals(1))
				objProducts(arrVals(2)).Add "CompanyID", companyID

				' check if already in catalogue
				If Not ProductExistsInCatalogue(arrVals(1), objSrcCatalog(arrVals(1)), companyID) Then
					Dim i : i = objCatalog.Count
					objCatalog.Add i, CreateObject("Scripting.Dictionary")
					objCatalog(i).Add "SKU", arrVals(1)
					objCatalog(i).Add "Description", objSrcCatalog(arrVals(1))
					objCatalog(i).Add "Source", companyID
				End If

			End If
		End If

	Loop
End Function

'! Checks whether a product is already in the merged catalogue list.  Equivalency determine by a combination of all three function arguments.
'! @param strSKU <String> identifies the product (with potential collisions)
'! @param strDescription <String> product description
'! @param strCompanyID <String> identifies the source company
'! @return True|False whether there already exists a product in the list with the same attributes
Function ProductExistsInCatalogue(strSKU, strDescription, strCompanyID)
	ProductExistsInCatalogue = False

	Dim i : For Each i In objCatalog.Keys

		' short-circuit logic to ease code readability
		If objCatalog(i)("SKU") = strSKU And objCatalog(i)("Description") = strDescription And objCatalog(i)("Source") = strCompanyID Then
			ProductExistsInCatalogue = True
			Exit Function
		End If
	Next

	' if got to here then the product was not found - will return false
End Function

'! Loads catalogue data for the specified company.
'! @param companyID <String> identifies the company to load data for
'! @return <Dictionary> list of products for that company, SKU's are keys
Function LoadCatalog(companyID)
	Dim objData : Set objData = CreateObject("Scripting.Dictionary")
	Dim objStream : Set objStream = FileUtil.OpenFileForReading(".\input\catalog" & companyID & ".csv")

	Do Until objStream.EOS
		Dim arrVals : arrVals = Split(FileUtil.ReadLine(objStream), ",")

		' ignore the header rows
		If arrVals(0) <> "SKU" Then
			objData.Add arrVals(0), arrVals(1)
		End If

	Loop
	Set LoadCatalog = objData
End Function

'! Loads supplier data for the specified company.
'! @param companyID <String> identifies the company to load data for
'! @return <Dictionary> list of suppliers for that company, SupplierID's are keys
Function LoadSuppliers(companyID)
	Dim objData : Set objData = CreateObject("Scripting.Dictionary")
	Dim objStream : Set objStream = FileUtil.OpenFileForReading(".\input\suppliers" & companyID & ".csv")

	Do Until objStream.EOS
		Dim arrVals : arrVals = Split(FileUtil.ReadLine(objStream), ",")

		' ignore the header rows
		If arrVals(0) <> "ID" Then
			objData.Add arrVals(0), arrVals(1)
		End If

	Loop
	Set LoadSuppliers = objData
End Function

'! Writes a string representation of a Dictionary object to standard output.  Used for debugging only.  Recursive function.
Function DictionaryToString(obj, prefix)
	Dim i : For Each i In obj.Keys
		If TypeName(obj.Item(i)) <> "Dictionary" Then
			WScript.Echo prefix & "[" & i & ":" & obj.Item(i) & "]"
		Else
			WScript.Echo prefix & "[" & i & ":"
			Call DictionaryToString(obj.Item(i), prefix & "  ")
			WScript.Echo prefix & "]"
		End If
	Next
End Function
