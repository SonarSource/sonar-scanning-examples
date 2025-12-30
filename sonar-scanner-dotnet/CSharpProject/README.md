# SonarScanner for .NET example
Formerly known as SonarScanner for MSBuild.

This example demonstrates how to analyze a .NET Solution with the [SonarScanner for .NET](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-dotnet/). Please review [Specifying test project analysis](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/dotnet-environments/specify-test-project-analysis/) to ensure your C# project is scanned correctly.

## Prerequisites
* [SonarScanner for .NET](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-dotnet/)
* [Compatible .NET Build Environment](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-dotnet/#prerequisites)

## Usage
1. Run SonarScanner for .NET begin phase:
    ```powershell
    SonarScanner.MSBuild.exe begin /k:"org.sonarqube:sonar-scanner-msbuild" /n:"Example of SonarScanner for MSBuild Usage" /d:sonar.token="<token>" /d:sonar.host.url="http://localhost:9000" /v:"1.0"
    ```
    or
    ```bash
    dotnet sonarscanner begin /k:"org.sonarqube:sonar-scanner-msbuild" /n:"Example of SonarScanner for MSBuild Usage" /d:sonar.token="<token>" /d:sonar.host.url="http://localhost:9000 /v:"1.0"
    ```
2. Build the project with MSBuild/dotnet:
    ```powershell
    MSBuild.exe /t:Rebuild
    ```
    or
    ```bash
    dotnet build --no-incremental
    ```
3. Run SonarScanner for .NET phase:
    ```powershell
    SonarScanner.MSBuild.exe end /d:sonar.token="<token>"
    ```
    or
    ```bash
    dotnet sonarscanner end /d:sonar.token="<token>"
    ```
