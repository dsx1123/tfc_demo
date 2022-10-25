<p align="center">
<img src="logo.png" width="299" height="84" border="0" alt="ACI vetR">
<br/>
ACI health check tool
<p>
<hr/>

This tool performs an ACI health check (vet) against the customer network. The goal of this tool is to provide an automated, high-quality "ACI Health Check" deliverable, with tangible value to the customer.

It consists of two components:

1. A collection tool, to be run against the APIC.
2. This tool, which analyzes the results and produces a deliverable report.

The collector tool is open source, published externally:
https://github.com/brightpuddle/aci-vetr-collector

The analysis tool is in this repository:
https://wwwin-github.cisco.com/nhemingw/aci-vetr

# Overview
Pre-compiled binary releases are provided for Windows, MacOS, and Linux for *both* tools. The analysis tool is packaged in the `.zip` files in the [releases tab](https://wwwin-github.cisco.com/nhemingw/aci-vetr/releases), and the collection tool is published to the external GitHub site in the [releases tab of that repository](https://github.com/brightpuddle/aci-vetr-collector/releases).

The collector is functionally similar to a binary moquery script--it collects a variety of managed object classes from API endpoints. The collection runs API queries in parallel and should be fairly quick to complete--in smaller labs, the collection typically takes seconds; in a large SVS fabric with a heavily loaded APIC, it was seen to take ~1 minute to complete. Results in production may vary depending on the performance of the APICs and volume of data.

The collector produces a result file called `aci-vetr-data.zip`. The result file contains structured JSON results for analysis. The analytics tool then takes `aci-vetr-data.zip` as input, performs various checks, and produces a Word document for delivery. Some consultative input is required to finalize the deliverable, but this is intended to require minimal additional time from the CE.

## Note on schema version
Schema version is version number assigned to both tools. These *must match*. In general, this is not expected to be a problem, but e.g. if you've previously used the tool with an older collector and try to run this data against a newer analytics tool, you'll get a "schema mismatch" error. This is to ensure that as new checks are added the two tools are kept in sync. To resolve this, you'll either have to use the older analytics tool, or re-run the collection with the later release. 

Note that as of version 0.6.21, the patch number **is** the schema version (21 in this case), so e.g. if you collect data with version x.x.21 you'd want to run aci-vetr with an x.x.21 release.

# Workflow
Ease of use and time to delivery are top priorities of this tool. If you have suggestions for improving the workflow, feedback is welcome.

## Step 1 - collect data
Run the collection utility against the customer network. Either provide the customer the tool via email/Box/Doc Exchange, or the customer can download and run the tool from [the external GitHub site](https://github.com/brightpuddle/aci-vetr-collector/releases) directly. Corporate filters often strip binary files from email, so it will likely be easier to download the tool directly from GitHub.

Once complete, the customer provides the `aci-vetr-data.zip` file to services. This file is the *input* for this tool.

## Step 2 - download analysis tool
Download and unzip the analysis tool from the [releases tab](https://wwwin-github.cisco.com/nhemingw/aci-vetr/releases) of this repository.

## Step 3 - set general settings, e.g. customer name
Edit the `config.json` file with your customer data and your name. This populates the doc properties on the final Word document. These are standard Word document properties--if you don't edit this file or decide to change these later you can update these in the final Word document. The doc properties are all prefixed with `cisco:` to make them easy to identify. **Remember to select all and update (Ctrl-A, F9 on Windows, Cmd-A, Fn-F9 on Mac) to populate the changes throughout the document.**

## Step 4 - run the analysis
Place the `aci-vetr-data.zip` in the same folder as the tool and run the binary. The following should all be in your working directory:

1. The binary for your platform, i.e. `aci-vetr.windows.exe`, `aci-vetr.darwin` (for Mac), or `aci-vetr.linux`.
2. The Word template file: `template.docx`
3. The config file: `config.json` with the document properties.
4. The `aci-vetr-data.zip` file from the customer's APIC.

Other than the `aci-vetr-data.zip` file from the customer, these are all included in the release zip download.

Input and output files can be be customized on the command line (run the tool with `--help` to see all options). If not specified, the tool looks for `aci-vetr-data.zip` and produces a `final.docx`.

## Step 5 - update and deliver
The tool will create a Word document: `final.docx`. This is the document to be delivered to the customer. This document contains detailed instructions on how to finalize the document prior to delivery including consultative analysis that can't be automated. **Please read the instructions in the document carefully.** Once complete, export this file to PDF for delivery.

# Feedback
This is an unofficial, personal inititive and any help and/or feedback is welcome. If you have suggestions or feature requests either submit an issue or contact me via email, WebEx Teams, or Jabber. If you'd like to contribute to the codebase directly, see the [contributing section](#contributing). I'm also interested in feedback on where it was delivered and how it was received.

Any of the following would help:

* Feedback on the phrasing in the Word document
* Feedback on the recommendations themselves, e.g. is this a best practice? Is there common designs where we shouldn't recommend this?
* Suggestings for enhancements, e.g. additional checks to run or additions to current checks

If this tool is valuable to you, please star  both the internal and external repositories and spread the word. 

# FAQ

## Why another tool? How does this compare to existing tooling?
I was unable to find a tool that checked for a number of important best practices *and* produced a high quality deliverable document ready for customer delivery. Other tooling required *extensive* manual effort to create a final deliverable.

Additionally, I wanted the ability to include real-time information in the health check. Reviewing current faults, scale, etc, requires a custom collector tool; whereas, Ming's script and the DCAF ACI health check both run against config backups. My pervious process involved scraping this data from moquery and/or the customer's GUI, more manual effort to review the data and make it presentable, and then putting it into the document. ACI vetR automates all of this.

I don't believe there's another solution that provides this functionality, but there are other tools that provide varying degrees of *similar* functionality. If you're not already familiar with the output from these other tools, you may want to run these at least once to familiarize yourself with the our other tooling.

The following comparisons are in no way intended to detract from the hard work that went into these tools. Familiarize yourself with the tooling and use what works best for your customer.

### DCAF ACI Health Check
https://services.cisco.com/

This is the evolution of the ACI Health Check from the Data Center Analytics Framework (DCAF) platform, and is now our official "ACI health check" offering. The ACI health check runs against a config backup and produces a Word document. Unfortunately, the official health check has suffered from frequent turnover and a lack of development and is missing a large number of important recommendations. The goal of ACI vetR is very similar to the ACI health check, but with the intent of producing a much more thorough and higher quality deliverable document.

Additionally, the ACI health check runs against a config backup, so it has no visibility into current state, e.g. faults, scale, etc. If you run the health check and want to provide analysis of faults or scale, these sections will need to be populated by other means.

### Ming Li's ACI Audit script
https://wwwin-gitlab-sjc.cisco.com/mingli/aciaudit

This is a Python script that performs a lot of the same checks as ACI vetR. It performs a *very* thorough analysis of the ACI config backup, and some of the checks in ACI vet were taken directly from Ming's work. The key distinquishing feature between this and ACI vetR is that ACI vetR produces a Word document ready for delivery to the customer. Additionally, like the DCAF health check, Ming's script runs against a config backup, so it doesn't have visibility into real-time state.

Ming's Audit script is extremely thorough and still more thorough than ACI vetR; however, one of the goals of this project is to continue to close this gap. ACI vetR will likely never include 100% feature parity to Ming's script; however, the goal is to include all of the most important items that expose our customers to the greatest risk.

Active maintenance of Ming's script is uncertain; however, it currently includes checks for features as of 3.2. As with this project, his audit tool appears to be an unfunded, personal project.

### Business Critical Insights (BCI)
BCI is our core Business Critical Services offering and pivitol in our recent transformation. BCI is a Splunk-based analytics dashboard primarily focused on real-time visibility and health data. BCI pulls data from CSPC, which offers config data, the capability of real-time analysis, syslog analysis, and other ongoing data collection. BCI will likely also provide best practice auditing and configuration recommendations; however, these capabilities are not yet available for ACI.

BCI is a core offering for our Business Critical Services so is well funded, under active development, and has executive prirority. It's possible that BCI will replace the functionality of ACI vetR completely at some point in the future; however, as of this writing, this capability hasn't been realized yet, and the timeline for this is uncertain.

### Network Analytics Engine (NAE)
NAE is a comprehensive analytics offering for ACI; it performs similar checks to ACI vetR and a lot more. The NAE delivery modality is similar to BCI in that it provides a web-based dashboard with advanced visualizations. It also performs its own collection and custom analysis so it has access to real-time data. One great feature of NAE is that it performs collection over time so it has the additional ability to provide trending and time-based analytics.

NAE is a premium analytics solution for ACI. This is a for-sale product offering which must be purchased by customers, so it won't be available to many BCS customers. For customers with NAE, the information reviewed by ACI vetR *should* mostly be redundant.

## Why doesn't ACI vetR run against config backups?
There are pros and cons to using a custom collection tool.

**Advantages:**
- Config backups don't provide access to real-time data, e.g. faults, scale, defects with real-time state, etc. Most customers expect a "health check" to include this information.
- The separate collector architecture leaves open the possibility of adding other real-time collection in the future, e.g. switch state, checking for specific defects, etc.
- The collected data can be kept small, fast, and in an analytic-friendly format making both the collection and analysis simple and efficient

**Disadvantages:**
- Maintenance of an additional tool
- The collector tool only collects what's needed. If new data is needed for new checks, API endpoints will need to be added to the collector tool and data recollected. Because of this, the tools have to be kept in sync. ACI vetR addresses this with the schema versioning.


# Contributing
Contributions are welcome, both in the form of feedback or directly to the codebase.

## Guidelines
Please create an issue before creating a pull request. This will facilitate tracking the change and provide a forum for discussion if necessary.

The following information covers the inner-workings of the tool. If you'd like to contribute to the codebase directly, this will help orient you on the important points that might not be immediately obviously. I'm also happy to provide orientation on the architecture of the tool or answer any questions.

## Word template
The word template is `template.docx`. `.docx` files are zip archives containing the XML contents of the word document. When unzipped, the key files are:

`word/document.xml` - the main document body
`docProps/custom.xml` - custom document properties

ACI vetR unzips `template.docx`, uses an XML library to edit the aforementioned libraries, and then zips it back up to create the final result document.

ACI vetR edits the Word template through the use of bookmarks. Current bookmarks can be viewed through **Insert > Bookmark**. Bookmarks are hidden by default, but you can make bookmarks visibible through Word settings under the View section. Bookmarks can either mark a single point in the document, or you can select a block of text and create a bookmark representing the block. There are three basic functions the tool performs on the bookmarks, depending on the type of data being presented:

1. Delete the entire bookmark. This is typically used when a feature might be enabled or disabled, i.e. a bookmark will be wrapped around text for when the feature is enabled and another bookmark wrapped around the text for when the feature is disabled. This is also used when text is version-specific. Depending on the state of the network, the tool will delete the invalid information. This allows creating high-quality content, e.g. images, etc, in Word directly and still programmatically editing the final document.
2. Tag an insert point for text. A good example of this is the fabric overview with current hardware counts. The tool finds this bookmark and then inserts the current devices and counts.
3. Tag a table. Tables are pre-created with a header and the bookmark is added to the first cell of the first row. The tool then creates as many rows as needed to present the data. Typically, tables are also wrapped in a bookmark that can be deleted if the tabular data is non-existent.

The `ooxml_test.go` file has a list of all bookmarks in the Word document and performs redumintary unit testing on these. If adding new bookmarks to the document, these should also be added to the test file.

Be careful in editing the template by not accidentally deleting any of the existing bookmarks. Also, be aware of the location of bookmarks that are intended to be deleted in conjunction with other bookmarks, i.e. deleting a section will remove any bookmarks within that section. If code logic accidentally deletes a section and then attempts to edit that same section, the tool will crash. Using the `ooxml_test.go` file and running `go test` can help validate this.

If editing the template, it's important to run the tool again with the updated template See the [testing](#testing) section below.

## Building/editing the app
The codebase is one Go package, split between files based on the structure of the ACI GUI. Before submitting a pull request, ensure the following:

- Code is formatted with the simplification flag: `gofmt -s -w`
- Errors are handled: `errcheck`
- Golint passes: `golint *.go`
- Go vet passes: `go vet *.go`
- Tests pass: `go test -v`
- The project builds: `go build`

The same code qualities standards apply to the external repository. If submitting an update that changes the schema please indicate this in the pull request, and both tools will be incremented at release.

## Testing
In addtion to the Go tests, the `test` folder contains two testing tools: `collect.py` and `analyze.py`. These are Python3 scripts for testing the collector and analyzer respectively. The configuration for this testing framework is contained within `test-config.json`, which includes local repository paths and the environments to test against. All of this will need to be customized.

These tools will build, test, and run against whichever environments are configured within the `test-config.json` file. This is an easy way to ensure changes work against a variety of designs and versions of code.

Once testing is complete, you can open the various Word documents produced by this and ensure any new sections look as expected. Ideally, testing should be performed against environments running in different states, e.g. if you're testing "disable remote EP learning," at least one lab should have it enabled and one disabled. This isn't always possible, but will help with ensuring the tool produces accurate results in all combinations of configuration.

# Future

- [ ] More tests
- [ ] A coresponding Excel workbook with full detailed output
- [x] Additional logging
- [x] ~~Hosted CI~~ Goreleaser, e.g. automation for build/test/deploy release updates
- [x] Detailed contribution guidelines
- [ ] Additional checks to run and coresponding documentation in the template
# tfc_demo
