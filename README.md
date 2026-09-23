# Book Store — Swift · MVVM · Clean Architecture

App iOS que lista libros de la API pública de [Open Library](https://openlibrary.org)
y permite ver el detalle de cada uno.

## Requisitos previos

- Xcode 27
- CocoaPods 1.16+

## Puesta en marcha

```bash
pod install
open BookStoreSwiftMVVM.xcworkspace
```

> Abre siempre el **`.xcworkspace`**, no el `.xcodeproj`. El proyecto usa
> CocoaPods y el `.xcodeproj` por sí solo no encuentra las dependencias.

## Arquitectura

MVVM con principios de Clean Architecture. Las dependencias apuntan siempre
hacia el dominio: `Presentation → Domain ← Data`.

```
BookStoreSwiftMVVM/
├── App/                      Composition root (DI)
│   ├── AppContainer.swift
│   └── FeatureContainers/
├── Core/
│   ├── DesignSytem/          Componentes de UI reutilizables
│   └── Resource/
└── Features/Store/
    ├── Domain/               Entidades, protocolos de repositorio, casos de uso
    ├── Data/                 DTOs e implementación de repositorios
    └── Presentation/         Vistas y ViewModels
```

### Inyección de dependencias

No se usa ninguna librería de DI. `AppContainer` es el único punto donde se
nombran tipos concretos; el resto de la app depende de protocolos.

```
AppContainer  →  StoreContainer  →  makeViewModel()
```

Los ViewModels se inyectan por constructor, lo que permite sustituir el
repositorio por un doble en tests y previews.

### Estado de pantalla

Cada pantalla expone un único `enum` de estado (`loading` / `loaded` / `empty`
/ `error`) en lugar de varios booleanos sueltos, de modo que los estados
contradictorios no son representables.

## Dependencias

| Dependencia | Uso |
|---|---|
| [Kingfisher](https://github.com/onevcat/Kingfisher) 8.x | Carga y caché de portadas |
| `BookStoreNetworking` | XCFramework propio con la capa de red |

Se integran con **CocoaPods**, según lo pedido en el enunciado. En un proyecto
nuevo hoy usaría SPM: CocoaPods está en modo mantenimiento desde 2024 y SPM es
la herramienta nativa.

## XCFramework

La capa de networking está encapsulada en `BookStoreNetworking.xcframework`,
un binario universal (dispositivo + simulador) distribuido mediante un
`podspec` local.

El cliente HTTP es **genérico y agnóstico del dominio** — no conoce `Book` ni
ningún DTO de la app:

```swift
public func get<T: Decodable>(_ url: URL) async throws -> T
```

El mapeo de JSON a entidades de dominio se queda en la capa `Data` de la app,
que es donde corresponde.

### Regenerar el binario

```bash
./scripts/build-xcframework.sh
```

El script archiva para ambas plataformas y las combina. Usa dos ajustes
imprescindibles:

- `BUILD_LIBRARY_FOR_DISTRIBUTION=YES` — genera el `.swiftinterface`, necesario
  para la estabilidad de módulo.
- `SKIP_INSTALL=NO` — sin esto el archive no incluye el framework y el paso de
  combinación falla.

El `.xcframework` se versiona en el repositorio para que el proyecto compile
tras un `pod install`, sin tener que regenerarlo.

## Tests

```bash
xcodebuild test -workspace BookStoreSwiftMVVM.xcworkspace \
  -scheme BookStoreSwiftMVVM \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

| Suite | Cubre |
|---|---|
| `HomeViewModelTests` | Los cuatro estados de la pantalla principal |
| `BooksResponseDTOTests` | Mapeo DTO → dominio, incluida la construcción de URLs de portada |

Los tests sustituyen el repositorio por un stub, de modo que el caso de uso y
el ViewModel reales se ejecutan sin tocar la red. La suite completa corre en
milisegundos.

### Tests del XCFramework

```bash
xcodebuild test \
  -project Frameworks/BookStoreNetworking/BookStoreNetworking.xcodeproj \
  -scheme BookStoreNetworking \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

`RestServiceTests` cubre el cliente HTTP con un `URLProtocol` simulado: cuerpo
decodificado correctamente, rangos de estado de éxito y de error, fallo de
decodificación y errores de transporte. No se hace ninguna petición real.

Para permitirlo, `RestService` recibe la `URLSession` por constructor
(`init(session: .shared)`), que es la costura por la que entra el mock.

## Ajustes del proyecto que requieren explicación

Ambos son consecuencia de usar CocoaPods con Xcode 27:

- **`objectVersion = 77`** — Xcode 27 guarda los proyectos con formato `110`,
  que la gema `xcodeproj` de CocoaPods todavía no soporta (llega hasta 100).
  Se bajó el formato para poder integrar dependencias.
- **`ENABLE_USER_SCRIPT_SANDBOXING = NO`** — el sandboxing de scripts de
  Xcode 15+ bloquea el `rsync` con el que CocoaPods copia los frameworks.

## Pendiente

- Las portadas del detalle usan el tamaño `-M` de la API estirado a 180 pt, por
  lo que se pixelan. La mejora sería modelar la portada con sus dos tamaños
  (`thumbnail` y `large`) y pedir `-L` en el detalle.
