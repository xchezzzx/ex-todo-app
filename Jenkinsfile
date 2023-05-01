// Part 3: Building a Jenkins Pipeline
// Write a Jenkinsfile that defines the Jenkins pipeline for the application.
// 1. Clone the source code repository of the Node.js application from GitHub.
// 2. Define a stage called 'Build and Test' that will build and test your Docker image. 
// 3. Define a stage called 'Deploy to EC2' that will deploy your Docker image to an EC2 instance. In the steps block, use the sshagent step to provide the SSH key for authentication. Then use the sh step to run the Docker Compose commands to stop and remove any existing containers on the EC2 instance, pull the latest Docker image from Docker Hub, and start the new containers based on the Docker image.
// 4. Define a stage called 'Check' that will check the health of your application. In the steps block, use the sh step to run a curl command that will check the health endpoint of your application. If the endpoint returns a 200 status code, the application is considered healthy.
// 5. Define a stage called 'Notifications' that will send notifications if the application is not healthy. In the steps block, you can choose to use Slack notification / the emailext step to send an email notification if the health check fails. You can specify the email recipients, subject, and body in the step parameters.
// Jenkinsfile Bonus: 
// 1. Build and push Docker image to Docker Hub: Add a stage to the Jenkins pipeline that will build your Docker image and push it to Docker Hub. (This will make it easier for you to deploy your Docker image to multiple environments.)
// 2. Run security scans: Add a stage to the Jenkins pipeline that will run security scans on your Docker image to ensure it is free of vulnerabilities. You can use tools like Aqua or Clair for this.


pipeline {
    agent any
    tools {
       nodejs "NodeJS19"
    }

    stages {
/*
        stage("Build and test") {
            steps {
                //install dependencies
                sh "npm install"
                //run internal tests
                sh "npm run test"
                sh "docker-compose --version"
            }
        }

        stage("Dockerize") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-io', passwordVariable: 'PASS', usernameVariable: "USER")]) {
                        sh "docker build . -t xchezzzx/ex-todo-app"
                        //sh "docker tag chz-todo-app-img:latest xchezzzx/ex-todo-app"
                        sh "docker login -u $USER -p $PASS"
                        sh "docker push xchezzzx/ex-todo-app"                        
                }
            }
        }
*/
        stage("Deploy to EC2") {
            steps {
                script {
                    def public_dns = "ec2-13-50-231-91.eu-north-1.compute.amazonaws.com"
                    def deploy_path = "/app/"

                    sshagent(["jenkins-ssh-ec2"]) {
                        sh """
                            scp docker-compose.yml ubuntu@${public_dns}:~/app
                            ssh -o StrictHostKeyChecking=no ubuntu@${public_dns} 'docker-compose -f ~/app/docker-compose.yml up -d'
                        """
                    }
                }
            }
        }
    }
}