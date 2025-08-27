plugins {
    jacoco
    id("org.sonarqube") version "6.2.0.5505"
    kotlin("jvm") version "2.2.0"
}

group = "org.example"
version = "1.0-SNAPSHOT"

sonar {
    properties {
        property("sonar.projectKey", "gradle-kotlin-example")
        property("sonar.projectName", "Example of Kotlin project built with Gradle")
    }
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(21)
}

tasks.jacocoTestReport {
    reports {
        xml.required.set(true)
        html.required.set(true)
    }
}
