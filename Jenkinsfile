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
      steps {
        sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.4.0.905:sonar -f $PWD/sonarqube-scanner-maven/pom.xml -Dsonar.host.url=http://node1:9000'
      }
    }
    stage('Deployment') {
      parallel {
        stage('Dev Deployment') {
          steps {
            echo 'Deployment starting'
          }
        }
        stage('Test Deployment') {
          steps {
            input 'Deploy'
            echo 'Provisioning Environment'
            echo 'Preparing DB'
            echo 'Preparing deployment'
            echo 'Running regression testing'
          }
        }
        stage('Destroy Test env') {
          steps {
            input 'Destroy env?'
            echo 'Tearing down test environment'
          }
        }
      }
    }
    stage('UAT') {
      parallel {
        stage('UAT deployment decision') {
          steps {
            input 'Deploy?'
          }
        }
        stage('Prepare UAT') {
          steps {
            echo 'Prepare env'
          }
        }
      }
    }
  }
}