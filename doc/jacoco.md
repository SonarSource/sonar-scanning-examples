# Importing JaCoCo coverage report in XML format

Version 5.12 of our SonarJava analyzer deprecated use JaCoCo's binary format (`.exec` files) to import coverage. This binary format is internal to the JaCoCo project, and as such there are no guarantees for backward compatibility, so it should not be used for integration purposes. 

As a replacment, we developed the [sonar-jacoco](https://docs.sonarqube.org/display/PLUG/JaCoCo+Plugin) plugin, which imports JaCoCo's XML coverage report, and this is the preferred option now. In this guide, I will describe how to import this XML report in some common scenarios.

You can find sample projects using the setup described here in [this repository](https://github.com/SonarSource/sonar-scanning-examples).

## Maven

Remove any use of the `sonar.jacoco.itReportPath`, `sonar.jacoco.reportPath`, and `sonar.jacoco.reportMissing.force.zero` properties; they are deprecated and related functionality will be removed in the future.

We will use the [jacoco-maven-plugin](https://www.jacoco.org/jacoco/trunk/doc/maven.html) and its [report goal](https://www.eclemma.org/jacoco/trunk/doc/report-mojo.html) to create a code coverage report. Usually, you would want to create a specific profile which executes unit tests with the JaCoCo agent and creates a coverage report. This profile would then only be activated if coverage information is requested (e.g., in the CI pipeline).

In the most basic case we will need to execute two goals: `jacoco:prepare-agent` which creates the command line argument for JVM running the tests, and `jacoco:report` which uses data collected during unit test execution to generate a report in html, xml or csv format.

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

By default the generated report will be saved under `target/site/jacoco/jacoco.xml`; this location will be checked automatically by the sonar-jacoco plugin so no further configuration is required. Just launch `mvn sonar:sonar` as usual and the report will be picked up.

If you need to change the directory where the report has been generated you can set the property either on the command line using maven's  `-D` switch 

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

With multi-module builds, we sometimes need to show coverage across modules. For example, we might have multiple modules implementing business logic and another module which contains integration tests for all these modules. We would like to see also coverage from this integration test module on business logic modules.

To achieve this, we can use JaCoCo's [`report-aggregate`](https://www.jacoco.org/jacoco/trunk/doc/report-aggregate-mojo.html) goal, which will collect coverage information from all modules and create a single report with coverage for the whole project. 

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

We snippet binds the goal to the `verify` phase. Now when we execute

```
mvn clean verify
```

we should find the aggregated report in `target/site/jacoco-aggregate/jacoco.xml` of the module containing the integration tests.

However, the JaCoCo plugin imports coverage reports module by module, so we need to import the same report multiple times (once for every module) to have coverage for all modules. To achieve this we set the property `sonar.coverage.jacoco.xmlReportPaths` in every module 

```
<properties>
  <sonar.coverage.jacoco.xmlReportPaths>${project.basedir}/../path_to_module_with_report/target/site/jacoco-aggregate/jacoco.xml</sonar.coverage.jacoco.xmlReportPaths>
</properties>
```

### Troubleshooting

To investigate issues with the import of coverage information you can run Maven with the debug flag, `-X`:

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

Gradle includes the [JaCoCo plugin](https://docs.gradle.org/current/userguide/jacoco_plugin.html) in its default distribution. To apply the plugin to a project, you need to declare it in your `build.gradle` file together with the [SonarScanner for Gradle](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-gradle/).

```
plugins {
    id "jacoco"
    id "org.sonarqube" version "2.7.1"
}
```

The plugin provides the `jacocoTestReport` task, which needs to be configured to produce an XML report.

```
jacocoTestReport {
    reports {
        xml.enabled true
    }
}
```

By default report will be saved under the `build/reports/jacoco` directory and this location will be picked up automatically by the `sonarqube` plugin, so there is no further configuration required. To import coverage, launch

```
gradle build jacocoTestReport sonarqube
```

It is convenient to execute the `jacocoTestReport` task every time we execute `test` with the JaCoCo agent; to achieve this, we can run it after the `test` task. We can use [`finalizedBy` ](https://docs.gradle.org/current/userguide/more_about_tasks.html#sec:finalizer_tasks) to create a dependency between `test` and `jacocoTestReport`. 

```groovy
plugins.withType(JacocoPlugin) {
  tasks["test"].finalizedBy 'jacocoTestReport'
}
```
