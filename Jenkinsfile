pipeline {
  agent {
    docker {
      image 'maven:alpine'
      args '-v /var/run/docker.sock:/var/run/docker.sock -v $HOME/.m2:/root/.m2'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh 'mvn clean install -f $PWD/sonarqube-scanner-maven/pom.xml'
      }
    }
  }
  environment {
    foo = 'bar'
  }
}