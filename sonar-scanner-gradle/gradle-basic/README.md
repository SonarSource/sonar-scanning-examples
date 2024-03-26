# SonarScanner for Gradle

This example demonstrates how to analyze a simple project built with [Gradle](https://gradle.org/). See [SonarScanner for Gradle](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-gradle/) for more information.

## Prerequisites
* A gradle wrapper is included that bundles gradle. All other required plugins will be pulled by gradle as needed.

## Usage

Run the following command (updating the sonar.host.url property as appropriate):

* On Unix-like systems:
  ```text
  ./gradlew build -Dsonar.host.url=http://myhost:9000 sonar
  ```
* On Windows:
  ```text
  .\gradlew.bat build -D'sonar.host.url=http://myhost:9000' sonar
  ```

## Coverage

To get the project [test coverage](https://community.sonarsource.com/t/coverage-test-data-importing-jacoco-coverage-report-in-xml-format) computed, add gradle task `jacocoTestReport` to your command line.

* On Unix-like systems:
  ```text
  ./gradlew build jacocoTestReport -Dsonar.host.url=http://myhost:9000 sonar
  ```
* On Windows:
  ```text
  .\gradlew.bat build jacocoTestReport -D'sonar.host.url=http://myhost:9000' sonar
  ```
