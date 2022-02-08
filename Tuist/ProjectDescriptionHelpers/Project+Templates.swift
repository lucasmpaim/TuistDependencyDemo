import ProjectDescription


extension Configuration {
    fileprivate static func prod() -> [Configuration] {
        return [
            .debug(name: "Prod-Debug", xcconfig: .relativeToRoot("Config/prod_config.xcconfig")),
            .release(name: "Prod-Release", xcconfig: .relativeToRoot("Config/prod_config.xcconfig"))
        ]
    }

    fileprivate static func qa() -> [Configuration] {
        return [
            .debug(name: "QA-Debug", xcconfig: .relativeToRoot("Config/qa_config.xcconfig")),
            .release(name: "QA-Release", xcconfig: .relativeToRoot("Config/qa_config.xcconfig"))
        ]
    }

    fileprivate static func dev() -> [Configuration] {
        return [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Config/dev_config.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Config/dev_config.xcconfig"))
        ]
    }
}

public extension Settings {
    
    static func makeAppSettings() -> Settings {
        let base: SettingsDictionary = [
            "EMBEDDED_CONTENT_CONTAINS_SWIFT": true
        ]
        return Settings.settings(
            base: base,
            configurations: Configuration.dev() + Configuration.qa() + Configuration.prod()
        )
    }
    
    static var test: Settings {
        let base: SettingsDictionary = [
            "BUNDLER_LOADER": "$(BUILT_PRODUCTS_DIR)/$(PRODUCT_NAME).app/"
        ]
        return Settings.settings(base: base, configurations: Configuration.dev())
    }
    
    static func makeFrameworkSettings() -> Settings {
        let base: SettingsDictionary = [
            "EMBEDDED_CONTENT_CONTAINS_SWIFT": false
        ]
        return Settings.settings(
            base: base,
            configurations: Configuration.dev() + Configuration.qa() + Configuration.prod()
        )
    }
    
}

public extension RunAction {
    static func make(
        for config: String,
        executable: TargetReference
    ) -> RunAction {
        return RunAction.runAction(
            configuration: .configuration(config),
            executable: executable,
            arguments: nil,
            options: .options(language: "pt-BR")
        )
    }
}


public extension Scheme {
    static func make(
        configName: String,
        appTarget: TargetReference,
        testActionName: TargetReference? = nil,
        addRunAction: Bool = true
    ) -> Scheme {
        return .init(
            name: "\(appTarget.targetName)-\(configName)",
            shared: true,
            buildAction: .init(targets: [appTarget]),
            testAction: testActionName != nil ? .targets(
                [
                    .init(target: testActionName!),
                ],
                options: .options(
                    language: "pt-BR",
                    region: "BR",
                    coverage: true,
                    codeCoverageTargets: [appTarget]
                )
            ) : nil,
            runAction: addRunAction ? RunAction.make(for: configName, executable: appTarget) : nil,
            archiveAction: nil,
            profileAction: nil,
            analyzeAction: nil
        )
    }
    
    static func makeAll(
        appTargetName: TargetReference,
        testTargetName: TargetReference?,
        addRunAction: Bool = true
    ) -> [Scheme] {
        [
            Scheme.make(configName: "Debug", appTarget: appTargetName, testActionName: testTargetName, addRunAction: addRunAction),
            Scheme.make(configName: "QA-Debug", appTarget: appTargetName, addRunAction: addRunAction),
            Scheme.make(configName: "Prod-Debug", appTarget: appTargetName, addRunAction: addRunAction),
            Scheme.make(configName: "Release", appTarget: appTargetName, addRunAction: addRunAction),
            Scheme.make(configName: "QA-Release", appTarget: appTargetName, addRunAction: addRunAction),
            Scheme.make(configName: "Prod-Release", appTarget: appTargetName, addRunAction: addRunAction)
        ]
    }
    
}



public extension Target {
    static func makeApp(
        _ name: String,
        sources: SourceFilesList,
        resources: ResourceFileElements,
        dependencies: [TargetDependency] = [],
        bundleId: String = "${PRODUCT_BUNDLE_IDENTIFIER}",
        scripts: [ProjectDescription.TargetScript] = [],
        headers: Headers? = nil,
        plistFile: InfoPlist = .default
    ) -> Target {
        Target(
            name: name,
            platform: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTarget: .iOS(targetVersion: "12.1", devices: .iphone),
            infoPlist: plistFile,
            sources: sources,
            resources: resources,
            headers: headers,
            scripts: scripts,
            dependencies: dependencies
        )
    }
    
    static func makeTests(
        _ name: String,
        appTargetName: String,
        bundleId: String,
        sources: SourceFilesList
    ) -> Target {
        Target(
            name: name,
            platform: .iOS,
            product: .unitTests,
            bundleId: bundleId,
            deploymentTarget: .iOS(targetVersion: "12.1", devices: .iphone),
            infoPlist: .default,
            sources: sources,
            dependencies: [
                .xctest,
                .target(name: appTargetName),
            ],
            settings: Settings.test
        )
    }
    
    static func makeFramework(
        _ name: String,
        bundleId: String,
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = [],
        scripts: [ProjectDescription.TargetScript] = []
    ) -> Target {
        Target(
            name: name,
            platform: .iOS,
            product: .framework,
            bundleId: bundleId,
            deploymentTarget: .iOS(targetVersion: "12.1", devices: .iphone),
            sources: sources,
            resources: resources,
            scripts: scripts,
            dependencies: dependencies,
            settings: .makeFrameworkSettings()
        )
    }
    
}
