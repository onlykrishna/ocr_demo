buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.9.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.24")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}

subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureSdk = {
        val android = extensions.findByName("android")
        if (android != null) {
            try {
                android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType).invoke(android, 34)
            } catch (e1: Exception) {
                try {
                    android.javaClass.getMethod("compileSdkVersion", String::class.java).invoke(android, "android-34")
                } catch (e2: Exception) {}
            }
        }
    }
    if (state.executed) {
        configureSdk()
    } else {
        afterEvaluate { configureSdk() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}