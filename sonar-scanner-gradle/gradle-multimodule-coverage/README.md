# SonarScanner for Gradle Multi-Module Project with Code Coverage

This example project demonstrates how to analyze a multi-module project with Jacoco code coverage built with Gradle.

## Prerequisites
* A Gradle wrapper is included that bundles Gradle. All other required plugins will be pulled by Gradle as needed.

## Usage
Run the following command (update `sonar.host.url`, `sonar.login`, `sonar.password`, etc. analysis parameters as needed either at command line or in `sonar.gradle`):
* On Unix-like systems:
  ```shell
  ./gradlew clean build codeCoverageReport -Dsonar.host.url=http://localhost:9000 -Dsonar.login=admin -Dsonar.password=admin sonar
  ```
* On Windows:
  ```shell
  .\gradlew.bat clean build codeCoverageReport -Dsonar.host.url=http://localhost:9000 -Dsonar.login=admin -Dsonar.password=admin sonar
  ```

## Coverage
This example project is based on the original example project from Gradle's [sample project](https://docs.gradle.org/6.4-rc-1/samples/sample_jvm_multi_project_with_code_coverage.html) for reporting code coverage for Jacoco (Gradle 6.4-rc-1 and Gradle 6.6.1) as well as Andranik Azizbekian's [article](https://developer.disqo.com/blog/setup-android-project/)  integrating SonarQube with a Kotlin Android project.

Here are the important changes compared to the original Gradle sample project linked above in order for SonarQube to pick up the code coverage metric:
* ensure `settings.gradle` references your modules
* add reference to the SonarScanner for Gradle to the root `build.gradle`:
  ```groovy
  plugins {
    id "org.sonarqube" version "5.0.0.4638"
  }
  ```
* add the following to `subprojects{}` block of root `build.gradle`:
  ```groovy
  apply plugin: "org.sonarqube"
  sonar {
      properties {
          property "sonar.coverage.jacoco.xmlReportPaths", "$projectDir.parentFile.path/build/reports/jacoco/codeCoverageReport/codeCoverageReport.xml"
      }
  }
  ```
* add a new file to root of project called `sonar.gradle` with the following contents:
  ```groovy
  apply plugin: "org.sonarqube"
  sonar {
      properties {
        property 'sonar.projectName', 'gradle-multimodule'
        property "sonar.projectKey", "gradle-multimodule"
        // Add other analysis parameters here if you don't
        // want to add it to the Sonar scanner command line:
        // property "sonar.host.url", "yoursonarqubeurl"
        // property "sonar.login", "yourlogintoken"
        // etc.
    }
  }
  ```
* add `apply from: "$project.rootDir/sonar.gradle"` to root `build.gradle`


For other forms of Gradle and Maven code coverage, see [test coverage](https://community.sonarsource.com/t/coverage-test-data-importing-jacoco-coverage-report-in-xml-format) in the SonarSource community forum.

## Things to Note
* You may notice this warning about bytecode dependencies:
  ```text
  Bytecode of dependencies was not provided for analysis of source files, you might end up with less precise results. Bytecode can be provided using sonar.java.libraries property.
  ```
  This is primarily due to the lack of dependencies (e.g. empty `dependencies {}` block) in this example project. Your actual project may include dependencies that can may include vulnerabilities, which will require setting `sonar.java.binaries` and `sonar.java.libraries` parameters to scan for them. To avoid this warning and thus avoid needing to configure `sonar.java.binaries` and `sonar.java.libraries` manually, ensure that you are using SonarScanner for Gradle instead of SonarScanner. By using SonarScanner for Gradle, the setting of `sonar.java.binaries` and `sonar.java.libraries` is done automatically for you. See also [Java](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/languages/java/) for more details.
