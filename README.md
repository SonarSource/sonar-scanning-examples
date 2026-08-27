<p align="center">
  <img src="https://assets-eu-01.kc-usercontent.com/ef593040-b591-0198-9506-ed88b30bc023/82c13eba-d95c-4bb8-8007-7ce77c14e043/Sonar_Logo_Light%20Backgrounds.svg" alt="Sonar logo" width="400">
</p>

# SonarScanner examples

This repository provides small projects that show how to configure and run SonarScanners across common build tools, languages, and coverage workflows. Each example is a focused reference that can be compared with the corresponding setup in your own project.

[![GitHub stars](https://img.shields.io/github/stars/SonarSource/sonar-scanning-examples?style=flat)](https://github.com/SonarSource/sonar-scanning-examples)
[![License](https://img.shields.io/badge/license-LGPL--3.0-blue)](#license)
[![Community forum](https://img.shields.io/badge/community-forum-blue)](https://community.sonarsource.com/)

## What you can learn

- Configure SonarScanner for Gradle, Maven, .NET, and CLI projects.
- Scan projects in several languages and build environments.
- Import test coverage into SonarQube analysis.
- Use SonarScanner CLI with older Ant projects.
- Use the examples as a starting point for a CI verification loop.

## Examples

- [Various languages](sonar-scanner)
- SonarScanner CLI in an Ant project:
  - [Basic](sonar-scanner-ant/ant-basic)
  - [Code coverage](sonar-scanner-ant/ant-coverage)
- SonarScanner for Gradle:
  - [Basic](sonar-scanner-gradle/gradle-basic)
  - [Kotlin DSL](sonar-scanner-gradle/gradle-kotlin-dsl)
  - [Kotlin](sonar-scanner-gradle/gradle-kotlin-project)
  - [Multi-module](sonar-scanner-gradle/gradle-multimodule)
  - [Multi-module code coverage](sonar-scanner-gradle/gradle-multimodule-coverage)
- SonarScanner for Maven:
  - [Basic](sonar-scanner-maven/maven-basic)
  - [Multilingual Java and Kotlin with coverage](sonar-scanner-maven/maven-multilingual)
  - [Multi-module](sonar-scanner-maven/maven-multimodule)
- [SonarScanner for .NET](sonar-scanner-dotnet/CSharpProject)
- [Swift coverage](swift-coverage)
- [C, C++, and Objective-C examples](https://github.com/sonarsource-cfamily-examples)

The repository also includes focused examples for Gradle multi-module builds, Kotlin DSL, Maven multi-module projects, Java and Kotlin coverage, and .NET projects. Each example contains the project files and scanner configuration needed to reproduce the analysis.

The Ant scanner is deprecated. Use [SonarScanner CLI](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner) or the scanner that matches your build system.

## Quick start

Clone the repository and open the example that matches your build system:

```bash
git clone https://github.com/SonarSource/sonar-scanning-examples.git
cd sonar-scanning-examples
```

Follow the example's local README to configure its scanner for [SonarQube Server](https://www.sonarsource.com/products/sonarqube/server/) or [SonarQube Cloud](https://www.sonarsource.com/products/sonarqube/cloud/). The analysis results will appear in the SonarQube project configured by that example. Start with the [scanner documentation](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners) if you have not yet created a project or token.

For example, after configuring the target URL and token, run the basic Maven project with:

```bash
cd sonar-scanner-maven/maven-basic
mvn clean verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar
```

For Gradle, use the `sonar` task. For Maven, use the Sonar Maven plugin goal. For .NET, follow the begin, build, and end steps in the SonarScanner for .NET documentation. For a project without a supported build integration, use SonarScanner CLI.

## Links

- [Scanner documentation](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners)
- [Community forum](https://community.sonarsource.com/)
- [Report an issue](https://github.com/SonarSource/sonar-scanning-examples/issues)
- [Contributing](#contributing)
- [Security policy](https://www.sonarsource.com/trust-center/)
- [SonarScanner CLI](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner)

## FAQ

**Which example should I start with?** Use the scanner that matches your build system: Gradle, Maven, or .NET. Use SonarScanner CLI for projects without a supported build-system integration.

## Contributing

If you find an example that is out of date or unclear, open an issue or pull request with the relevant tool version, SonarQube product, and expected result. Keep examples small and copy-paste friendly.

## License

Copyright 2016-2026 SonarSource.

Licensed under the [GNU Lesser General Public License, Version 3.0](https://www.gnu.org/licenses/lgpl-3.0.txt).

## Get started

Choose a [scanner example](#examples), then follow the matching [scanner documentation](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners).
