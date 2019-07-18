# Importing JaCoCo coverage report in XML format

Version 5.12 of our SonarJava analyzer deprecated usage of the binary format of JaCoCo (`.exec` files) to import coverage. This binary format is internal to the JaCoCo project, and as such there are no guarantees for backward compatibility, and should not be used for integration purposes. 

We developed new [sonar-jacoco](https://docs.sonarqube.org/display/PLUG/JaCoCo+Plugin) plugin, which imports JaCoCo's XML coverage report, and this is the preferred option now. In this guide, I will describe how to import XML report in some common scenarios.

You can find sample projects using the setup described here in [this repository](https://github.com/SonarSource/sonar-scanning-examples).

## Maven

Remove any usage of `sonar.jacoco.itReportPath`, `sonar.jacoco.reportPath`, or `sonar.jacoco.reportMissing.force.zero` properties, they are deprecated and related functionality will be removed in the future.

We will use [jacoco-maven-plugin](https://www.jacoco.org/jacoco/trunk/doc/maven.html) and its [report goal](https://www.eclemma.org/jacoco/trunk/doc/report-mojo.html) to create a code coverage report. Usually, you would want to create a specific profile which executes unit tests with JaCoCo agent and creates a coverage report. This profile would then only be activated if coverage information is requested (e.g., in the CI pipeline).

In the most basic case we will need to execute two goals - `jacoco:prepare-agent`, which creates the command line argument to be used for JVM during unit tests execution and `jacoco:report` which uses data collected during unit test execution to generate report in html, xml or csv format.

Here is an example of such a profile

```xml
<profile>
  <id>coverage</id>
  <build>
   <plugins>
    <plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.4</version>
    <executions>
      <execution>
        <id>prepare-agent</id>
        <goals>
         <goal>prepare-agent</goal>
        </goals>
      </execution>
      <execution>
        <id>report</id>
        <goals>
         <goal>report</goal>
        </goals>
      </execution>
    </executions>
    </plugin>
   </plugins>
  </build>
</profile>
```

By default the generated report will be saved under `target/site/jacoco/jacoco.xml`, this location will be checked automatically by sonar-jacoco plugin, so there is no further configuration required, just launch `mvn sonar:sonar` as usual and report will be picked up.

In case you need to change the directory where the report is generated you can set the property either on the command line using maven's  `-D` switch 

```
mvn -Dsonar.coverage.jacoco.xmlReportPaths=report1.xml,report2.xml sonar:sonar 
```

or you can set the property inside your `pom.xml` 

```xml
    <properties>
        <sonar.coverage.jacoco.xmlReportPaths>../app-it/target/site/jacoco-aggregate/jacoco.xml</sonar.coverage.jacoco.xmlReportPaths>
    </properties>

```

### Multi-module builds

With multi-module builds, we sometimes need to show coverage across the modules. For example, we might have multiple modules implementing business logic and another module which contains integration tests for all this module. We would like to see also coverage from this integration test module on business logic modules.

To achieve this, we can use [`report-aggregate`](https://www.jacoco.org/jacoco/trunk/doc/report-aggregate-mojo.html) goal of JaCoCo, which will collect coverage information from all modules and create a single report with coverage for the whole project. 

First, we still have to use `prepare-agent` goal as we did in basic example in all modules, the best way to achieve this is to configure the execution of this goal in the parent `pom.xml`. Then we need to add execution to the module containing integration tests to generate the report across modules

```
<build>
  <plugins>
    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
      <executions>
        <execution>
          <id>report</id>
          <goals>
            <goal>report-aggregate</goal>
          </goals>
          <phase>verify</phase>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

We will bind this goal to the `verify` phase. Now when we execute

```
mvn clean verify
```

we should find the aggregated report in `target/site/jacoco-aggregate/jacoco.xml` of the module containing the integration tests.

JaCoCo plugin, however, imports coverage report module by module, so we need to import the same report multiple times for every module to have coverage for all modules. To achieve this we set property `sonar.coverage.jacoco.xmlReportPaths` in every module 

```
<properties>
  <sonar.coverage.jacoco.xmlReportPaths>${project.basedir}/../integration_tests/target/site/jacoco-aggregate/jacoco.xml</sonar.coverage.jacoco.xmlReportPaths>
</properties>
```

We can factor out the path to the report in the property of parent `pom.xml` to avoid repetition.

### Troubleshooting

To investigate issues with import of coverage information you can start Maven with debug flag `-X`

```
mvn -X clean verify sonar:sonar 
```

In the logs, you will find the execution of different sensors for each module of the project. Typically you will have a log similar to the following one when XML report is processed.

```
[INFO] 16:58:05.074 Sensor JaCoCo XML Report Importer [jacoco]
[DEBUG] 16:58:05.082 Reading report 'C:\projects\sonar-scanning-examples\maven-multimodule\tests\target\site\jacoco-aggregate\jacoco.xml'
[INFO] 16:58:05.093 Sensor JaCoCo XML Report Importer [jacoco] (done) | time=19ms
```



## Gradle

Gradle includes [JaCoCo plugin](https://docs.gradle.org/current/userguide/jacoco_plugin.html) in default distribution. To apply the plugin to a project, you need to declare it in your `build.gradle` file together with [SonarScanner for Gradle](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-gradle/).

```
plugins {
    id "jacoco"
    id "org.sonarqube" version "2.7.1"
}
```

The plugin provides `jacocoTestReport` task, which needs to be configured to produce XML report.

```
jacocoTestReport {
    reports {
        xml.enabled true
        csv.enabled false
        html.enabled false
    }
}
```

By default report will be saved under `build/reports/jacoco` directory and this location will be picked up automatically by `sonarqube` plugin, so there is no further configuration required. To import coverage launch

```
gradle build jacocoTestReport sonarqube
```

It is convenient to execute `jacocoTestReport` task every time we execute `test` with JaCoCo agent, to achieve this, we can run it after the `test` task. We can use [`finalizedBy` ](https://docs.gradle.org/current/userguide/more_about_tasks.html#sec:finalizer_tasks) to create dependency between `test` and `jacocoTestReport`. 

```groovy
plugins.withType(JacocoPlugin) {
  tasks["test"].finalizedBy 'jacocoTestReport'
}
```
