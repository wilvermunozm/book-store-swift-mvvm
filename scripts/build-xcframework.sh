#!/bin/bash
#
# Genera BookStoreNetworking.xcframework a partir del proyecto del framework.
#
# Uso:  ./scripts/build-xcframework.sh
#
# Produce un binario universal (dispositivo + simulador) en Frameworks/.
# Requiere BUILD_LIBRARY_FOR_DISTRIBUTION para la estabilidad de modulo
# y SKIP_INSTALL=NO para que el archive incluya el framework.

set -euo pipefail

FRAMEWORK_NAME="BookStoreNetworking"
PROJECT="Frameworks/${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.xcodeproj"
BUILD_DIR="build"
OUTPUT="Frameworks/${FRAMEWORK_NAME}.xcframework"

cd "$(dirname "$0")/.."

echo "==> Limpiando artefactos previos"
rm -rf "${BUILD_DIR}" "${OUTPUT}"

archive() {
  local destination="$1"
  local path="$2"

  echo "==> Archivando para ${destination}"
  xcodebuild archive \
    -project "${PROJECT}" \
    -scheme "${FRAMEWORK_NAME}" \
    -destination "${destination}" \
    -archivePath "${path}" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    -quiet
}

archive "generic/platform=iOS"           "${BUILD_DIR}/ios.xcarchive"
archive "generic/platform=iOS Simulator" "${BUILD_DIR}/ios-sim.xcarchive"

echo "==> Combinando en XCFramework"
xcodebuild -create-xcframework \
  -framework "${BUILD_DIR}/ios.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "${BUILD_DIR}/ios-sim.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -output "${OUTPUT}"

rm -rf "${BUILD_DIR}"

echo "==> Listo: ${OUTPUT}"
