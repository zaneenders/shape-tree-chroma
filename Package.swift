// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "shape-tree-chroma",
  dependencies: [
    .package(path: "../swift-wayland/"),
    .package(path: "../shape-tree/"),
    .package(url: "https://github.com/apple/swift-log", from: "1.6.0"),
    .package(url: "https://github.com/apple/swift-configuration", from: "1.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "ShapeTreeChroma",
      dependencies: [
        .product(name: "Wayland", package: "swift-wayland"),
        .product(name: "ShapeTreeShared", package: "shape-tree"),
        .product(name: "Configuration", package: "swift-configuration"),
        .product(name: "Logging", package: "swift-log"),
      ]
    )
  ]
)
