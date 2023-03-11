pipeline {
    agent any
    tools {
        maven 'mvn'
    }
    stages{
        stage('GIT checkout') {
            steps {
                git url: 'https://github.com/m-khamis/my-project'
           }
       }
          stage('Build Package') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Docker build and Tag') {
            steps{
                sh 'docker build -t ${JOB_NAME}:v1.${BUILD_NUMBER} .'
                sh 'docker tag ${JOB_NAME}:v1.${BUILD_NUMBER} mkhamis/${JOB_NAME}:v1.${BUILD_NUMBER} '
                sh 'docker tag ${JOB_NAME}:v1.${BUILD_NUMBER} mkhamis/${JOB_NAME}:latest '
            }
        }
        stage('push conatiner') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerhubPassword', usernameVariable: 'dockerhubUser')]) {
        	      sh "docker login -u ${env.dockerhubUser} -p ${env.dockerhubPassword}"
                  sh 'docker rmi ${JOB_NAME}:v1.${BUILD_NUMBER} mkhamis/${JOB_NAME}:v1.${BUILD_NUMBER} mkhamis/${JOB_NAME}:latest'
                }      
            }
        }
        stage('Docker Deploy') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerhubPassword', usernameVariable: 'dockerhubUser')]) {
        	         sh "docker login -u ${env.dockerhubUser} -p ${env.dockerhubPassword}"
                   sh 'docker stop tomcat-container'
                   sh 'docker rm -f tomcat-container'
                   sh 'docker rmi -f mkhamis/hello-world'
                   sh 'docker run -d --name tomcat-container -p 8081:8081 mkhamis/my-project'
                }
            }
        }          
    }
}
