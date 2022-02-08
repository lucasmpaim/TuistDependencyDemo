import ProjectDescription
import ProjectDescriptionHelpers

let resources: ResourceFileElements = ResourceFileElements(
    arrayLiteral: ResourceFileElement.glob(pattern: "Resources/**/*.*", tags: [])
)

let dependencies: [TargetDependency] = [
    .external(name: "DateHelper"),
    .project(target: "DemoSpmProblemKit", path: .relativeToRoot("Targets/DemoSpmProblemKit")),
    .project(target: "DemoSpmProblemUI", path: .relativeToRoot("Targets/DemoSpmProblemUI")),
]

let project = Project(
    name: "Demo",
    organizationName: "Demo Inc",
    settings: Settings.makeAppSettings(),
    targets: [
        Target.makeApp(
            "DemoApp",
            sources: ["Sources/**/*.swift"],
            resources: resources,
            dependencies: dependencies,
            scripts: [],
            headers: nil,
            plistFile: .default
        ),
        Target.makeTests(
            "AppTests",
            appTargetName: "DemoApp",
            bundleId: "com.demo.tests",
            sources: "Tests/**/*.swift"
        )
    ],
    schemes: Scheme.makeAll(appTargetName: "DemoApp", testTargetName: "AppTests")
)
