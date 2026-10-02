plugins {
    // Lets us write the convention plugins in src/main/kotlin as precompiled script plugins.
    `kotlin-dsl`
}

repositories {
    // Use the plugin portal to apply community plugins in convention plugins.
    gradlePluginPortal()
}
