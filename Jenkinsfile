pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '20'))
    disableConcurrentBuilds()
    timestamps()
  }

  triggers {
    pollSCM('H/2 * * * *')
  }

  environment {
    HUGO_VERSION = '0.161.1'
    BLOG_DOMAIN = 'kinghh.cn'
    BLOG_WWW_DOMAIN = 'www.kinghh.cn'
    SITE_ROOT = '/var/www/kinghh-blog'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'bash deploy/scripts/jenkins-deploy-static.sh build'
      }
    }

    stage('Deploy') {
      when {
        expression {
          return env.BRANCH_NAME == null || env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master'
        }
      }
      steps {
        sh 'bash deploy/scripts/jenkins-deploy-static.sh deploy'
      }
    }
  }

  post {
    success {
      echo "Deployed ${env.JOB_NAME} #${env.BUILD_NUMBER} to ${env.SITE_ROOT}"
    }
  }
}
