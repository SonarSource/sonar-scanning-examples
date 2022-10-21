# Sonarqube-Scanner Ant

This example demonstrates how to analyze a simple project with Apache Ant.

## Prerequisites

* [SonarQube](http://www.sonarqube.org/downloads/) 8.9 LTS or Latest
* [SonarQube Scanner for Ant](http://redirect.sonarsource.com/doc/ant-task.html) 2.7.1+
* [Ant](http://ant.apache.org/) 1.10.0 or higher

## Usage

* Set the path to the SonarQube Ant Task in the build.xml file
* Set the URL of your SonarQube instance in the property 'sonar.host.url'
* Run the following command:

```shell
        ant all
```
