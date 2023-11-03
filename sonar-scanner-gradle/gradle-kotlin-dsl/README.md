# SonarScanner for Gradle (Kotlin DSL)

Example taken from https://github.com/Baeldung/kotlin-tutorials/tree/master/gradle-kotlin-dsl

This example repository exemplifies usage of integrating [SonarScanner for Gradle](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-gradle/) with Gradle's Kotlin DSL.

## Example Usage
Obtain your user token from your own account. See [Generating and using tokens](https://docs.sonarsource.com/sonarqube/latest/user-guide/user-account/generating-and-using-tokens/) for more information.

Run the following command (update `sonar.host.url`, `sonar.organization`, etc. properties as needed either at command line or in `build.gradle.kts`'s `sonar` block):
* On Unix-like systems:
  ```
  ./gradlew clean build jacocoTestReport -Dsonar.host.url=http://localhost:9000 -Dsonar.login=<INSERT-USER-TOKEN> sonar
  ```
* On Windows:
  ```
  .\gradlew.bat clean build jacocoTestReport -Dsonar.host.url=http://localhost:9000 -Dsonar.login=<INSERT-USER-TOKEN> sonar
  ```

Remove `jacocoTestReport` task to remove coverage report task

### Relevant Articles:
- [Kotlin DSL for Gradle](https://www.baeldung.com/kotlin/gradle-dsl)
- [Gradle's Kotlin DSL Primer](https://docs.gradle.org/current/userguide/kotlin_dsl.html)
- [Migrating build logic from Groovy to Kotlin](https://docs.gradle.org/current/userguide/migrating_from_groovy_to_kotlin_dsl.html#migrating_groovy_kotlin)
