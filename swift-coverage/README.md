# SonarScanner - Swift Code Coverage Example

This example demonstrates how to import Xcode Coverage data to SonarQube for a Swift project. See [[Coverage & Test Data] Generate Reports for Swift](https://community.sonarsource.com/t/coverage-test-data-generate-reports-for-swift/9700) for more information including alternative methods to import coverage data into SonarQube/SonarCloud.

If you encounter issues with this bash script, use a dedicated Swift coverage tool like [Slather](https://github.com/SlatherOrg/slather).

## Prerequisites
* [SonarScanner CLI](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner) 8.x or higher
* [Xcode](https://developer.apple.com/xcode/) 16 or higher

## Usage

Run the following commands in folder `swift-coverage-example`.

### Build project

Use `xcodebuild` to build and test the project example with the command:

```shell
xcodebuild -project swift-coverage-example.xcodeproj/ -scheme swift-coverage-example -derivedDataPath Build/ -enableCodeCoverage YES clean build test CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
```

### Using slather (highly recommended)

[Slather](https://github.com/SlatherOrg/slather) is a Ruby gem that generates coverage reports for Xcode projects and can hook into CI.
See various options and output formats [here](https://github.com/SlatherOrg/slather/blob/master/lib/slather/command/coverage_command.rb).

```shell
slather coverage --sonarqube-xml --scheme <schemeName> --build-directory <buildDirectory>  path/to/project.xcodeproj
```
This command uses the [SonarQube generic test coverage format](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/test-coverage/generic-test-data) generating the default `sonarqube-generic-coverage.xml` coverage file in the base directory. This means you need to use `sonar.coverageReportPaths=<path/to/sonarqube-generic-coverage.xml>` when running the SonarScanner.

Example of a simple GitHub Actions workflow. Notice the usage of Ruby version and `bundle exec` commands:
```yaml
name: Build
on:
  push:
    branches:
      - main
  pull_request:
    types: [opened, synchronize, reopened]
jobs:
  sonarqube:
    name: SonarQube
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v6
        with:
            fetch-depth: 0
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2' # Not needed with a .ruby-version, .tool-versions or mise.toml
          bundler-cache: true
      - name: Build and test, collect coverage
        run: xcodebuild clean build test -project swift-coverage-example.xcodeproj -scheme swift-coverage-example -destination 'platform=macOS' -enableCodeCoverage YES
      - name: Convert xcresult coverage to SonarQube coverage format
        run:  bundle exec slather coverage --sonarqube-xml --scheme swift-coverage-example ./swift-coverage-example.xcodeproj
      - name: SonarQube Scan
        uses: SonarSource/sonarqube-scan-action@v7
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          args: >
            -X
            -Dsonar.sources=swift-coverage-example
            -Dsonar.tests=swift-coverage-exampleTests
            -Dsonar.inclusions=**/*.swift
            -Dsonar.exclusions=vendor/**
            -Dsonar.coverage.exclusions=**/GeneratedAssetSymbols.swift
            -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml
```

### Using xccov

The `xccov` command line tool is the recommended option to view Xcode coverage data and is more straightforward to use than the older `llvm-cov` tool.

With the script `xccov-to-sonarqube-generic.sh`, you can convert Xcode test results stored in `*.xcresult` folders to the [SonarQube generic test coverage format](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/test-coverage/generic-test-data). Note that this script is subject to changes and may not work in the future. I highly recommend you use [Slather](https://github.com/SlatherOrg/slather) instead, which is far more mature, maintained, and documented.

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

### Other example Swift projects with coverage
Here is a list of sample Swift projects that have tests that allow you to compute coverage. I have added example commands that you can choose to modify:
* https://github.com/jasonjrr/MVVM.Demo.SwiftUI.git
  ```
  $ xcodebuild -project MVVM.Demo.SwiftUI.xcodeproj -scheme MVVM.Demo.SwiftUI -enableCodeCoverage YES -destination 'platform=iOS Simulator,name=iPhone 17 Pro' clean build test CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
  $ slather coverage --sonarqube-xml --scheme MVVM.Demo.SwiftUI ./MVVM.Demo.SwiftUI.xcodeproj
  $ sonar-scanner -Dsonar.host.url=http://localhost:9000 -Dsonar.token=<YOUR-SONAR-TOKEN> -Dsonar.projectKey=MVVM.Demo.SwiftUI -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml -Dsonar.exclusions=Build/**,sonarqube-generic-coverage.xml -Dsonar.sources=MVVM.Demo.SwiftUI -Dsonar.tests=MVVM.Demo.SwiftUITests,MVVM.Demo.SwiftUIUITests
  ```
* https://github.com/sonar-example-repos/Swift-Codecov-Demo
  ```
  $ xcodebuild clean build test -project CodecovDemo.xcodeproj -scheme CodecovDemo -destination 'platform=iOS Simulator,OS=26.1,name=iPhone 17' -enableCodeCoverage YES CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
  $ slather coverage --sonarqube-xml --scheme CodecovDemo ./CodecovDemo.xcodeproj
  $ sonar-scanner -Dsonar.host.url=http://localhost:9000 -Dsonar.token=<YOUR-SONAR-TOKEN> -Dsonar.projectKey=sonar-example-repos_Swift-Codecov-Demo -Dsonar.sources=CodecovDemo -Dsonar.tests=CodecovDemoTests,CodecovDemoUITests -Dsonar.inclusions=**/*.swift -Dsonar.exclusions=vendor/** -Dsonar.coverage.exclusions=**/GeneratedAssetSymbols.swift -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml
  ```
* https://github.com/exelban/stats
  ```
  $ xcodebuild -project Stats.xcodeproj -scheme Stats -enableCodeCoverage YES -destination 'platform=macOS' clean build test CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO
  $ slather coverage --sonarqube-xml --scheme Stats ./Stats.xcodeproj
  $ sonar-scanner -Dsonar.host.url=http://localhost:9000 -Dsonar.token=<YOUR-SONAR-TOKEN> -Dsonar.projectKey=stats -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml -Dsonar.exclusions=Build/**,sonarqube-generic-coverage.xml
  ```
