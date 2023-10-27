# Sonarqube-Scanner Ant with JaCoCo Coverage

This example demonstrates how to analyze a simple project with Apache Ant and JaCoCo coverage. Code example is derived from [JaCoCo's own repository of examples](https://github.com/jacoco/jacoco/tree/v0.8.7/org.jacoco.examples/build).

The JaCoCo coverage report is imported via the following Sonar scanner analysis parameter `sonar.coverage.jacoco.xmlReportPaths` (see [Test Coverage & Execution](https://docs.sonarqube.org/latest/analysis/coverage/)):

```xml
<property name="sonar.coverage.jacoco.xmlReportPaths" value="${result.report.dir}/report.xml" />
```

For more details on JaCoCo integration with Ant, see [JaCoCo Ant Tasks](https://www.eclemma.org/jacoco/trunk/doc/ant.html).

## Prerequisites

* [SonarQube](http://www.sonarqube.org/downloads/) 7.9 or higher
* [SonarQube Scanner for Ant](http://redirect.sonarsource.com/doc/ant-task.html) 2.7 or higher
* [Ant](http://ant.apache.org/) 1.10.0 or higher
* [JaCoCo](https://www.eclemma.org/jacoco/) 0.8.7 or higher
  * You can find Jacoco artifacts by version [here](https://repo1.maven.org/maven2/org/jacoco/jacoco/). Once unzipped, look for lib/jacocoant.jar

## Usage

* Set the path to the SonarQube Ant Task (jar) in the build.xml file.
* Set the path to the JaCoCo Ant Task (jar) in the build.xml file.
* Set the path to the JaCoCo XML report, if necessary. The default is set to `${result.report.dir}/report.xml` in the build.xml file.
* Set the URL of your SonarQube instance in the property 'sonar.host.url'
* Run the following command:

```shell
ant rebuild -Dsonar.login=<INSERT-LOGIN-TOKEN>
```
