allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id "com.android.application" version "7.3.0" apply false
    id "com.android.library" version "7.3.0" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
    id "org.jetbrains.kotlin.android" version "1.7.10" apply false
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}