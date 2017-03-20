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
        ],
        workspaceVolume: persistentVolumeClaimWorkspaceVolume(claimName: 'jenkins-workspace', readOnly: false)
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
                imgSha = sh(returnStdout: true, script: "docker build --pull .").trim()[7..-1]
                echo "${imgSha}"
            }

            stage('test') {
                echo "${imgSha}"
            }

            stage('deploy') {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                    sh "docker login -u $USERNAME -p $PASSWORD"
                    sh "docker tag ${imgSha} ${params.imageRepo}:211"
                    sh "docker push ${params.imageRepo}"
                }
            }
        }
    }
}
