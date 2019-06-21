This example demonstrates how to use the BuildWrapper to analyze a C++ project with the SonarQube Scanner on Linux

Prerequisites
=============
* G++ compiler to compile the project sample
* [SonarQube](http://www.sonarqube.org/downloads/) 5.6+
* [SonarQube Scanner](https://redirect.sonarsource.com/doc/install-configure-scanner.html) 2.8+
* [SonarCFamily for C/C++](https://www.sonarsource.com/why-us/products/codeanalyzers/sonarcfamilyforcpp.html)
* [SonarSource Build Wrapper](https://docs.sonarqube.org/pages/viewpage.action?pageId=7996665)

Usage
=====
* Run the build wrapper:

        build-wrapper --out-dir bw-outputs ./build.sh

* Analyze the project with SonarQube using the SonarQube Scanner:

        sonar-scanner
