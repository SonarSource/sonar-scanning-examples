# SonarScanner - Swift Code Coverage Example

This example demonstrates how to import Xcode Coverage data to SonarQube for a Swift project. See [[Coverage & Test Data] Generate Reports for Swift](https://community.sonarsource.com/t/coverage-test-data-generate-reports-for-swift/9700) for more information including alternative methods to import coverage data into SonarQube/SonarCloud.

## Prerequisites
* [SonarScanner](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner/) 5.x or higher
* [Xcode](https://developer.apple.com/xcode/) 13.3+

## Usage

Run the following commands in folder `swift-coverage-example`.

### Build project

Use `xcodebuild` to build and test the project example with the command:

```shell
xcodebuild -project swift-coverage-example.xcodeproj/ -scheme swift-coverage-example -derivedDataPath Build/ -enableCodeCoverage YES clean build test CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
```

### Using xccov (recommended)

The `xccov` command line tool is the recommended option to view Xcode coverage
data and is more straightforward to use than the older `llvm-cov` tool. With
the script `xccov-to-sonarqube-generic.sh`, you can convert Xcode test results
stored in `*.xcresult` folders to the [SonarQube generic test coverage format](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/test-coverage/generic-test-data/).

First, locate the Xcode test result folder (`*.xcresult`). Then use it as a parameter to the script converting the coverage data to the SonarQube format as in the following example:

```shell
bash xccov-to-sonarqube-generic.sh Build/Logs/Test/Run-swift-coverage-example-2023.01.27_16-07-44-+0100.xcresult/ >Coverage.xml
```

Then, use the parameter `sonar.coverageReportPaths` to reference the generated report:

```shell
sonar-scanner -Dsonar.coverageReportPaths=Coverage.xml
```

This parameter accepts a comma-separated list of files, which means you can also provide multiple coverage reports from multiple test results.

### Using llvm-cov 

You can also provide code coverage data using the `llvm-cov` format. The
process of generating an llvm-cov report requires several steps to get the
coverage for the application executable and the dynamic library binaries.

In the case of the project example, first, locate the `Coverage.profdata` file
under the `ProfileData` folder. Then, generate an `llvm-cov` report as in the
following example (the located `Coverage.profdata` file should be the value of `-instr-profile` parameter):

```shell
xcrun --run llvm-cov show -instr-profile=Build/Build/ProfileData/00006000-000428843C29801E/Coverage.profdata \
      Build/Build/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example \
      >Coverage.report
```

Finally, use the parameter `sonar.swift.coverage.reportPaths` to reference the generated report. This parameter also accepts a comma-separated list of files.

```shell
sonar-scanner -Dsonar.swift.coverage.reportPaths=Coverage.report
```

### Verify in SonarQube

Verify in SonarQube that for the project `swift-coverage-example` the coverage value is around 75%.
