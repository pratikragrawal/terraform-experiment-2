pipeline {
    agent any

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
        TF_IN_AUTOMATION      = 'true'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate') {
            steps {
                sh '''
                    rm -rf .terraform
                    rm -f terraform.tfstate
                    rm -f terraform.tfstate.backup

                    terraform init -input=false -reconfigure
                    terraform validate
                '''
            }
        }

        stage('Security Scan') {
            steps {
                sh 'tflint --init && tflint --format compact'
                sh 'tfsec . --minimum-severity HIGH'
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform plan -input=false -out=tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'

                archiveArtifacts(
                    artifacts: 'tfplan,tfplan.txt',
                    fingerprint: true
                )
            }
        }

        stage('Approval') {
            when {
                branch 'main'
            }

            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input(
                        message: 'Apply the archived Terraform plan?',
                        ok: 'Apply'
                    )
                }
            }
        }

        stage('Apply') {
            when {
                branch 'main'
            }

            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed — inspect the stage that went red.'
        }
    }
}/ /   a u t o m a t i c   t r i g g e r   t e s t 

 