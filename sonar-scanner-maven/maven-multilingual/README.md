# Multilingual Maven Example

This simple Maven project is importing JaCoCo's coverage report for Java and Kotlin sources in one module. For multi-module project example 
see [multi-module Maven project](../maven-multimodule/README.md)
        
## Usage

* Build the project, execute all the tests and analyze the project with SonarQube Scanner for Maven(from root  of the project):

        mvn clean verify sonar:sonar
        
## Documentation

[SonarScanner for Maven](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-maven/)
