# SonarScanner for Ant is deprecated on SonarCloud and as of SonarQube 9.9. Please see [Moving from SonarScanner for Ant to SonarScanner](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-ant/#moving-from-sonarscanner-for-ant-to-sonarscanner) documentation for how to migrate to the SonarScanner.

# SonarScanner for Ant

This example demonstrates how to analyze a simple Apache Ant project with SonarScanner for Ant.

## Prerequisites
* [SonarScanner for Ant](http://redirect.sonarsource.com/doc/ant-task.html) 2.7.1 or higher
* [Ant](http://ant.apache.org/) 1.10.0 or higher

## Usage
1. Set the path to the SonarQube Ant Task in the build.xml file
2. Set the URL of your SonarQube instance in the property 'sonar.host.url'
3. Run the following command:
    ```shell
    ant all
    ```
