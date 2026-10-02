// The root project builds nothing itself; it only hosts the analysis. Per the SonarScanner
// for Gradle documentation, the plugin is applied to the root project of the hierarchy and
// picks up the subprojects on its own - it must not be applied to each module.
plugins {
    id("org.sonarqube") version "latest.release"
}

// Properties that describe the analysis as a whole belong here. Everything that varies per
// module is derived from the Gradle model by the scanner, so there is nothing else to set.
sonar {
    properties {
        property("sonar.projectName", "Example of SonarScanner for Gradle - Multimodule")
        property("sonar.projectKey", "org.sonarqube:gradle-multimodule")
    }
}
