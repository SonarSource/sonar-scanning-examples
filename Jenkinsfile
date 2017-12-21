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
        junit(testResults: '**/target/surefire-reports/*.xml', allowEmptyResults: true)
      }
    }
    stage('Code Quality') {
      parallel {
        stage('Code Quality') {
          steps {
            sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.4.0.905:sonar -f $PWD/sonarqube-scanner-maven/pom.xml -Dsonar.host.url=http://node1:9000'
          }
        }
        stage('Dev Deployment') {
          steps {
            input 'deploy?'
            timeout(time: 60) {
              echo 'Aborting due to in-action'
            }
            
            echo 'Deployment starting'
          }
        }
        stage('Test Deployment') {
          steps {
            input 'Deploy?'
          }
        }
      }
    }
  }
}