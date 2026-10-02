# Multi-module Maven Example

This project imports both:

- JaCoCo's aggregate XML report to enable code coverage reporting across modules
- Maven Surefire XML test reports to include unit test results for each module

For a basic example, see [basic Maven project](../maven-basic/README.md).

## Usage

Build the project, execute all the tests, and analyze it with SonarScanner for Maven:

```shell
mvn clean verify org.sonarsource.scanner.maven:sonar-maven-plugin:5.6.0.6792:sonar \
  -Dsonar.junit.reportPaths=target/surefire-reports
```

## Description

This project consists of 3 modules:

* [`module1`](module1/pom.xml) and [`module2`](module2/pom.xml) contain "business logic" and related unit tests.

* [`tests`](tests/pom.xml) is a test-only module (integration tests in `src/test/java`, no `src/main/java`). It also creates the aggregate coverage report imported into SonarQube.

## Test-only modules and `sonar.java.binaries`

SonarScanner for Maven sets `sonar.java.binaries` from `target/classes` for modules that compile main sources. You do not set it on `module1` or `module2`, or in the [basic Maven example](../maven-basic).

A test-only module produces no `target/classes`. Recent scanner-engine versions then warn (`sonar.java.binaries not set`) and point at an empty placeholder so analysis can proceed. Test sources are still analyzed; the warning is cosmetic.

This example sets the property on `tests` only, so running the sample does not look broken:

```xml
<properties>
  <sonar.java.binaries>${project.build.testOutputDirectory}</sonar.java.binaries>
</properties>
```

`mvn clean verify ... sonar` still has to run first so `target/test-classes` exists. See [Java analysis parameters](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/languages/java/).

## Code Coverage with JaCoCo
To collect code coverage across all modules:
### 1. JaCoCo Agent Setup
In the top-level pom.xml, the JaCoCo plugin is configured under <pluginManagement> so it applies to all submodules. It is wrapped in the coverage profile to make it activatable (e.g. in CI):

```
<build>
  <pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.jacoco</groupId>
        <artifactId>jacoco-maven-plugin</artifactId>
        <executions>
          <execution>
            <goals>
              <goal>prepare-agent</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </pluginManagement>
</build>
```

### 2. Generate Aggregate Coverage Report
In the `tests` module, the `report-aggregate` goal is configured to run in the `verify` phase to generate a coverage report combining all modules:

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

This creates the report at:
```
tests/target/site/jacoco-aggregate/jacoco.xml
```

To import it into SonarQube, set the path in the top-level `pom.xml`:

```
<properties>
  <sonar.coverage.jacoco.aggregateXmlReportPaths>${maven.multiModuleProjectDirectory}/tests/target/site/jacoco-aggregate/jacoco.xml</sonar.coverage.jacoco.aggregateXmlReportPaths>
</properties>
```

Or pass it directly via the command line:

```
-Dsonar.coverage.jacoco.aggregateXmlReportPaths=absolute/path/to/jacoco.xml
```

## Unit Test Result Reporting
To include unit test results (e.g. passed/failed/skipped test count, execution time) in SonarQube:

### Surefire Plugin Configuration

The maven-surefire-report-plugin (version 3.5.3) is included in the root pom.xml under <pluginManagement>, ensuring all modules inherit it:

```
<pluginManagement>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-report-plugin</artifactId>
      <version>3.5.3</version>
    </plugin>
  </plugins>
</pluginManagement>
```

During the `verify` phase, this generates XML reports in each module's `target/surefire-reports/` directory:

```
module1/target/surefire-reports/TEST-com.example.FooTest.xml
module2/target/surefire-reports/TEST-com.example.BarTest.xml
```

To import these into SonarQube, set:

```
-Dsonar.junit.reportPaths=target/surefire-reports
```

## SonarQube Results
After analysis, SonarQube will display:

- Code coverage metrics from jacoco.xml
- Test execution stats from Surefire XML files:
  - Total tests
  - Passed/failed/skipped
  - Execution duration
- Trends and drill-down under the "Tests" and "Coverage" tabs

## Documentation

[SonarScanner for Maven](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-maven/)
