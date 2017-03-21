#!groovy
podTemplate(label: 'image-builder', containers: [
        containerTemplate(name: 'jnlp',
                image: 'henryrao/jnlp-slave',
                args: '${computer.jnlpmac} ${computer.name}',
                alwaysPullImage: true),
        containerTemplate(name: 'docker',
                image: 'docker:1.12.6',
                ttyEnabled: true,
                command: 'cat'),
],
        volumes: [
                hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
        ]
) {
    properties([
            pipelineTriggers([]),
            parameters([
                    string(name: 'imageRepo', defaultValue: 'henryrao/sbt', description: 'Name of Image' ),
                    string(name: 'scalaVer', defaultValue: '211', description: 'Scala Version' )
            ]),
    ])

    node('image-builder') {

        checkout scm
        def imgSha = ''
        container('docker') {

            stage('build') {
                imgSha = sh(returnStdout: true, script: "docker build --pull --build-arg scalaVer=${params.scalaVer} -q .").trim()[7..-1]
                echo "${imgSha}"
            }

            stage('test') {
                sh "docker run -w /tmp/test1 ${imgSha} sbt -sbt-create -v -${params.scalaVer} sbtVersion"
            }

            stage('deploy') {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                    sh "docker login -u $USERNAME -p $PASSWORD"
                    sh "docker tag ${imgSha} ${params.imageRepo}:${params.scalaVer}"
                    sh "docker push ${params.imageRepo}:${params.scalaVer}"
                }
            }
        }
    }
}
