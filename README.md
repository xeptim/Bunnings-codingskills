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
	- the merged catalog as requested
	- note that this output file is re-generated each time, for both solutions, and will replace existing file for either solution
- .\output\master_data.csv
	- additional info file with all data provided including suppliers and barcodes, used to confirm output
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
	- the merged catalog as requested
	- note that this output file is re-generated each time, for both solutions, and will replace existing file for either solution

## Review/Further Thoughts

### Potential improvements
- Both solutions cater for more source companies to be included, however:
	- in both solutions the companies to iterate over is declared in code
	- a better solution may be to allow command-line arguments or reading in a config file
	- both solutions depend on a strict naming standard, a config file or alternative way of loading files would make sense if this was to be used more extensively
- VBScript solution includes a quick-and-dirty implementation of logging and file utility packages.  I did not go to this extent with the Node solution, presumably in an enterprise environment these frameworks would already be part of the infrastructure and avilable for use.
- VBScript solution has poor CSV parsing, heavily dependant on valid input being provided, with no mid-value commas allowed and does not cater for quotes around values
- Neither solution handles errors particularly well
- Neither solution has any unit testing implemented

### Alternate designs
Given the data manipulation of the task was essentially one of set operations I felt the ideal way would be to use a database.  I considered using a simple local DB (e.g. SQLLite), but decided not to as that may introduce too much additional work beyond what was required (it is a coding challenge, not an architecture challenge).  In an enterprise system I would imagine this data would be available in a database and SQL queries (or similar) would handle collation of data since that is what they are optimised to do, and it is unlikely the input data would be un-changing.  Dynamically generating the catalog on request would likely be the required business outcome.

I also noticed that the Suppliers data was not used.  Was this intentional?  This would have been something to clarify with stakeholders.  The presence of unused data made me wonder whether I had misunderstood the requirements (I still feel I may have).  In my Node.js solution it is ignored completely.

### Multiple solutions
Initially I decided on VBScript as language of choice because:
- least dependencies (a local Windows PC is a pretty safe assumption)
- no build/compile process
- problem being solved is primarily local file IO based

However, as in all things advantages are offset by potential disadvantages:
- Had to use VBScript natives, could not access .NET interops layer
	- I did not feel I could assume .NET installed locally or enabled for CLI
	- There is a command to set the local environment path and modify .NET local configuration options to allow interops on CLI, but to do so without user consent would not be acceptable (and potentially blocked).
- VBScript does not have a well-established library/package base to draw from
	- Some parts of the solution seem clunky and error-prone, in particular CSV parsing and generation

After completing the VBScript solution I was mindful it is a somewhat archaic language choice, and thought of Node.js.  I was interested in a few aspects of Node I had never done before:
- Running as a CLI
- File operations
- CSV libraries
	- (I was primarily interested in this last point, given Node's rich library/package options, just how much coding/string manipulation could I actually avoid in the more modern langauge, and how much additional build overhead would that add?)

After satisfying my own curiosity I realised I had a near-working solution, so continued to completion and have provided both.