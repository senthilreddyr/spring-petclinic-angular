podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'packer',image: 'senthilreddy/anpm:latest', ttyEnabled: true, command: 'cat')
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ]
  ) {
    node('mypod') {
        stage('Get latest version of code') {
                script{
                   def scmVar =  checkout([
                        $class: 'GitSCM', branches: scm.branches,
                        extensions: scm.extensions + [[$class: 'CleanBeforeCheckout', deleteUntrackedNestedRepositories: true]],
                        userRemoteConfigs: scm.userRemoteConfigs])
                }
        }
    
      stage('Packer') {
        container('packer') {
          withCredentials([usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]){
            backend_url=sh(script:'aws elbv2 describe-load-balancers --region ap-south-1 | jq \'.LoadBalancers[] | select(.LoadBalancerName== "pet-be") | .DNSName\'',returnStdout: true)
            sh "npm install -g @angular/cli@latest"
            sh "mkdir dist"
            sh "packer build -var \"backend_url=${backend_url}\" ./packer.json"
            sh "echo ${backend_url}"
            AMI_ID=sh(script:'cat manifest.json | jq -r .builds[0].artifact_id |  cut -d\':\' -f2',returnStdout: true)
          }

        }
      }
    if (currentBuild.currentResult == 'SUCCESS') {
      stage('Trigger deploy') 
          script {
            def USER_INPUT = input(
                  message: 'Check if VM needs to be deployed - Yes/No',
                  parameters: [
                          [$class: 'ChoiceParameterDefinition',
                            choices: ['no','yes'].join('\n'),
                            name: 'input',
                            description: 'Menu - select box option']
                  ])
          if( "${USER_INPUT}" == "yes"){
              echo "${AMI_ID}"
              build job: 'pet_be_deploy', parameters: [string(name: 'ami_id', value: "${AMI_ID}")],
                wait: false,
                propagate: false
          } else {
              echo "No user input selected"
          }
        }
      }
    }
}
