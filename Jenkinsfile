pipeline {
    agent any

    stages {
        stage('code') {
            steps {
                echo 'clone the code'
                git branch: 'main', url: 'https://github.com/sachinkumar04/code-repo.git'
            }
        }
        stage('Build Image') {
            steps {
                echo 'build image succesfully'
                sh "docker build -t nodeapp ."
            }
        }
        stage('PushImage') {
            steps {
                echo 'PushImage to Dockerhub'
                withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'pass', usernameVariable: 'user')]){
                sh "docker login -u ${env.user} -p ${env.pass}"
                sh "docker tag nodeapp sachinkumar04/nodeapp:latest"
                sh "docker push sachinkumar04/nodeapp:latest"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploy app on docker'
                sh "docker stop myapp1 || true"
                sh "docker rm myapp1 || true"
                sh "docker run -d -p 8000:8000 --name myapp1 nodeapp"
            }
        }
    }
}