This example demonstrates how to analyze an Objective-C project with the SonarQube Scanner and how to generate and import llvm-cov coverage report.

Prerequisites
=============
* [SonarQube](http://www.sonarqube.org/downloads/) 5.6+
* [SonarQube Scanner](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner) 2.8+
* [SonarSource Objective-C Plugin](http://redirect.sonarsource.com/plugins/objectivec.html) 4.3+

Usage
=====
* Build the project with SonarSource Build Wrapper:

        mkdir DerivedData

        build-wrapper-macosx-x86 --out-dir DerivedData/compilation-database \
        xcodebuild \
                -scheme Example \
                -enableCodeCoverage YES \
                -derivedDataPath DerivedData \
                clean test

* Generate coverage report:

        xcrun llvm-cov show \
                -instr-profile=$(find DerivedData -iname 'Coverage.profdata') \
                $(find DerivedData -iname 'libExample.dylib') \
                > DerivedData/coverage.txt

* Analyze the project with SonarQube using the SonarQube Scanner:

        sonar-scanner
