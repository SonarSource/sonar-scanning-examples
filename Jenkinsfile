pipeline {
  agent any
  stages {
    stage('SonarQube') {
      steps {
        waitForQualityGate()
      }
    }
    stage('build') {
      steps {
        echo 'build done'
      }
    }
  }
}