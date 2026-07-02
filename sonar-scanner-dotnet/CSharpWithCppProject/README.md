# CSharpWithCppProject

Dummy scaffold with a .NET console app (`CSharpProject/`) and a C++ library
(`CppProject/`), both listed as subprojects of `CSharpWithCppProject.sln`, set
up so both can be analyzed by SonarQube.

`CppProject` is represented in the solution by `CppProject/CppProject.csproj`, a
plain MSBuild project (no C# sources — `EnableDefaultCompileItems` is off)
whose `Build` target shells out to CMake (`cmake -S . -B build` then
`cmake --build build`) via `<Exec>`, and whose `Clean` target removes the
CMake `build/` directory. Because it's a real, dotnet-CLI-buildable project
referenced from `CSharpWithCppProject.sln` with `Build.0` mappings, `dotnet
build` compiles both the C# app and the C++ library in one invocation — no
separate CMake step needed.

## Build

```sh
dotnet build CSharpWithCppProject.sln
```

This builds `CSharpProject` (C#) and drives the CMake configure/build for
`CppProject` (C++), producing `CppProject/build/libcppproject.so`. Re-running
skips the CMake configure step if `CppProject/build/CMakeCache.txt` already
exists, so incremental builds stay fast.

```sh
dotnet clean CSharpWithCppProject.sln
```

removes `bin/`/`obj/` for both projects and deletes `CppProject/build/`.

## Run the C# app

```sh
dotnet run --project CSharpProject
```

## SonarQube analysis

Requires `dotnet-sonarscanner` (`dotnet tool install --global dotnet-sonarscanner`)
to be installed separately — not provided by this repo.

The Scanner for .NET does not read `sonar-project.properties` (it fails the
analysis if one is present) — all settings are passed as `/d:` properties on
`begin` instead. It also ignores the `sonar.sources`/`sonar.tests` properties
entirely (they're ["automatically computed based on your
repository"](https://community.sonarsource.com/t/sonar-sources-and-sonar-tests-properties-not-supported/) —
a solution "module" is added per project in `CSharpWithCppProject.sln`, so both
`CSharpProject` and `CppProject`'s directories are indexed automatically;
nothing needs to be passed explicitly for either).

C++ analysis needs to see the compiler invocations used to build `CppProject`.
Rather than the `build-wrapper-linux-x86-64` capture approach,
`CppProject/CMakeLists.txt` already sets `CMAKE_EXPORT_COMPILE_COMMANDS ON`, so
CMake itself produces `CppProject/build/compile_commands.json` as a normal
build artifact — point `sonar.cfamily.compile-commands` at it directly and
skip the build-wrapper dependency entirely:

```sh
# Force a clean CMake configure/build so compile_commands.json is fresh
rm -rf CppProject/build

dotnet sonarscanner begin \
  /k:"csharp-with-cpp" \
  /d:sonar.host.url="http://localhost:9000" \
  /d:sonar.token="$SQS_TOKEN" \
  /d:sonar.exclusions="**/bin/**,**/obj/**,**/build/**" \
  /d:sonar.cfamily.compile-commands="CppProject/build/compile_commands.json"

dotnet build CSharpWithCppProject.sln

dotnet sonarscanner end /d:sonar.token="$SQS_TOKEN"
```

Adjust `sonar.host.url` and the token/login argument for your SonarQube
server.
