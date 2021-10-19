/**
 * main.js
 * TODO
 *
 * @author Tim Davison
 * @created 19/10/2021
 */
const fs = require('fs');
const csv = require('csv-parser');
const fastcsv = require('fast-csv');

/**
 * Sources to derive catalog from, extend this array to generate from more sources.
 */
const sources = ['A','B'];

main();

/**
 * Generates a marged catalogue based on the data loaded from files for the sources specified.
 */
async function main() {
	var resultData = [];  // final result data to be written to CSV
	var barcodeRef = [];  // reference data to prevent duplicate products with the same barcode

	// iterate over supplied sources
	for (let i = 0; i < sources.length; i++ ) {

		// load in catalog and barcode data - supplier data seems not to be used
		let srcCatalogData = await readCatalogData(sources[i]);
		let srcBarcodeData = await readBarcodeData(sources[i]);

		// iterate over each product in this sources catalogue
		for (let j = 0; j < srcCatalogData.length; j++) {
			let obj = srcCatalogData[j];

			// check if product barcode is already found from a previous source
			let barcode = lookupBarcode(srcBarcodeData, obj.SKU);
			if (barcodeRef.indexOf(barcode) >= 0) {
				// do not add to result list - exit early
				continue;
			}

			// check if product already exists in the result catalog
			if (productExists(resultData, obj)) {
				// do not add to result list - exit early
				continue;
			}

			// add the product to the catalogue
			resultData.push(obj);

			// add the barcode to the reference list
			barcodeRef.push(barcode);

		}
	}

	// write output CSV
	const outStream = fs.createWriteStream('./output/result_output.csv');
	fastcsv.write(resultData, { headers: true })
	.pipe(outStream);

}

/**
 * Lookup a barcode from a supplied barcode data array for the specified SKU.
 * @param arr {array} barcode data to search within
 * @param sku {string} product SKU to search for
 * @return {string} barcode for the associated product
 */
function lookupBarcode(arr, sku) {
	for (let i = 0; i < arr.length; i++) {
		if (arr[i].SKU == sku) {
			return arr[i].Barcode;
		}
	}
}

/**
 * Check whether a product exists in the provided array.
 * @param arr {array} product array to search within
 * @param obj {object} data object to compare for the same values
 * @return true|false whether an object with the same values is already in the array
 */
function productExists(arr, obj) {
	arr.forEach( function(elem) {
		if (elem.SKU == obj.SKU && elem.Description == obj.Description && elem.Source == obj.Source) {
			return true;
		}
	});

	// if got to here, not found so return false
	return false;
}

/**
 * Load catalogue data from the source specified - assumes file naming convention and location.
 * @param src {string} unique identifier for the source company - input filenames must match
 * @return {array} list of objects with the data from the input file
 */
function readCatalogData(src) {
	return new Promise(resolve => {

		var tmp = [];

		fs.createReadStream('./input/catalog' + src + '.csv')
		.pipe(csv())
		.on('data', function(data) {
			var obj = {'SKU': data.SKU, 'Description': data.Description, 'Source': src};
			tmp.push(obj);
		})
		.on('end', function() {
			resolve(tmp);
		});
	});

}

/**
 * Load barcode data from the source specified - assumes file naming convention and location.
 * @param src {string} unique identifier for the source company - input filenames must match
 * @return {array} list of objects with the data from the input file
 */
function readBarcodeData(src) {
	return new Promise(resolve => {

		var tmp = [];

		fs.createReadStream('./input/barcodes' + src + '.csv')
		.pipe(csv())
		.on('data', function(data) {
			var obj = {'SupplierID': data.SupplierID, 'SKU': data.SKU, 'Barcode': data.Barcode};
			tmp.push(obj);
		})
		.on('end', function() {
			resolve(tmp);
		});
	});

}