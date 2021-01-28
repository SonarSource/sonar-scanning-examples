# Sonarqube-Scanner BuildWrapper for Linux

This example demonstrates how to use the BuildWrapper to analyze a C++ project with the SonarQube Scanner on Linux

## Prerequisites

* G++ compiler to compile the project sample
* [SonarQube](http://www.sonarqube.org/downloads/) 7.9+
* [SonarQube Scanner](https://redirect.sonarsource.com/doc/install-configure-scanner.html) 4.5+
* [SonarCFamily for C/C++](https://www.sonarsource.com/why-us/products/codeanalyzers/sonarcfamilyforcpp.html)
* [SonarSource Build Wrapper](https://docs.sonarqube.org/pages/viewpage.action?pageId=7996665)

## Usage

* Run the build wrapper:

```shell
        build-wrapper --out-dir bw-outputs ./build.sh
```

* Analyze the project with SonarQube using the SonarQube Scanner:

```shell
        sonar-scanner
```
