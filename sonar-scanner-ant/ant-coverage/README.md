# SonarScanner CLI on a Java Ant project with JaCoCo Coverage

This example demonstrates how to analyze a simple project with Apache Ant and JaCoCo coverage. Code example is derived from [JaCoCo's own repository of examples](https://github.com/jacoco/jacoco/tree/v0.8.7/org.jacoco.examples/build). SonarScanner for Ant is deprecated on SonarCloud and as of SonarQube 9.9, therefore this is the current way of scanning an Ant project. Please see [Moving from SonarScanner for Ant to SonarScanner](https://docs.sonarsource.com/sonarqube/9.9/analyzing-source-code/scanners/sonarscanner-for-ant/#moving-from-sonarscanner-for-ant-to-sonarscanner) documentation for how to migrate to the SonarScanner.

The JaCoCo coverage report is imported via the following Sonar scanner analysis parameter `sonar.coverage.jacoco.xmlReportPaths` (see [Test Coverage & Execution Overview](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/test-coverage/overview/)):

```xml
<property name="sonar.coverage.jacoco.xmlReportPaths" value="${result.report.dir}/report.xml" />
```

For more details on JaCoCo integration with Ant, see [JaCoCo Ant Tasks](https://www.eclemma.org/jacoco/trunk/doc/ant.html).

## Prerequisites
* [SonarScanner CLI](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/scanners/sonarscanner/) 
* [Ant](http://ant.apache.org/) 1.10.0 or higher
* [JaCoCo](https://www.eclemma.org/jacoco/) 0.8.7 or higher
  * You can find Jacoco artifacts by version [here](https://repo1.maven.org/maven2/org/jacoco/jacoco/). Once unzipped, look for lib/jacocoant.jar

## Usage
1. Set the path to the JaCoCo Ant Task (jar) in the build.xml file.
2. Set the path to the JaCoCo XML report, if necessary. The default is set to `${result.report.dir}/report.xml` in the build.xml file.
3. Compile the project:
   ```shell
   ant rebuild
   ```
4. Run SonarScanner CLI.
