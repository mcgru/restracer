pipeline {
    agent { docker {
        image 'debian/buster'
        args '-u root'
        }
    }
    stages {
        stage('build') {
            steps {
                sh 'printenv'
                sh 'echo deb http://debian.randoman.ru/debian/ buster main contrib non-free                   > /etc/apt/sources.list'
                sh 'echo deb http://debian.randoman.ru/debian/ buster-proposed-updates main contrib non-free >> /etc/apt/sources.list'
                sh 'echo deb http://debian.randoman.ru/debian/ buster-updates main contrib non-free          >> /etc/apt/sources.list'
                sh 'echo deb http://debian.randoman.ru/debian/ buster-backports main contrib non-free        >> /etc/apt/sources.list'
                sh 'echo deb http://debian.randoman.ru/debian-security buster/updates main contrib non-free  >> /etc/apt/sources.list'
                sh 'apt update && apt install make libxml++2.6-dev g++ -y'
                sh 'make -j$(nproc) release'
                sh '             DESTDIR=/opt/restracer make install'
                sh 'find                 /opt/restracer'
                sh 'tar cf restracer.tar /opt/restracer'
            }
        }
    }
}
