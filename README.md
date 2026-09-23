# Book Store

App iOS que lista libros desde [Open Library](https://openlibrary.org), permite
marcarlos como favoritos y agregarlos a un carrito.

## Requisitos

- Xcode 27
- Ruby 3.2.10 (fijado en `.ruby-version`)

CocoaPods y fastlane se instalan desde el `Gemfile` para que todos usen la misma
versión.

## Ejecutar

```bash
git clone https://github.com/wilvermunozm/book-store-swift-mvvm.git
git checkout develop
bundle install
bundle exec pod install
open BookStoreSwiftMVVM.xcworkspace
```

Abrir el `.xcworkspace`, no el `.xcodeproj`.


## Estructura

```
BookStoreSwiftMVVM/
├── App/                    Composition root (DI)
├── Core/DesignSytem/       Componentes de UI reutilizables
└── Features/Store/
    ├── Domain/             Entities, RepositoryTypes, UseCases
    ├── Data/               DTO, Persistence, Pricing, Repositories
    └── Presentation/       Home, Detail, Favorites, Cart
```


## Clean Architecture

La regla que se siguió es la de dependencias: las capas externas conocen a las
internas, nunca al revés. Se puede verificar mirando los imports de cada capa.

- Domain solo importa `Foundation`. No conoce SwiftUI, ni SwiftData, ni la red.
- Data importa `SwiftData` y `BookStoreNetworking`, que son los detalles.
- Presentation importa `SwiftUI` y `Observation`.

La pieza que hace posible la inversión son los protocolos de repositorio
(`BookRepositoryType`, `FavoritesRepositoryType`, `CartRepositoryType`), que
viven en Domain y no en Data. El dominio declara lo que necesita y la capa de
datos se adapta. Por eso cambiar SwiftData por otra cosa, o la API remota por
otra, no obliga a tocar casos de uso ni ViewModels.

Hay tres modelos distintos para el mismo concepto, con mapeo explícito entre
ellos: `BookDTO` (respuesta de la API), `Book` (entidad de dominio) y
`FavoriteBookEntity` (modelo de SwiftData). Cuesta un poco más de código, pero
evita que un cambio en el JSON de Open Library se propague a la base de datos o
a las vistas.

Los casos de uso son la capa más discutible. De los siete que hay, solo
`ToggleFavoriteUseCase` tiene lógica propia — consulta el estado actual y decide
si agrega o quita. El resto delega en una línea al repositorio. Se mantuvieron
por uniformidad y porque son el sitio natural donde crecería la lógica de
negocio, pero hoy la mayoría no aporta nada por sí misma.

## MVVM

Cada pantalla tiene un ViewModel `@Observable` que expone estado de solo lectura
(`private(set)`) y métodos para las acciones. La vista lee y llama; nunca
escribe estado directamente. Eso lo garantiza el compilador, no la disciplina.

El estado de carga es un `enum` con cuatro casos (`loading`, `loaded`, `empty`,
`error`) en lugar de booleanos sueltos, así que no se pueden representar
combinaciones contradictorias.

Los errores de acciones puntuales van en una propiedad aparte (`actionError`) y
se muestran como alerta. Al principio se usaba el mismo `state`, pero eso hacía
que un fallo al agregar al carrito borrara toda la lista de libros de la
pantalla.

La única excepción a MVVM es `DetailScreen`, que no tiene ViewModel: recibe el
libro, si es favorito y las acciones como closures. Se hizo así para no duplicar
la fuente de verdad de los favoritos entre dos ViewModels.

## Inyección de dependencias

Sin librerías. `AppContainer` es el único lugar donde se nombran tipos
concretos; el resto de la app depende de protocolos.

```
AppContainer → StoreContainer → makeHomeViewModel()
                                makeFavoritesViewModel()
                                makeCartViewModel()
```

Dentro de los containers la forma de declarar cada dependencia define su ciclo
de vida: `private let` para lo que debe compartirse con estado (el
`ModelContainer` de SwiftData, el repositorio del carrito), propiedades
computadas para los casos de uso que no tienen estado, y funciones `make…()`
para los ViewModels, que siempre se crean nuevos.

Los ViewModels se inyectan por constructor, sin valores por defecto. Eso obliga
a que el cableado ocurra en un solo sitio y permite sustituir cualquier
repositorio por un doble en tests.

## Decisiones puntuales

**Persistencia.** Favoritos con SwiftData, detrás de su protocolo. Se guarda el
libro completo y no solo el id para que la pantalla funcione sin conexión. No se
usa `@Query` en las vistas a propósito: metería el modelo de persistencia dentro
de la UI y dejaría sin sentido al ViewModel.

**Carrito en memoria.** Según el enunciado, solo dura la sesión
(`InMemoryCartRepository`). Como implementa el mismo protocolo, agregarle
persistencia sería sustituir esa clase sin tocar nada más.

**Precios.** La API no devuelve precios. `BookPricing` genera uno determinista a
partir de la clave del libro, para que el mismo libro cueste siempre lo mismo.
Los montos usan `Decimal` y no `Double`, porque la aritmética binaria acumula
error al sumar dinero.

**XCFramework.** La capa de red está encapsulada en
`BookStoreNetworking.xcframework`, distribuido con un podspec local. El cliente
HTTP es genérico (`get<T: Decodable>`) y no conoce `Book` ni ningún DTO: el
mapeo a dominio se queda en la app. Se regenera con
`./scripts/build-xcframework.sh`.

**Dependencias con CocoaPods** según el enunciado. En un proyecto nuevo hoy
usaría SPM, que es la herramienta nativa. Kingfisher se eligió por el prefetch y
la consistencia del scroll en listas de imágenes.

## Tests

```bash
bundle exec fastlane tests             # app
bundle exec fastlane framework_tests   # XCFramework
```

- `HomeViewModelTests` — los cuatro estados de la pantalla principal.
- `BooksResponseDTOTests` — mapeo DTO a dominio y construcción de URLs de portada.
- `RestServiceTests` — cliente HTTP con `URLProtocol` simulado, sin red real.

Los tests sustituyen los repositorios por dobles en memoria, así que los casos
de uso y los ViewModels reales sí se ejecutan. La suite corre en milisegundos.

Los resultados quedan en un `.xcresult` en `fastlane/test_output`, no en JUnit:
`xcpretty` no sabe leer Swift Testing y genera un informe vacío.

## Automatización

`bundle exec fastlane lanes` lista las disponibles: `tests`, `framework_tests`,
`build_framework`, `build` y `ci` (pod install más ambas suites).

## Ajustes del proyecto

Tres ajustes que no son arbitrarios:

- `ENABLE_OUTGOING_NETWORK_CONNECTIONS = YES` — Xcode 26+ activa App Sandbox por
  defecto y sin este permiso las conexiones salientes fallan con un error TLS.
- `objectVersion = 77` — Xcode 27 guarda los proyectos en formato 110, que la
  gema `xcodeproj` de CocoaPods todavía no soporta.
- `ENABLE_USER_SCRIPT_SANDBOXING = NO` — bloquea el script con el que CocoaPods
  copia los frameworks.

## Pendientes

- Los ViewModels de cada pestaña consultan su repositorio por separado, así que
  un cambio en una no refresca las otras hasta que se recargan. Se resolvería
  con un observable compartido por encima de los repositorios.
- La portada del detalle usa el tamaño `-M` de la API estirado a 180 pt y se
  pixela. Habría que modelar la portada con sus dos tamaños.
