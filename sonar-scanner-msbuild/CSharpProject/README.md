# SonarScanner for .NET (MSBuild) C# Project

This example demonstrates how to analyze a .NET Solution with the [SonarScanner for .NET](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-dotnet/). Please review [cateogrization of product projects versus test projects](https://github.com/SonarSource/sonar-scanner-msbuild/wiki/Analysis-of-product-projects-vs.-test-projects) to ensure your C# project is scanned correctly.

## Prerequisites
* [SonarScanner for .NET](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-dotnet/) 5.14.0+
* [Compatible .NET Build Environment](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-dotnet/#prerequisites)

## Usage
1. Run SonarScanner for .NET/MSBuild begin phase:
    ```powershell
    SonarScanner.MSBuild.exe begin /k:"org.sonarqube:sonar-scanner-msbuild" /n:"Example of SonarScanner for MSBuild Usage" /v:"1.0"
    ```
2. Build the project with MSBuild:
    ```powershell
    MSBuild.exe /t:Rebuild
    ```
3. Run SonarScanner for MSBuild end phase:
    ```powershell
    SonarScanner.MSBuild.exe end
    ```
