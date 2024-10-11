credentials = [[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'pipeline-role', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]
pipeline {
    agent {label 'ecs-tf12'}
    
    options {
        disableConcurrentBuilds()
    }
    
stages {
            
stage("Installing Prerequisites") {
            steps {
                script {
                  sh 'curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl'
                  sh 'chmod +x ./kubectl'
                  sh 'mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin'
                  sh 'kubectl version --short --client'
                  sh 'pip install awscli'
                  sh 'curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator'
                  sh 'chmod +x ./aws-iam-authenticator'
                  sh 'mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin'
                  sh "echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc"
                  
                }
            }
        }

stage('Creating Cluster') {                            
                steps {
                    dir("insider-assignment/terraform/eks-cluster") {
                    script {
                        withCredentials(credentials) {
                            sh 'terraform init -backend-config=var.tfvars'
                            sh 'terraform plan'
                            sh 'terraform apply -auto-approve' 
                            }
                         }
                    }
                }
        }

stage("Docker Build ") {
            steps {
                dir("insider-assignment/src/") {
                script {
                  sh 'docker build -t nodejs-test .'
                  sh 'docker run -p 80:80 -d nodejs-test'
                }
            }
        }
}

stage("ECR Push ") {
            steps {
                script {
                  sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 167947914732.dkr.ecr.us-west-2.amazonaws.com .'
                  sh 'docker tag nodejs-test:latest 167947914732.dkr.ecr.us-west-2.amazonaws.com/nodejs-test:latest'
                  sh 'docker push 167947914732.dkr.ecr.us-west-2.amazonaws.com/nodejs-test:latest'                 
                }
            
        }
}

stage('deploymet') {               
     steps {
        dir("insider-assignment/deployment-files") {
                 script {
                    withCredentials(credentials) {
                        sh'aws eks --region us-west-2 update-kubeconfig --name insider-cluster'
                        sh 'kubectl apply -f aws-auth-cm.yaml'
                        sh 'kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml' 
                        sh 'kubectl apply -f priority.yml'
                        sh 'kubectl apply -f deploy.yml'
                        sh 'kubectl apply -f service.yml'                                                
                        sh 'kubectl apply -f hpa-auto-scaler.yml'                                                
                        sh 'kubectl apply -f cluster-autoscale.yml'
                        }
                    }
                }
        }
     }
}
       
}
