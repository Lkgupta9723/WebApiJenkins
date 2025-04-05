pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'jenkins-pipeline-sp'
        RESOURCE_GROUP = 'WebServiceRG'
        APP_SERVICE_NAME = 'lg97'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Lkgupta9723/WebApiJenkins.git'
            }
        }

        stage('Build') {
            steps {
                bat 'dotnet restore'
                bat 'dotnet build --configuration Release'
                bat 'dotnet publish -c Release -o ./publish'
            }
        }

        stage('Deploy') {
    steps {
        withCredentials([azureServicePrincipal(
            credentialsId: 'AZURE_CREDENTIAL_ID', // Replace with your actual Jenkins credentials ID
            subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
            clientIdVariable: 'AZURE_CLIENT_ID',
            clientSecretVariable: 'AZURE_CLIENT_SECRET',
            tenantIdVariable: 'AZURE_TENANT_ID'
        )]) {
            bat """
            az login --service-principal -u "%AZURE_CLIENT_ID%" -p "%AZURE_CLIENT_SECRET%" --tenant "%AZURE_TENANT_ID%"
            az webapp deploy --resource-group WebServiceRG --name lg97 --src-path ./publish --type zip
            """
        }
    }
}
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}
