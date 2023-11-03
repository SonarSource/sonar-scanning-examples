# SonarScanner for Ant is deprecated on SonarCloud and as of SonarQube 9.9. Please see [Moving from SonarScanner for Ant to SonarScanner](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-ant/#moving-from-sonarscanner-for-ant-to-sonarscanner) documentation for how to migrate to the SonarScanner.

# SonarScanner Ant with JaCoCo Coverage

This example demonstrates how to analyze a simple project with Apache Ant and JaCoCo coverage. Code example is derived from [JaCoCo's own repository of examples](https://github.com/jacoco/jacoco/tree/v0.8.7/org.jacoco.examples/build).

The JaCoCo coverage report is imported via the following Sonar scanner analysis parameter `sonar.coverage.jacoco.xmlReportPaths` (see [Test Coverage & Execution Overview](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/test-coverage/overview/)):

```xml
<property name="sonar.coverage.jacoco.xmlReportPaths" value="${result.report.dir}/report.xml" />
```

For more details on JaCoCo integration with Ant, see [JaCoCo Ant Tasks](https://www.eclemma.org/jacoco/trunk/doc/ant.html).

## Prerequisites
* [SonarScanner for Ant](http://redirect.sonarsource.com/doc/ant-task.html) 2.7.1 or higher
* [Ant](http://ant.apache.org/) 1.10.0 or higher
* [JaCoCo](https://www.eclemma.org/jacoco/) 0.8.7 or higher
  * You can find Jacoco artifacts by version [here](https://repo1.maven.org/maven2/org/jacoco/jacoco/). Once unzipped, look for lib/jacocoant.jar

## Usage
1. Set the path to the SonarQube Ant Task (jar) in the build.xml file.
2. Set the path to the JaCoCo Ant Task (jar) in the build.xml file.
3. Set the path to the JaCoCo XML report, if necessary. The default is set to `${result.report.dir}/report.xml` in the build.xml file.
4. Set the URL of your SonarQube instance in the property 'sonar.host.url'
5. Run the following command:
    ```shell
    ant rebuild -Dsonar.login=<INSERT-LOGIN-TOKEN>
    ```
