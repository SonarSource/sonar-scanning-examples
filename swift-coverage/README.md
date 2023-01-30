# SonarQube-Scanner for Swift Code Coverage

This example demonstrates how to import Xcode Coverage data to SonarQube for a Swift project. It supports Xcode 13 and above.

## Prerequisites

* [SonarQube](http://www.sonarqube.org/downloads/) 8.9 LTS or Latest
* [SonarQube Scanner](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner) 4.7+

## Usage

1. Run from "swift-coverage-example"

1.a Build project

```shell
xcodebuild -project swift-coverage-example.xcodeproj/ -scheme swift-coverage-example -derivedDataPath Build/ -enableCodeCoverage YES clean build test CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
```

1.b Using xccov (recommended)

The `xccov` command line tool is the recommended option to view Xcode coverage
data and is more straightforward to use than the older `llvm-cov` tool. With
the script `xccov-to-sonarqube-generic.sh`, you can convert Xcode test results
stored in `*.xcresult` folders to the [SonarQube generic test coverage format](https://docs.sonarqube.org/latest/analyzing-source-code/test-coverage/generic-test-data/).

First, convert your Xcode coverage to the SonarQube format with the
command:

```shell
bash xccov-to-sonarqube-generic.sh Build/Logs/Test/*.xcresult/ >Coverage.xml
```

Then, use the parameter `sonar.coverageReportPaths` to reference the generated report:

```shell
sonar-scanner -Dsonar.coverageReportPaths=Coverage.xml
```

This parameter accepts a comma-separated list of files, which means you can also provide multiple coverage reports from multiple test results.

1.b Using llvm-cov 

You can also provide code coverage data using the `llvm-cov` format. The
process of generating an llvm-cov report requires several steps to get the
coverage for the application executable and the dynamic library binaries.

In the case of the project example, first, locate the `Coverage.profdata` file under the `ProfileData` folder. Then, generate an `llvm-cov` report with the command:

```shell
xcrun --run llvm-cov show -instr-profile=Build/Build/ProfileData/xxxx/Coverage.profdata \
      Build/Build/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example \
      >Coverage.report
```

Finally, use the parameter `sonar.swift.coverage.reportPaths` to reference the generated report. This parameter also accepts a comma-separated list of files.

```shell
sonar-scanner -Dsonar.swift.coverage.reportPaths=Coverage.report
```

2. Verify that for the project "swift-coverage-example" the coverage value is around 75%.
