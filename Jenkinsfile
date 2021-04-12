podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'ipacker',image: 'senthilreddy/anpm:latest', ttyEnabled: true, command: 'cat')
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
    
      stage('RunAWSCMD') {
        container('ipacker') {
          withCredentials([usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]){
            backend_url=sh(script:'aws elbv2 describe-load-balancers --region ap-south-1 | jq \'.LoadBalancers[] | select(.LoadBalancerName== "pet-be") | .DNSName\'',returnStdout: true)
            sh "pwd"
            sh "ls -la"
            sh "npm install -g @angular/cli@latest"
            sh "mkdir dist"
            sh "packer build -var \"backend_url=${backend_url}\" ./packer.json"
            sh "echo ${backend_url}"
          }

        }
      }
        // stage('packer Build') {
        // container('ipacker') {
        //   withCredentials([usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]){
        //     sh "pwd"
        //     sh "ls -la"
        //     sh "packer build -var 'backend_url=${backend_url}' ./packer.json "
        //     // sh "echo ${be_lb_dns}"
        //   }
        //     }
        // }
        // stage('npm Build') {
        //     container('node') {
        //         script {
        //             sh """
        //             //  npm install
        //             //  npm install -g @angular/cli
        //             //  sed -i -- 's#'"http://localhost:9966/petclinic/api/"'#'"${be_lb_dns}"'#g' ./src/environments/environment.prod.ts
        //             //  cat ./src/environments/environment.prod.ts
        //              ng build --prod --base-href=/ --deploy-url=/
        //                """
        //         }
        //     }
        // }
    }
}
