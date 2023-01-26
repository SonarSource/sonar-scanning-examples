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

Create code coverage report

```shell
bash xccov-to-sonarqube-generic.sh Build/Logs/Test/*.xcresult/ >Coverage.xml
```

Import code coverage report

```shell
sonar-scanner -Dsonar.projectKey=TestCoverage -Dsonar.sources=. -Dsonar.coverageReportPaths=Coverage.xml
```

1.b Using llvm-cov 

Create code coverage report

```shell
xcrun --run llvm-cov show -instr-profile=Build/Build/ProfileData/<id>/Coverage.profdata \
      Build/Build/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example \
      -object ./Build/Build/Products/Debug/swift-coverage-example.app/Contents/PlugIns/swift-coverage-exampleTests.xctest/Contents/MacOS/swift-coverage-exampleTests \
      >Coverage.report
```

Import code coverage report

```shell
sonar-scanner -Dsonar.projectKey=TestCoverage -Dsonar.sources=. -Dsonar.swift.coverage.reportPaths=Coverage.report
```

2. Verify that for the project "swift-coverage-example" the coverage value is > 65%.
