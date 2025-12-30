# Sonar Scanning Examples

This repository showcases basic examples of usage and code coverage for SonarScanners.
* [SonarScanner for Gradle](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-gradle)
* [SonarScanner for .NET](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/dotnet/introduction)
* [SonarScanner for Maven](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-maven)
* SonarScanner CLI in a Java Ant project (Formerly [SonarScanner for Ant](https://docs.sonarsource.com/sonarqube-server/10.8/analyzing-source-code/scanners/sonarscanner-for-ant) - this scanner is now deprecated, use SonarScanner CLI)
* [SonarScanner CLI](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner

Sonar's [Clean Code solution](https://www.sonarsource.com/solutions/clean-code/) helps developers deliver high-quality, efficient code standards that benefit the entire team or organization. 

## Examples
### Various Languages
[SonarScanner for various languages](sonar-scanner)

Scan all the languages available or change directory to a language folder to scan just that language.

### Ant
Scanning an Ant project is no different than scanning a plain Java (no build tool) project. Ant is used to build the project, but not to run the scan. Instead, the SonarScanner CLI is used.
* [SonarScanner for Ant - Basic](sonar-scanner-ant/ant-basic)
* [SonarScanner for Ant - Code Coverage](sonar-scanner-ant/ant-coverage)

[SonarScanner for Ant](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-ant) is now deprecated. Please migrate to the SonarScanner CLI.


### Gradle
If you have a Gradle project, we recommend the use of [SonarScanner for Gradle](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-gradle) or the equivalent `gradle sonar` task in your CI pipeline.
* [SonarScanner for Gradle - Basic](sonar-scanner-gradle/gradle-basic)
* [SonarScanner for Gradle - Kotlin DSL](sonar-scanner-gradle/gradle-kotlin-dsl)
* [SonarScanner for Gradle - Multi-Module](sonar-scanner-gradle/gradle-multimodule)
* [SonarScanner for Gradle - Multi-Module Code Coverage](sonar-scanner-gradle/gradle-multimodule-coverage)

### Maven
If you have a Maven project, we recommend the use of [SonarScanner for Maven](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner-for-maven) or the equivalent `mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar` goal in your CI pipeline.
* [SonarScanner for Maven - Basic](sonar-scanner-maven/maven-basic)
* [SonarScanner for Maven - Multilingual (Java + Kotlin with coverage)](sonar-scanner-maven/maven-multilingual)
* [SonarScanner for Maven - Multi-Module](sonar-scanner-maven/maven-multimodule)

### DotNet/C#
If you have a .NET project, we recommend the use of [SonarScanner for .NET](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/dotnet/introduction) or the equivalent SonarScanner for .NET on your CI pipeline.
* [SonarScanner for .NET/MSBuild - C#](sonar-scanner-msbuild/CSharpProject)

### Swift
[SonarScanner - Swift Code Coverage](swift-coverage)

### C/C++/Objective-C
**_NOTE:_** All SonarScanner examples for C, C++ and Objective-C can be found [here](https://github.com/sonarsource-cfamily-examples).
* SonarSource sample C and C++ projects with SonarCloud or SonarQube analysis configured
* C and C++ projects for different CI pipelines and build systems configured for Linux, Windows, and Mac

## License
Copyright 2016-2026 SonarSource.

Licensed under the [GNU Lesser General Public License, Version 3.0](http://www.gnu.org/licenses/lgpl.txt)
