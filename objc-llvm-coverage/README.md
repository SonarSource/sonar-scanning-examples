This example demonstrates how to analyze an Objective-C project with the SonarQube Scanner.

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
                -derivedDataPath DerivedData \
                clean test

* Analyze the project with SonarQube using the SonarQube Scanner:

        sonar-scanner
