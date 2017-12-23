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
      parallel {
        stage('Unit tests') {
          steps {
            sh 'mvn test -f $PWD/sonarqube-scanner-maven/pom.xml'
          }
        }
        stage('Integration tests') {
          steps {
            echo 'Preparing environment'
            echo 'Deploying application'
            echo 'Running integration tests'
          }
        }
      }
    }
    stage('Code Quality') {
      steps {
        sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.4.0.905:sonar -f $PWD/sonarqube-scanner-maven/pom.xml -Dsonar.host.url=http://node1:9000'
      }
    }
    stage('UAT test') {
      steps {
        timeout(time: 30) {
          input 'Should I deploy'
        }
        
      }
    }
  }
  post {
    always {
      archive 'target/**/*'
      junit(testResults: '**/target/surefire-reports/*.xml', allowEmptyResults: true)
      archiveArtifacts(artifacts: '**/target/*.jar', fingerprint: true, onlyIfSuccessful: true, defaultExcludes: true)
      
    }
    
  }
}