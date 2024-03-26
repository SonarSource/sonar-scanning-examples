# SonarScanner for Multi-Module Java Gradle Project

This example demonstrates how to analyze a multi-module Java project with Gradle.

## Prerequisites

* [SonarQube](http://www.sonarqube.org/downloads/) 9.9 LTS or Latest
* A gradle wrapper is included that bundles gradle. All other required plugins will be pulled by gradle as needed.

## Usage

Run the following command (updating the sonar.host.url property as appropriate):

* On Unix-like systems:

```shell
  ./gradlew build -Dsonar.host.url=http://myhost:9000 sonar
```

* On Windows:

```powershell
  .\gradle.bat build -Dsonar.host.url=http://myhost:9000 sonar
```
