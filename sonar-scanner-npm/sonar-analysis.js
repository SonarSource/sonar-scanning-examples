const scanner = require('sonarqube-scanner')
const env = require('dotenv').config();

// On supported CI tools, you should not need to pass your authentication, organization ID, and instance address info
// ---------
scanner(
  {
    options: {
      'sonar.projectKey': 'org.sonarqube:sonar-scanner-npm-example',
      'sonar.organization': 'MyOrganization', // set your Organization ID here, for SonarCloud only
      'sonar.projectName': 'SonarScanner for NPM example',
      'sonar.projectDescription': 'sonarqube-scanner example on a basic REACT project from https://create-react-app.dev/',
      'sonar.verbose': 'true',
      'sonar.host.url': process.env.SONAR_HOST_URL,
      'sonar.login': process.env.SONAR_TOKEN
    }
  },
  () => process.exit()
)