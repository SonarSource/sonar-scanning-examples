# Basic Maven Example

This simple Maven project is importing JaCoCo's coverage report. For multi-module project example 
see [multi-module Maven project](../maven-multimodule/README.md)

## Usage

* Build the project, execute all the tests and analyze the project with SonarScanner for Maven (from the root of the project):
    ```shell
    mvn clean verify sonar:sonar
    ```
## Documentation
[SonarScanner for Maven](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-maven/)
