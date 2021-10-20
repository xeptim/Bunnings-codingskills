# Coding Skills Challenge for Tim DAVISON

I have provided two solutions to the coding challenge using the following languages (reasons why I'm providing both is explained in more detail below):
- VBScript
- Node.js

## Running the solutions

### VBScript

*Pre-requisites*
- Windows machine

*Run*
- From the repo root
```
cscript.exe main.wsf
```

*Outputs*
- .\output\result_output.csv
	- the merged catalog requested
- .\output\master_data.csv
	- additional info file including all data provided including suppliers and barcodes used to confirm output
	- optional, could be deactivated from within code
- log files
	- located in .\log
	- new log file created per day, appended to on each run

### Node.js

*Pre-requisites*
- Node.js installed
	- tested/working on v8.17.0

*Packages*
- Two packages are required to run
```
npm install csv-parser
```
```
npm install fast-csv
```

*Run*
- From the repo root
```
node js\main.js
```

*Outputs*
- .\output\result_output.csv
	- the merged catalog requested