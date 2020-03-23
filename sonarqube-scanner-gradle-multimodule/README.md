This example demonstrates how to analyze a multi-module Java project with Gradle.

Prerequisites
=============
* [SonarQube](http://www.sonarsource.org/downloads/) 4.5+
* [Gradle](http://www.gradle.org/) 1.12 or higher

Usage
=====
* Analyze the project with SonarQube using Gradle:

        gradle sonarqube [-Dsonar.host.url=... -Dsonar.jdbc.url=... -Dsonar.jdbc.username=... -Dsonar.jdbc.password=...]
