fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Ejecuta la suite de tests de la app

### ios framework_tests

```sh
[bundle exec] fastlane ios framework_tests
```

Ejecuta la suite de tests del XCFramework de networking

### ios build_framework

```sh
[bundle exec] fastlane ios build_framework
```

Regenera BookStoreNetworking.xcframework

### ios build

```sh
[bundle exec] fastlane ios build
```

Compila la app sin firmar, para validar que el proyecto integra bien

### ios ci

```sh
[bundle exec] fastlane ios ci
```

Todo lo que deberia pasar antes de integrar: pods, framework y ambas suites

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
