# Book Store — Swift · MVVM · Clean Architecture

Se usa [Open Library](https://openlibrary.org) para la consulta de libros,


## Requisitos previos

- Se enjecutó en xcode 27
- Ruby 3.2.10 (fijado en `.ruby-version`)

CocoaPods y fastlane se instalan desde el `Gemfile`, no globalmente, para que
todos usen la misma versión.

## Pasos para ejecutar el proyecto

```bash
git clone https://github.com/wilvermunozm/book-store-swift-mvvm.git
git checkout develop
bundle install
bundle exec pod install
open BookStoreSwiftMVVM.xcworkspace
```

> Recordar que es un proyecto basado en Cocoapod con lo cual abrir siempre el **`.xcworkspace`**, no el `.xcodeproj`. 


## Arquitectura

MVVM con principios de Clean Architecture. Las dependencias apuntan siempre
hacia el dominio: `Presentation → Domain ← Data`.

```
BookStoreSwiftMVVM/
├── App/                          Composition root (DI)
│   ├── AppContainer.swift
│   └── FeatureContainers/
├── Core/
│   ├── DesignSytem/              Componentes de UI reutilizables
│   └── Resource/
└── Features/Store/
    ├── Domain/
    │   ├── Entities/             Book, CartItem
    │   ├── RepositoryTypes/      Protocolos (la frontera)
    │   └── UseCases/
    ├── Data/
    │   ├── DTO/                  Respuesta de red → dominio
    │   ├── Persistence/          Modelos SwiftData
    │   ├── Pricing/
    │   └── Repositories/         Implementaciones
    └── Presentation/             Home · Detail · Favorites · Cart
```

Los protocolos de repositorio viven en **Domain**, no en Data: el dominio
declara lo que necesita y la capa de datos se adapta. Eso es lo que invierte la
dependencia y permite que Domain no conozca ni la red ni SwiftData.

### Inyección de dependencias

No se usa ninguna librería de DI. `AppContainer` es el único punto donde se
nombran tipos concretos; el resto de la app depende de protocolos.

```
AppContainer  →  StoreContainer  →  makeHomeViewModel()
                                    makeFavoritesViewModel()
                                    makeCartViewModel()
```

### Estado de pantalla

Cada pantalla expone un único `enum` de estado (`loading` / `loaded` / `empty`
/ `error`) en lugar de varios booleanos sueltos, de modo que los estados
contradictorios no son representables.

## Persistencia

Los favoritos se guardan con **SwiftData** (`FavoriteBookEntity`), detrás de
`FavoritesRepositoryType`. Se persiste el libro completo, no solo su id, para
que la pantalla de Favoritos funcione sin conexión.

### Precios
Se usa una urilidad propia para generarlos en base a su key, la api no regresa un precio

## Dependencias

Se integran con **CocoaPods**, según lo pedido en el enunciado. En un proyecto
nuevo hoy usaría SPM: CocoaPods está en modo mantenimiento desde 2024 y SPM es
la herramienta nativa.

Kingfisher lo usé para aprovechar los beneficios de pre-fetch y consistencia del scroll en listados de imagenes.

## XCFramework

La capa de networking está encapsulada en `BookStoreNetworking.xcframework`,
un binario universal (dispositivo + simulador) distribuido mediante un
`podspec` local.

-Se encuentra en la carpeta Frameworks del repo


### Regenerar el binario del xcframework

```bash
./scripts/build-xcframework.sh
```

## Automatización (fastlane)

```bash
bundle exec fastlane lanes      # lista las lanes disponibles
```
-tests
-framework_tests
-build_framework
-build
-ci



## Pendientes

Con un poco más de tiempo me hubiese gustado implementar

- un DesignSystem real con componentes y Tokens
- Localización para los textos de cara al usuario
- buena covertura de test unitarios almenos testeando bien Vms, Usecases y repos
- Un sistema de navegación más robusto, tal vez coordinators o algo por el estilo
- Error handler central para integración de observabilidad
--schemas para el soporte de ambientes y configuraciones
-aunque en este requierimiento no tengo datos tan sencibles almenos haber manejado la url del backend de una manera más segura


## Resumen

Traté de reproducir lo que podría ser una arquitectura base para un proyecto robusto implementando como se solicitó -principios de Arquitectura limpia(Data,Domain,Presentation) por cada feature, 
-MVVM, 
-Aalgo de modularidad(Core/Features + Xcframework para networking), 
-La base para testing y algunos tests de muestra, 
-Injección de dependencias propias con container por feature y sin dependencia de terceros
