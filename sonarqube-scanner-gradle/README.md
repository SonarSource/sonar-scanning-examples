This example demonstrates how to analyze a simple project built with gradle.

Prerequisites
=============
* [SonarQube](http://www.sonarqube.org/downloads/) 5.6+
* A gradle wrapper is included that bundles gradle. All other required plugins will be pulled by gradle as needed.

Usage
=====
* Run the following command (updating the sonar.host.url property as appropriate):
  * On Unix-like systems:
    `./gradlew -Dsonar.host.url=http://myhost:9000 sonarqube`
  * On Windows:
    `.\gradle.bat -Dsonar.host.url=http://myhost:9000 sonarqube`
