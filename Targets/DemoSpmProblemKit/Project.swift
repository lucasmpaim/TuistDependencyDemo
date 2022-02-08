
import ProjectDescription
import ProjectDescriptionHelpers

private let name = "DemoSpmProblemKit"
private let testName = "DemoSpmProblemKitTests"

let project = Project(
    name: name,
    settings: Settings.makeFrameworkSettings(),
    targets: [
        Target.makeFramework(
            name,
            bundleId: "com.demo.\(name)",
            sources: ["Sources/**/*.swift"],
            dependencies: [
                .external(name: "DateHelper"),
            ]
        ),
        Target.makeTests(
            testName,
            appTargetName: name,
            bundleId: "com.demo.\(name).tests",
            sources: ["Tests/**/*.swift"]
        )
    ],
    schemes: Scheme.makeAll(
        appTargetName: .init(stringLiteral: name),
        testTargetName: .init(stringLiteral: testName),
        addRunAction: false
    )
)
