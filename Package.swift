// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "TokenEx",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TokenExMobileAPI",
            targets: ["TokenExMobileAPI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "TokenExMobileAPI",
            path: "TokenExMobileAPI/TokenExMobileAPI",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "TokenExMobileAPITests",
            dependencies: ["TokenExMobileAPI", "Nimble"],
            path: "TokenExMobileAPI/TokenExMobileAPITests"
        ),
    ]
)
