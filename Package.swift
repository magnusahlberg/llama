import PackageDescription

let package = Package(
    name: "swog",
    dependencies: [
         .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 32),
         .Package(url: "https://github.com/chriseidhof/commonmark-swift", Version(0,24,1))
    ]
)
