// Shared build logic for every Java module in this build. Each module applies this
// convention plugin from its own build.gradle.kts, which is the modern replacement for
// configuring modules from the root build with allprojects {} / subprojects {}.
//
// Note that nothing here mentions Sonar. The SonarScanner for Gradle is applied once, to
// the root project, and derives its per-module properties (sonar.sources, sonar.tests,
// sonar.java.binaries, sonar.java.libraries, sonar.junit.reportPaths) from the Gradle model
// that this file sets up.

plugins {
    `java-library`
    jacoco
}

repositories {
    mavenCentral()
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}

// Precompiled script plugins do not get the type-safe `libs.` accessors that ordinary build
// scripts do, so the catalog is read through its extension instead.
val libs = extensions.getByType<VersionCatalogsExtension>().named("libs")

dependencies {
    testImplementation(platform(libs.findLibrary("junit-bom").get()))
    testImplementation(libs.findLibrary("junit-jupiter").get())
    testRuntimeOnly(libs.findLibrary("junit-platform-launcher").get())
}

tasks.test {
    useJUnitPlatform()
    finalizedBy(tasks.jacocoTestReport)
}

tasks.jacocoTestReport {
    reports {
        // The scanner reads this task's report location and fills in
        // sonar.coverage.jacoco.xmlReportPaths itself, so enabling the XML report is all
        // that coverage import needs.
        xml.required = true
    }
}
