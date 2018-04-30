This example demonstrates how to import Xcode Coverage data (aka ProfData) to SonarQube for a Swift project.

Prerequisites
=============
* [SonarQube](http://www.sonarqube.org/downloads/) 6.7+
* [SonarQube Scanner](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner) 3.1+
* [SonarSource Swift Plugin](http://redirect.sonarsource.com/plugins/swift.html) 3.2+

Usage
=====

1. Run from "swift-coverage-example"
  * xcodebuild -scheme swift-coverage-example -enableCodeCoverage YES -derivedDataPath . clean build test
  * With XCode 7.x and older: xcrun llvm-cov show -instr-profile=Build/Intermediates/CodeCoverage/Coverage.profdata Build/Intermediates/CodeCoverage/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example > Coverage.report
  * With XCode 8+, 9+: xcrun llvm-cov show -instr-profile=Build/ProfileData/<device_id>/Coverage.profdata Build/Products/Debug/swift-coverage-example.app/Contents/MacOS/swift-coverage-example > Coverage.report
 
  The <device_id> can be found from the XCode tools command: instruments -s devices
  
  * sonar-scanner
2. Verify that for the project "swift-coverage-example" the coverage value is 60%.
