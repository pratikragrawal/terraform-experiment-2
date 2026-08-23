pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *')
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '20'))
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
                sh 'terraform fmt -check -recursive -diff'
                sh 'rm -rf .terraform'
                sh 'terraform init -input=false -reconfigure'
                sh 'terraform validate'
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
                    artifacts: 'tfplan, tfplan.txt',
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
                        message: 'Apply the archived plan to the cloud account?',
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
}