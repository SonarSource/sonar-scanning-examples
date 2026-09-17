# SonarScanner for Gradle Multi-Module Project with Code Coverage

This example project demonstrates how to analyze a multi-module project with Jacoco code coverage built with Gradle, where the modules depend on each other and coverage has to be attributed across module boundaries. It uses the Groovy DSL. For a modern Kotlin DSL build structured with convention plugins in `buildSrc/`, where each module's tests only cover that module's own code, see [SonarScanner for Gradle - Multi-Module](../gradle-multimodule).

## Prerequisites
* A Gradle wrapper is included that bundles Gradle. All other required plugins will be pulled by Gradle as needed.
* A JDK 17 or later to run Gradle itself.

## Usage
Run the following command (update `sonar.host.url` and `sonar.token` analysis parameters as needed either at command line or in your `gradle.properties` file):
* On Unix-like systems:
  ```shell
  ./gradlew clean build -Dsonar.host.url=http://localhost:9000 -Dsonar.token=<token> sonar
  ```
* On Windows:
  ```shell
  .\gradlew.bat clean build -Dsonar.host.url=http://localhost:9000 -Dsonar.token=<token> sonar
  ```

The `sonar` task depends on the per-module coverage reports, so there is no separate report task to invoke.

## Coverage
This example project is based on the original example project from Gradle's [sample project](https://docs.gradle.org/6.4-rc-1/samples/sample_jvm_multi_project_with_code_coverage.html) for reporting code coverage for Jacoco (Gradle 6.4-rc-1 and Gradle 6.6.1) as well as Andranik Azizbekian's [article](https://developer.disqo.com/blog/setup-android-project/)  integrating SonarQube with a Kotlin Android project.

Here are the important changes compared to the original Gradle sample project linked above in order for SonarQube to pick up the code coverage metric:
* ensure `settings.gradle` references your modules
* add reference to the SonarScanner for Gradle to the root `build.gradle`:
  ```groovy
  plugins {
    id "org.sonarqube" version "latest.release"
  }
  ```
* give each module its own coverage report in the `subprojects {}` block of root `build.gradle`, built from every module's execution data but restricted to that module's own classes, and point the module's `sonar.coverage.jacoco.xmlReportPaths` at it:
  ```groovy
  apply plugin: 'org.sonarqube'

  pluginManager.withPlugin('jacoco') {
      sonar {
          properties {
              property 'sonar.coverage.jacoco.xmlReportPaths',
                  layout.buildDirectory.file('reports/jacoco/sonarCoverageReport/sonarCoverageReport.xml').get().asFile.absolutePath
          }
      }

      tasks.register('sonarCoverageReport', JacocoReport) {
          dependsOn rootProject.allprojects.collect { it.tasks.withType(Test) }
          executionData.setFrom(rootProject.allprojects.collect { p ->
              p.fileTree(p.layout.buildDirectory.dir('jacoco')) { include '*.exec' }
          })
          sourceDirectories.setFrom(sourceSets.main.java.sourceDirectories)
          classDirectories.setFrom(sourceSets.main.output.classesDirs)
          reports.xml.required = true
          reports.html.required = false
      }
  }
  ```
* make the `sonar` task run those reports first, in root `build.gradle`:
  ```groovy
  tasks.named('sonar') {
      dependsOn subprojects.collect { sp -> sp.tasks.matching { it.name == 'sonarCoverageReport' } }
  }
  ```
* add a new file to root of project called `sonar.gradle` with the following contents:
  ```groovy
  apply plugin: "org.sonarqube"
  sonar {
      properties {
        property 'sonar.projectName', 'Example of SonarScanner for Gradle (multimodule with Jacoco code coverage)'
        property "sonar.projectKey", "org.sonarqube.gradle-multi-module-jacoco"

        // Add other analysis parameters here if you don't
        // want to add it to the Sonar scanner command line:
        // property "sonar.host.url", "yoursonarqubeurl"
        // property "sonar.token", "yourtoken"
        // etc.
    }
  }
  ```
* add `apply from: "$project.rootDir/sonar.gradle"` to root `build.gradle`


For other forms of Gradle and Maven code coverage, see [test coverage](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/test-coverage/java-test-coverage/) in the SonarSource community forum.

## Why one report per module
The scanner imports JaCoCo coverage module by module: `sonar.coverage.jacoco.xmlReportPaths` is read once for every module, and each module can only resolve report entries against its own source files.

That leaves two things to reconcile. Coverage can be produced anywhere in the build and needs to reach whichever module owns the covered class — `Main` in `application` calls into both `list` and `utilities`, so a test for it would cover code in three modules at once — yet each report is only ever imported in the context of a single module. This example satisfies both by giving every module a `sonarCoverageReport` task whose execution data is the whole build's `*.exec` files, while `classDirectories` is narrowed to the classes that module owns. Coverage is credited to the owning module wherever it was produced, and no report mentions a file the importing module cannot resolve.

The more obvious approach — building one aggregated report and pointing every module's `sonar.coverage.jacoco.xmlReportPaths` at it — also reports correct coverage, but each module then warns about every class owned by a sibling. On a large build that runs to tens of thousands of log lines.

Note that `sonar.coverage.jacoco.aggregateXmlReportPaths` does not solve this under Gradle, despite being the documented answer for Maven. Its importer runs once against the root project, and a root project with no Java sources of its own resolves nothing, so coverage silently drops to zero while the log gets quieter. This is a known issue with tickets open at SonarSource — see [this community thread](https://community.sonarsource.com/t/sonar-multimodule-with-coverage-logging-file-filename-not-found-in-project-sources/181980) for the full discussion. If you try it, check your coverage number rather than trusting the cleaner log.

If your modules are independent enough that each one's tests only cover its own code, you do not need any of this: enable `xml.required` on each module's own `jacocoTestReport` task and drop the Sonar coverage configuration entirely, since the scanner then fills in `sonar.coverage.jacoco.xmlReportPaths` per module for you. See [SonarScanner for Gradle - Multi-Module](../gradle-multimodule) for that approach.

## Things to Note
* `utilities` applies `java-library` but not `jacoco`, so it gets no `sonarCoverageReport` task and its classes are reported as uncovered. Apply the `jacoco` plugin to a module to bring it into coverage.
* You may notice this warning about bytecode dependencies:
  ```text
  Bytecode of dependencies was not provided for analysis of source files, you might end up with less precise results. Bytecode can be provided using sonar.java.libraries property.
  ```
  This is primarily due to the lack of dependencies (e.g. empty `dependencies {}` block) in this example project. Your actual project may include dependencies that can may include vulnerabilities, which will require setting `sonar.java.binaries` and `sonar.java.libraries` parameters to scan for them. To avoid this warning and thus avoid needing to configure `sonar.java.binaries` and `sonar.java.libraries` manually, ensure that you are using SonarScanner for Gradle instead of SonarScanner. By using SonarScanner for Gradle, the setting of `sonar.java.binaries` and `sonar.java.libraries` is done automatically for you. See also [Java](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/languages/java/) for more details.
