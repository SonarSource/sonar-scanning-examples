plugins {
    // Downloads a matching JDK when the toolchain requested in buildSrc is not installed,
    // so the example builds on a machine with any reasonably recent JDK.
    id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"
}

rootProject.name = "gradle-multimodule"

include("module-one")
include("module-two")
