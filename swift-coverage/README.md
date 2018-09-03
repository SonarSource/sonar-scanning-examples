This example demonstrates how to import Xcode Coverage data (aka ProfData) to SonarQube for a Swift project.

Prerequisites
=============
* [SonarQube](http://www.sonarqube.org/downloads/) 6.7+
* [SonarQube Scanner](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner) 3.1+
* [SonarSource Swift Plugin](http://redirect.sonarsource.com/plugins/swift.html) 3.2+

Usage
=====

1. Run from "swift-coverage-example"

**Note** : The <device_id> used in the below command can be found from the XCode tools command: instruments -s devices

XCode version | Command
--- | ---
All versions | xcodebuild -scheme swift-coverage-example -enableCodeCoverage YES -derivedDataPath . clean build test
XCode 7.x (or older) | xcrun llvm-cov show -instr-profile=Build/Intermediates/CodeCoverage/Coverage.profdata Build/Intermediates/CodeCoverage/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example > Coverage.report
XCode 8+ - 9.2 | xcrun llvm-cov show -instr-profile=Build/ProfileData/<device_id>/Coverage.profdata Build/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example > Coverage.report
XCode 9.3+ | bash xccov-to-sonarqube-generic.sh Build/Logs/Test/*.xccovarchive/ > sonarqube-generic-coverage.xml
XCode 7.x - 9.2 | sonar-scanner -Dsonar.projectKey=TestCoverage -Dsonar.sources=. -Dsonar.swift.coverage.reportPath=Coverage.report -Dsonar.cfamily.build-wrapper-output.bypass=true
XCode 9.3+ | sonar-scanner -Dsonar.projectKey=TestCoverage -Dsonar.sources=. -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml -Dsonar.cfamily.build-wrapper-output.bypass=true
  
2. Verify that for the project "swift-coverage-example" the coverage value is 69.2%.
