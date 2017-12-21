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
        sh 'mvn clean install -DskipTests=true -f $PWD/sonarqube-scanner-maven/pom.xml'
      }
    }
    stage('Test') {
      steps {
        sh 'mvn test -f $PWD/sonarqube-scanner-maven/pom.xml'
      }
    }
  }
}