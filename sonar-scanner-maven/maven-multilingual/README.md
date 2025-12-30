# Multilingual Maven Example

This simple Maven project is importing JaCoCo's coverage report for Java and Kotlin sources in one module. For multi-module project example 
see [multi-module Maven project](../maven-multimodule/README.md)
        
## Usage

* Build the project, execute all the tests and analyze the project with SonarQube Scanner for Maven(from root  of the project):

        mvn clean verify sonar:sonar
        
## Documentation

[SonarScanner for Maven](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-maven/)
# Basic Maven Example

This simple Maven project demonstrates how to generate and import both code coverage and unit test results into SonarQube using the JaCoCo and Maven Surefire plugins.

For a multi-module project example,  see [multi-module Maven project](../maven-multimodule/README.md)

## What It Does

This project includes:

-**JaCoCo** for code coverage reporting
-**maven-surefire-report-plugin** (version 3.5.3) to generate unit test result reports in XML format
-Configuration to import both coverage and test results into SonarQube

By configuring `maven-surefire-report-plugin` in the `<pluginManagement>` section, unit test results are automatically generate in `target/surefire-reports` during the Maven `verify` phase.

## Generated Files

After running the build, the following directory is created: `target/surefire-reports`

This contains `.xml` files for each test class, such as:

- `TEST-com.example.MyClassTest.xml`

These files are used by SonarQube to analyze unit test execution (number of tests, success rate, duration, failures, etc.).

## How It Shows in SonarQube

Once the project is analyzed, SonarQube will show:

- Number of unit tests executed
- Test pass/fail rate
- Code coverage (if JaCoCo is enabled)
- Test execution time
- Detailed test trends and metrics under the **Tests** tab of the project

## Usage
* Build the project, execute all the tests and analyze the project with SonarScanner for Maven (from the root of the project):
    ```shell
    mvn clean verify sonar:sonar
    ```

* You can confirm that the sonar.junit.reportPaths parameter was picked up by checking the debug output:
    ```
    [DEBUG] sonar.junit.reportPaths: target/surefire-reports
    ```


## Documentation
[SonarScanner for Maven](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-maven/)
[Test Coverage Parameters](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/test-coverage/test-coverage-parameters/)
[Importing Unit Test Results](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/test-coverage/test-execution-parameters)

## Notes
If you omit the -Dsonar.junit.reportPaths=... flag, test execution results will not be imported unless configured elsewhere.
The path is relative to the module being analyzed.