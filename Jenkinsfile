pipeline {
    agent any
    stages {
        stage('Integration Tests') {
            environment {
                 KEYCLOAK_USER = credentials('${KEYCLOAK_USER}')
                        KEYCLOAK_PASS = credentials('${KEYCLOAK_PASS}')
            }
            steps {
                echo 'RUNNING REMOVALS E2E TESTS'
                echo User: '${KEYCLOAK_USER}'
                echo Password: '${KEYCLOAK_PASS}'

                echo '${TEST_ENV}'

                ./runtests.sh --env '${TEST_ENV}'
            }
        }
    }
}