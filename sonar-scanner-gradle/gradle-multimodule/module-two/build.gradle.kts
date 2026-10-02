plugins {
    id("buildlogic.java-conventions")
}

dependencies {
    // A dependency between modules, so the analysis of module-two has to resolve
    // module-one's classes on its sonar.java.libraries classpath. `api` because `One`
    // appears in Two's public constructor signature.
    api(project(":module-one"))
}
