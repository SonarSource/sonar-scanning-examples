This example demonstrates how to analyze a simple project with Ant.

Prerequisites
=============
* [SonarQube](http://www.sonarqube.org/downloads/) 5.6+
* [SonarQube Scanner for Ant](http://redirect.sonarsource.com/doc/ant-task.html) 2.5+
* [Ant](http://ant.apache.org/) 1.7.1 or higher

Usage
=====
* Set the path to the SonarQube Ant Task in the build.xml file
* Set the URL of your SonarQube instance in the property 'sonar.host.url'
* Run the following command:

        ant all
