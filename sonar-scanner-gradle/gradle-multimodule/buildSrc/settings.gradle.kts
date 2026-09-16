dependencyResolutionManagement {
    // Reuse the main build's version catalog so the convention plugin can declare
    // dependencies from the same single source of versions.
    versionCatalogs {
        create("libs") {
            from(files("../gradle/libs.versions.toml"))
        }
    }
}

rootProject.name = "buildSrc"
