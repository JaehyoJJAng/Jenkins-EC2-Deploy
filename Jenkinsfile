def mainDir="Apps"
def ecrLoginHelper="docker-credential-ecr-login"

pipeline {
    agent any

    environment {
        DEPLOY_HOST = credentials('ec2-public-ip')
        ECR_ID = credentials('aws-ecr-id')
        REPOSITORY = credentials('repository')
        REGION = credentials('aws-region')
        IMAGE_NAME = credentials('docker-image-name')
        DOCKER_HUB = credentials('docker-hub')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        
        stage('1. Pull Codes from Github'){
            steps{
                checkout scm
            }
        }

        stage('2. Build Codes by Gradle') {
            steps {
                sh """
                cd ${mainDir}
                bash gradlew clean build
                """
            }
        }

        stage('3. Docker hub Login') {
            steps {
                sh ("""
                    echo "Docker hub Login start"
                    echo "${DOCKER_HUB_PSW}" | docker login --username ${DOCKER_HUB_USR} --password-stdin
                    """
                )
            }
        }

        stage('4. AWS CONFIGURE') {
            steps {
                sh ("""
                        aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
                        aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
                        aws configure set default.region ${REGION}
                    """
                )
            }
        }

        stage('5. ECR login') {
            steps {
                sh("""
                    aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_ID}.dkr.ecr.${REGION}.amazonaws.com
                    """
                )
            }
        }

        stage('6') {
            steps {
                sh("""
                ls -alh
                ls -alh ./Apps
                """)
                
            }
        }
        // stage('6. Build Docker Image & Push to AWS ECR') {
        //     steps {
        //         sh("""
        //             echo "Docker Image build start"
        //             docker build --tag ${IMAGE_NAME}:latest ./Apps

        //             docker tag ${IMAGE_NAME}:latest ${ECR_ID}.dkr.ecr.ap-northeast-2.amazonaws.com/${REPOSITORY}:latest
                    
        //             docker push ${ECR_ID}.dkr.ecr.ap-northeast-2.amazonaws.com/${REPOSITORY}:latest
        //             """
        //         )
        //     }
        // }

        // stage(3. 'Build Docker Image by Jib & Push to AWS ECR Repository') {
        //     steps {
        //         withAWS(region:"${region}", credentials:"aws-key") {
        //             ecrLogin()
        //             sh """
        //                 curl -O https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/0.4.0/linux-amd64/${ecrLoginHelper}
        //                 chmod +x ${ecrLoginHelper}
        //                 mv ${ecrLoginHelper} /usr/local/bin/
        //                 cd ${mainDir}
        //                 ./gradlew jib -Djib.to.image=${ecrUrl}/${repository}:${currentBuild.number} -Djib.console='plain'
        //             """
        //         }
        //     }
        // }

        // stage('3. Deploy to AWS EC2 VM'){
        //     steps{
        //         sshagent(credentials : ["deploy-key"]) {
        //             sh "ssh -o StrictHostKeyChecking=no ubuntu@${deployHost} \
        //              'aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ecrUrl}/${repository}; \
        //               docker run -d -p 80:8080 -t ${ecrUrl}/${repository}:${currentBuild.number};'"
        //         }
        //     }
        // }

    }
}
