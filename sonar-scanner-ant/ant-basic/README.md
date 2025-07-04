# SonarScanner CLI on a Java Ant project

This example demonstrates how to analyze a simple Apache Ant project with SonarScanner CLI. SonarScanner for Ant is deprecated on SonarCloud and as of SonarQube 9.9, therefore this is the current way of scanning an Ant project. Please see [Moving from SonarScanner for Ant to SonarScanner](https://docs.sonarsource.com/sonarqube/9.9/analyzing-source-code/scanners/sonarscanner-for-ant/#moving-from-sonarscanner-for-ant-to-sonarscanner) documentation for how to migrate to the SonarScanner.

## Prerequisites
* [SonarScanner CLI](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/scanners/sonarscanner/) 
* [Ant](http://ant.apache.org/) 1.10.0 or higher

## Usage
1. Compile the project:
   ```shell
   ant all
   ```
2. Run SonarScanner CLI.
