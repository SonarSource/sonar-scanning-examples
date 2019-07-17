#Multi-module Apache Maven example

This project is importing JaCoCo's aggregate XML report to be able to report coverage cross-modules as well as unit
test coverage inside the module. For basic example see [basic maven project](../sonarscanner-maven-basic/README.md).

##Usage

* Build the project, execute all the tests and analyze the project with SonarQube Scanner for Maven:

        mvn clean verify sonar:sonar

##Description

Project consists of 3 modules. [`module1`](module1/pom.xml) and [`module2`](module2/pom.xml) contain "business logic" and 
related unit tests. [`tests`](tests/pom.xml) module contain integration tests which test functionality using both modules. 
`tests` module is also the one which creates the aggregate coverage report imported into SonarQube.

To generate the report we configure JaCoCo plugin to attach its agent to the jvm which is executing the tests in top 
level [pom](pom.xml). This configuration is done in `<pluginManagment>` section, so it will be applied on every submodule.
It is also configured inside the `coverage` profile, so this can be activated as needed (e.g. only in CI pipeline).

```xml
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

Once we have configured JaCoCo to collect coverage data, we need to generate XML coverage report to be imported into 
SonarQube. We will use [report-aggregate](https://www.jacoco.org/jacoco/trunk/doc/report-aggregate-mojo.html) goal which 
collects data from all modules dependent on the `tests` module. To achieve this we configure JaCoCo plugin by configuring execution 
 of `report-aggregate` goal in `verify` phase. See [pom.xml](tests/pom.xml) 

```xml
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

This will create report in `tests/target/site/jacoco-aggregate/jacoco.xml`. To import this report we will set 
`sonar.coverage.jacoco.xmlReportPaths` property in every module on which this coverage should be imported

```xml
<properties>
  <sonar.coverage.jacoco.xmlReportPaths>${project.basedir}/../${aggregate.report.dir}</sonar.coverage.jacoco.xmlReportPaths>
</properties>
``` 

We use `${aggregate.report.dir}` which is defined in top level [`pom.xml`](pom.xml) to avoid duplicated the location of the 
report in every module.

Alternatively we can set this property on command line with `-D` switch like 

```
mvn -Dsonar.coverage.jacoco.xmlReportPaths=C:\projects\sonar-scanning-examples\sonarscanner-maven-aggregate\tests\target\site\jacoco-aggregate\jacoco.xml clean verify sonar:sonar 
```

We have to use absolute path, because report will be imported for each module separately and path is resolved relatively to the module dir.
    
        
##Documentation

[SonarScanner for Maven](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-maven/)
