pipeline {
  agent any
  environment {
    PATH = "/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:${env.PATH}"
  }
  stages {
    stage('Validate') {
      environment {
        PUPPET_GEM_VERSION = "~> 6.0"
      }

      agent {
        docker {
          image 'ruby:2.5.7'
          args '-v=/etc/passwd:/etc/passwd -v=/var/lib/jenkins:/var/lib/jenkins'
        }
      }
      steps {
        sh 'echo $PATH'
        sh 'bundle -v'
        sh 'rm Gemfile.lock || true'
        sh 'gem --version'
        sh 'bundle -v'
        sh 'bundle install'
        sh 'bundle exec rake validate'
      }
    }
    stage('Unit Tests') {
      parallel {
        stage('Puppet 5.x') {
          environment {
            PUPPET_GEM_VERSION = "~> 5.0"
          }
          agent {
            docker {
              image 'ruby:2.4.5'
              args '-v=/etc/passwd:/etc/passwd -v=/var/lib/jenkins:/var/lib/jenkins'
            }
          }
          steps {
            sh 'echo $PATH'
            sh 'bundle -v'
            sh 'rm Gemfile.lock || true'
            sh 'gem --version'
            sh 'bundle -v'
            sh 'bundle install'
            sh 'bundle exec rake parallel_spec'
          }
        }
        stage('Puppet 6.x') {
          environment {
            PUPPET_GEM_VERSION = "~> 6.0"
          }
          agent {
            docker {
              image 'ruby:2.5.7'
              args '-v=/etc/passwd:/etc/passwd -v=/var/lib/jenkins:/var/lib/jenkins'
            }
          }
          steps {
            sh 'echo $PATH'
            sh 'bundle -v'
            sh 'rm Gemfile.lock || true'
            sh 'gem --version'
            sh 'bundle -v'
            sh 'bundle install'
            sh 'bundle exec rake parallel_spec'
          }
        }
      }
    }
  }
}
