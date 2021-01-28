# Objective-C LLVM Coverage

This example demonstrates how to analyze an Objective-C project with the SonarQube Scanner.

## Prerequisites

* [SonarQube](http://www.sonarqube.org/downloads/) 7.9+
* [SonarQube Scanner](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner) 4.5+
* [SonarSource Objective-C Plugin](http://redirect.sonarsource.com/plugins/objectivec.html) 6.5+

## Usage

* Build the project with SonarSource Build Wrapper:

```shell
        mkdir DerivedData

        build-wrapper-macosx-x86 --out-dir DerivedData/compilation-database \
        xcodebuild \
                -scheme Example \
                -derivedDataPath DerivedData \
                clean test
```

* Analyze the project with SonarQube using the SonarQube Scanner:

```shell
        sonar-scanner
```
