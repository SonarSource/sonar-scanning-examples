This example demonstrates how to import Xcode Coverage data (aka ProfData) to SonarQube for a Swift project.

Prerequisites
=============
* [SonarQube](http://www.sonarqube.org/downloads/) 5.6+
* [SonarQube Scanner](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner) 2.8+
* [SonarSource Swift Plugin](http://redirect.sonarsource.com/plugins/swift.html) 2.0+

Usage
=====

1. Run from "swift-coverage-example"
  * xcodebuild -scheme swift-coverage-example -enableCodeCoverage YES -derivedDataPath . clean build test
  * xcrun llvm-cov show -instr-profile=Build/Intermediates/CodeCoverage/Coverage.profdata Build/Intermediates/CodeCoverage/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example > Coverage.report
  * sonar-scanner
2. Verify that for the project "swift-coverage-example" the coverage value is 50%.
