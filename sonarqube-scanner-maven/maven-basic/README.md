# Basic Maven Example

This simple Maven project is importing JaCoCo's coverage report. For multi-module project example 
see [multi-module Maven project](../maven-multimodule/README.md)

## Usage

* Build the project, execute all the tests and analyze the project with SonarQube Scanner for Maven(from root  of the project):

```shell
        mvn clean verify sonar:sonar
```

## Documentation

[SonarScanner for Maven](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-maven/)
