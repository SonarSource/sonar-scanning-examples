pluginManagement {
    // Build logic lives in the `build-logic` composite build rather than `buildSrc`, which is
    // the layout Gradle recommends (see "Favor build-logic Composite Builds for Build Logic"
    // in the Gradle best practices). Because the modules apply the convention plugin by id in
    // their `plugins {}` block, the included build has to be wired here, inside
    // pluginManagement, so the precompiled script plugin is resolvable as a plugin. A bare
    // top-level includeBuild only substitutes dependencies and would not expose the plugin.
    includeBuild("build-logic")
}

plugins {
    // Downloads a matching JDK when the toolchain requested in build-logic is not installed,
    // so the example builds on a machine with any reasonably recent JDK.
    id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"
}

rootProject.name = "gradle-multimodule"

include("module-one")
include("module-two")
