pipeline {
    agent any
    tools {
       nodejs "NodeJS19" 
    }

    stages {

        stage("Build and test") {
            steps {
                //install dependencies
                sh "npm install"
                //run internal tests
                sh "npm run test"
            }
        }

        stage("Deploy to EC2") {
            steps {
                echo "step 2"
            }
        }
    }
}