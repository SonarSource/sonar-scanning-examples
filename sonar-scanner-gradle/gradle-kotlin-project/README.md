# SonarScanner for Gradle on a Kotlin project

This example demonstrates how to analyze a Kotlin project built with [Gradle](https://gradle.org/). See [SonarScanner for Gradle](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-gradle/) for more information.

## Prerequisites
* A running instance of SonarQube Server or a connection to SonarCloud (in that case you would need to pass `-Dsonar.organization=<your-organization>`).
* A gradle wrapper is included that bundles gradle. All other required plugins will be pulled by gradle as needed.

## Usage

Run the following command (updating the sonar.host.url property as appropriate):

* On Unix-like systems:
  ```text
  ./gradlew build -Dsonar.host.url=<your-url> -Dsonar.login=<your-token> sonar
  ```
* On Windows:
  ```text
  .\gradlew.bat build -D'sonar.host.url=<your-url>' -Dsonar.login=<your-token> sonar
  ```

## Coverage

To get the project [test coverage](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/test-coverage/java-test-coverage/) computed, add gradle task `jacocoTestReport` to your command line.

* On Unix-like systems:
  ```text
  ./gradlew build jacocoTestReport -Dsonar.host.url=<your-url> -Dsonar.login=<your-token> sonar
  ```
* On Windows:
  ```text
  .\gradlew.bat build jacocoTestReport -D'sonar.host.url=<your-url>' -Dsonar.login=<your-token> sonar
  ```
