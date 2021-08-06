Original repository based on [scotch-io/scotch-angular-testing's testing-part-two branch](https://github.com/scotch-io/scotch-angular-testing/tree/testing-part-two)

### Setup

```text
nvm use 5.0
npm install
node server.js
```

### Test

```text
npm install -g karma-cli
karma start
```

### Running Sonar Scanner CLI
```text
npm install # Ensure dependencies are installed
karma start # Generates report file, then you can press Ctrl+C to abort the karma process
sonar-scanner -Dsonar.projectKey=generic-test-data-angularjs -Dsonar.projectName='Generic Test Data with AngularJS' -Dsonar.login=<INSERT-USER-TOKEN> -Dsonar.host.url=<INSERT-SONARQUBE-URL>
```

### SonarQube Test Execution Report
See official documentation: [Test Coverage and Execution](https://docs.sonarqube.org/latest/analysis/coverage/) and [Generic Execution Data](https://docs.sonarqube.org/latest/analysis/generic-test/):
> You can use [jest-sonar-reporter](https://www.npmjs.com/package/jest-sonar-reporter) or [karma-sonarqube-unit-reporter](https://github.com/tornaia/karma-sonarqube-unit-reporter) to create reports in the [Generic Execution Data](https://docs.sonarqube.org/latest/analysis/generic-test/) format. Both packages are available on npm.

As noted in links above, for JavaScript/TypeScript test execution reports, you need to use Generic Execution Data formatted XML, which jest-sonar-reporter and karma-sonarqube-unit-reporter perform for you, and then pass this report to the Sonar Scanner via `sonar.testExecutionReportPaths`.

In this example project, note the following changes in `karma.conf.js`:
```text
    reporters: ['spec', 'sonarqubeUnit']
    ...
    sonarQubeUnitReporter: {
      sonarQubeVersion: 'LATEST',
      outputFile: 'reports/ut_report.xml',
      overrideTestDescription: true,
      testPaths: [
        './app/components/users',
        './app/components/missingno',
        './app/components/profile',
        './app/filters/capitalize',
        './app/services/pokemon',
        './app/services/users'
      ],
      testFilePattern: '.spec.js',
      useBrowserName: false
    },

    plugins: [
      'karma-chrome-launcher',
      'karma-jasmine',
      'karma-sonarqube-unit-reporter',
      'karma-spec-reporter'
    ],
```

Also note the sonar-project.properties to set analysis scope (since the unit test files live next to the source files):
```text
sonar.sources=app/components
sonar.tests=app/components
sonar.test.inclusions=app/**/*.spec.js

sonar.testExecutionReportPaths=reports/ut_report.xml
```
