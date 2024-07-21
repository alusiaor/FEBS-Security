pipeline {
    agent any

    parameters {
        string(
                name: 'GIT_REPO',
                defaultValue: '',
                description: 'Git仓库地址' // 输入Git仓库地址
        )
        string(
                name: 'GIT_BRANCH',
                defaultValue: 'master',
                description: 'Git分支' // 输入Git分支
        )
        string(
                name: 'PROJECT_NAME',
                defaultValue: '',
                description: '项目名称' // 输入项目名称
        )
    }

    environment {
        APP_DIR = "/usr/local/soft_build" // 应用目录
        PROJECT_NAME = "${params.PROJECT_NAME}"
        GIT_REPO = "${params.GIT_REPO}" // Git仓库地址
        GIT_BRANCH = "${params.GIT_BRANCH}" // Git分支
    }

    stages {
        stage('Prepare Environment') {
            steps {
                script {
                    log("开始部署   $mavenVersion") // 日志记录

                    if (!fileExists(APP_DIR)) {
                        log("目录不存在，创建目录 $APP_DIR")
                        sh "mkdir -p $APP_DIR" // 创建应用目录
                        exit_on_error("Failed to create directory $APP_DIR")
                    }

                    log("进入到 $APP_DIR 目录中")
                    dir(APP_DIR) {} // 进入应用目录
                }
            }
        }

        stage('Clone or Update Repo') {
            steps {
                script {
                    dir(APP_DIR) {
                        if (!fileExists(PROJECT_NAME)) {
                            log("项目目录不存在，执行 git clone")
                            sh "git clone $GIT_REPO" // 克隆Git仓库
                            exit_on_error("Git clone failed")
                        } else {
                            log("项目目录已存在，进入目录并执行 git pull")
                            dir(PROJECT_NAME) {
                                sh "git pull" // 更新Git仓库
                                exit_on_error("Git pull failed")
                            }
                        }
                    }
                }
            }
        }

        stage('Checkout Branch') {
            steps {
                script {
                    dir("$APP_DIR/$PROJECT_NAME") {
                        log("进入项目根目录")
                        sh "git fetch" // 拉取最新的分支信息
                        sh "git checkout $GIT_BRANCH" // 切换到输入的分支
                        exit_on_error("Failed to checkout branch")
                    }
                }
            }
        }
        stage(' Install And Build Project') {
            steps {
                script {
                    dir("$APP_DIR/$PROJECT_NAME") {
                        log("开始打包模块依赖")
                        sh "mvn clean install" // 使用Maven打包项目
                        exit_on_error("Maven install failed")
                        log("模块依赖打包完成")
                    }

                    dir("$APP_DIR/$PROJECT_NAME/febs-web") {
                        log("开始打包")
                        sh "mvn clean package" // 使用Maven打包项目
                        exit_on_error("Maven build failed")
                        log("打包完成")
                    }

                }
            }
        }

        stage('Start Project') {
            steps {
                script {
                    dir("$APP_DIR/$PROJECT_NAME/febs-web/target") {
                        log("启动")
                        sh "echo `pwd`" // 启动项目
                        exit_on_error("start failed")
                        log("启动完成  ")
                    }

                }
            }
        }

    }

    post {
        always {
            script {
                log("部署结束") // 部署结束的日志
            }
        }
        success {
            script {
                log("构建成功") // 构建成功的日志
            }

        }
        failure {
            script {
                log("构建失败") // 构建失败的日志
            }

        }
    }
}

def log(message) {
    echo "[${new Date().format('yyyy-MM-dd HH:mm:ss')}] ${message}" // 日志记录函数
}

def exit_on_error(message) {
    if (currentBuild.result == 'FAILURE') {
        error(message) // 构建失败时退出并记录错误信息
    }
}
