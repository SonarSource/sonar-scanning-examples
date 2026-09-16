# SonarScanner for Multi-Module Java Gradle Project

This example demonstrates how to analyze a multi-module Java project with Gradle, laid out the
way a real Gradle build is structured today: Kotlin DSL, shared build logic in a convention
plugin under `buildSrc/`, and a `build.gradle.kts` per module. See
[SonarScanner for Gradle](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-gradle)
for more information.

## Prerequisites
* A Gradle wrapper is included that bundles Gradle. All other required plugins will be pulled by Gradle as needed.
* A JDK 17 or later to run Gradle itself. The modules build against a Java 25 toolchain, which Gradle downloads automatically if you do not have one installed.

## Usage
Run the following command (update `sonar.host.url` and `sonar.token` analysis parameters as needed either at command line or in your `gradle.properties` file):
* On Unix-like systems:
  ```shell
  ./gradlew build -Dsonar.host.url=http://localhost:9000 -Dsonar.token=<token> sonar
  ```
* On Windows:
  ```shell
  .\gradlew.bat build -Dsonar.host.url=http://localhost:9000 -Dsonar.token=<token> sonar
  ```

## Project layout

```text
gradle-multimodule
├── settings.gradle.kts                 modules, project name
├── build.gradle.kts                    SonarScanner for Gradle, applied here and nowhere else
├── gradle.properties                   group, version and build options
├── gradle
│   └── libs.versions.toml              version catalog, shared with buildSrc
├── buildSrc
│   ├── settings.gradle.kts             reuses the version catalog above
│   ├── build.gradle.kts                applies `kotlin-dsl` so src/main/kotlin holds convention plugins
│   └── src/main/kotlin
│       └── buildlogic.java-conventions.gradle.kts     shared Java, test and JaCoCo setup
├── module-one
│   ├── build.gradle.kts
│   └── src/{main,test}/java
└── module-two                          same shape, depends on :module-one
```

## Where the Sonar configuration goes

The `org.sonarqube` plugin is applied **only to the root project**, which is what the
documentation calls for: apply it to the root of the hierarchy and it discovers the modules
itself. Applying it to each module as well is redundant, because the root plugin already adds
a `sonar` extension to every subproject. (The older `gradle-multimodule-coverage` example still
applies it inside `subprojects {}`; that is not needed and should not be copied.)

Everything that describes the analysis as a whole - here `sonar.projectKey` and
`sonar.projectName` - goes in the root `sonar` block. Module keys are derived from it
automatically as `<root key>:<module path>`.

There is deliberately **no Sonar configuration in `buildSrc/`**, and none in the module build
files either. The scanner reads Gradle's object model, so once a module applies the Java plugin
it already knows that module's `sonar.sources`, `sonar.tests`, `sonar.java.binaries`,
`sonar.java.libraries` and `sonar.junit.reportPaths`. Putting those in a convention plugin would
mean restating what Gradle already tells the scanner. Reach for a convention plugin only for a
Sonar property that genuinely differs per module and that Gradle cannot infer.

## Sharing build logic without `allprojects` / `subprojects`

The modules are configured by the `buildlogic.java-conventions` precompiled script plugin in
`buildSrc/`, which each module applies like any other plugin:

```kotlin
// module-one/build.gradle.kts
plugins {
    id("buildlogic.java-conventions")
}
```

This replaces the older approach of reaching into the modules from the root build with
`allprojects {}` / `subprojects {}` and `apply plugin:`. Cross-project configuration like that
couples every module to the root build and is incompatible with Gradle's
[isolated projects](https://docs.gradle.org/current/userguide/isolated_projects.html) work, so
convention plugins are the recommended way to share configuration as of Gradle 9.

## Dependency versions and the configuration cache

Dependency versions live in the
[version catalog](https://docs.gradle.org/current/userguide/version_catalogs.html) at
`gradle/libs.versions.toml`, and `buildSrc/settings.gradle.kts` reuses that same file so the
convention plugin resolves versions from one place. Precompiled script plugins do not get the
type-safe `libs.` accessors that ordinary build scripts do, so the convention plugin reads the
catalog through its extension instead.

`gradle.properties` turns on the
[configuration cache](https://docs.gradle.org/current/userguide/configuration_cache.html), which
Gradle recommends enabling for new builds. The `sonar` task works with it: the build and the
analysis both store and reuse a cache entry.

## Coverage

The convention plugin applies the `jacoco` plugin and enables its XML report, so `./gradlew build`
writes `module-*/build/reports/jacoco/test/jacocoTestReport.xml`. The scanner reads that report
location from the JaCoCo plugin and sets each module's
`sonar.coverage.jacoco.xmlReportPaths` for you, so coverage is imported without configuring it.

This gives you one coverage report per module, which is what `sonar.coverage.jacoco.xmlReportPaths`
expects: it is imported once per module. If you would rather merge every module into a single
aggregated report, that takes an extra Gradle task and a little more configuration - see
[SonarScanner for Gradle - Multi-Module Code Coverage](../gradle-multimodule-coverage). For other
forms of Gradle code coverage, see
[test coverage](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/test-coverage/java-test-coverage/).
