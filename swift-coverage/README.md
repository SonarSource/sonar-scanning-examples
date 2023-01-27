# SonarQube-Scanner for Swift Code Coverage

This example demonstrates how to import Xcode Coverage data (aka ProfData) to SonarQube for a Swift project. It supports Xcode 13 and above.

## Prerequisites

* [SonarQube](http://www.sonarqube.org/downloads/) 9.8 or Latest
* [SonarQube Scanner](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner) 4.8+

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
stored in `*.xcresult` folders to a SonarQube generic XML file and then pass it
to the Sonar Scanner to get your Xcode coverage data into SonarQube.

First, convert your Xcode coverage to the SonarQube generic format with the
command:

```shell
bash xccov-to-sonarqube-generic.sh Build/Logs/Test/*.xcresult/ >Coverage.xml
```

Then, configure the report file with the `sonar.coverageReportPaths` option
when executing sonar-scanner:

```shell
sonar-scanner -Dsonar.projectKey=TestCoverage -Dsonar.coverageReportPaths=Coverage.xml
```

1.b Using llvm-cov 

You can also provide code coverage data using the `llvm-cov` format. The
process of generating an llvm-cov report requires several steps to get the
coverage for the application executable and the dynamic library binaries. For
the project example, you can use the following command where `<id>` should
match the folder name under `ProfileData`:

```shell
xcrun --run llvm-cov show -instr-profile=Build/Build/ProfileData/<id>/Coverage.profdata \
      Build/Build/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example \
      >Coverage.report
```

Then, configure the report file with the `sonar.swift.coverage.reportPaths`
option when executing sonar-scanner:

```shell
sonar-scanner -Dsonar.projectKey=TestCoverage -Dsonar.sources=. -Dsonar.swift.coverage.reportPaths=Coverage.report
```

2. Verify that for the project "swift-coverage-example" the coverage value is > 65%.
