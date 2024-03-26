import java.io.ByteArrayOutputStream
import java.io.FileOutputStream
import java.io.OutputStream

plugins {
    jacoco
    `java-library`
    id("org.flywaydb.flyway") version "9.20.0"
    id("org.sonarqube") version "5.0.0.4638"
    id("org.gradle.maven-publish") // Noncompliant - kotlin:S6634 Core plugins IDs should be replaced by their shortcuts
}

version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
    maven {
        url = uri("https://maven.springframework.org/release")
    }
}

sourceSets {
    create("integrationTest") {
        compileClasspath += sourceSets.main.get().output
        runtimeClasspath += sourceSets.main.get().output
    }
}

sonar {
    properties {
        property("sonar.projectKey", "baeldung-gradle-kotlin-dsl")
        property("sonar.projectName", "Example of Gradle Project with Kotlin DSL")
    }
}

val integrationTestImplementation: Configuration by configurations.getting {
    extendsFrom(configurations.implementation.get())
    extendsFrom(configurations.testImplementation.get())
}

val integrationTestRuntimeOnly: Configuration by configurations.getting {
    extendsFrom(configurations.implementation.get())
    extendsFrom(configurations.testRuntimeOnly.get())
}

val integrationTest = task<Test>("integrationTest") {
    useJUnitPlatform()
    description = "Task to run integration tests"
    group = "verification"

    testClassesDirs = sourceSets["integrationTest"].output.classesDirs
    classpath = sourceSets["integrationTest"].runtimeClasspath
    shouldRunAfter("test")
}

tasks.check { dependsOn(integrationTest) }

dependencies {
    api("com.google.inject:guice:7.0.0")
    testImplementation("org.mockito:mockito-core:5.4.0")
    implementation("com.google.guava:guava:32.1.0-jre")
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.9.3")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine")
}

tasks.getByName<Test>("test") {
    useJUnitPlatform()
}

// Noncompliant - kotlin:S6623 "tasks.register()" should be preferred over "tasks.create()"
tasks.create("dummyTaskThatI'llDoLater") {
    group = JavaBasePlugin.DOCUMENTATION_GROUP
    description = "My task."
    // other configuration logic

    doLast {
        // ...
    }
}

tasks.register("helloUserCmd") {
    val user: String? = System.getenv("USER")
    project.exec {
        commandLine("echo", "Hello,", "$user!")
    }
}

tasks.register("helloUserInVarCmd") {
    val outputStream = ByteArrayOutputStream()
    val user: String? = System.getenv("USER")
    project.exec {
        standardOutput = outputStream
        commandLine("echo", "Hello,", "$user!")
    }
    val output = outputStream.toString().trim()
    println("Command output: $output")
}

tasks.register("tmpFilesCmd") {
    val outputFile = File("/tmp/output.txt")
    val outputStream: OutputStream = FileOutputStream(outputFile)
    project.exec {
        standardOutput = outputStream
        workingDir = project.file("/tmp")
        commandLine("ls", workingDir)
    }
}

tasks.register("alwaysFailCmd") {
    val result = project.exec {
        commandLine("ls", "invalid_path")
        isIgnoreExitValue = true
    }
    if (result.exitValue == 0) {
        println("Command executed successfully.")
    } else {
        println("Command execution failed.")
        println("Command status: $result")
    }
}

jacoco {
    toolVersion = "0.8.10"
}
tasks.jacocoTestReport {
    reports {
        xml.required.set(true)
        html.required.set(true)
    }
}
