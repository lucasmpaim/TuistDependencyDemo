
import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(url: "https://github.com/melvitax/DateHelper", requirement: .exact("4.4.1")),
        ],
        baseSettings: Settings.settings(
            configurations: [
                .debug(name: "Prod-Debug"),
                .debug(name: "QA-Debug"),
                .debug(name: "Debug"),
                .release(name: "Prod-Release"),
                .release(name: "QA-Release"),
                .release(name: "Release")
            ]
        )
    ),
    platforms: [.iOS]
)
