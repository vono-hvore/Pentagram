import ProjectDescription

let project = Project(
    name: "PentagramExample",
    settings: .settings(
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release"),
        ]
    ),
    targets: [
        .pentagramFramework,
        .pentagramExample,
    ],
)

extension Target {
    static var lintScript: String {
        """
        if command -v swiftlint >/dev/null 2>&1; then
        	swiftlint version
        	swiftlint --quiet
        fi
        """
    }

    static let pentagramFramework = Target.target(
        name: "PentagramFramework",
        destinations: .iOS,
        product: .framework,
        bundleId: "com.pentagram.framework",
        deploymentTargets: .iOS("16.0"),
        sources: ["Pentagram/Sources/**"],
        headers: .headers(public: "Pentagram/Sources/*.h"),
        scripts: [
            .pre(
                script: lintScript,
                name: "SwiftLint",
                basedOnDependencyAnalysis: false
            ),
        ],
        settings: .settings(
            base: [
                "SWIFT_VERSION": "6.1",
            ]
        ),
    )

    static let pentagramExample = Target.target(
        name: "PentagramExample",
        destinations: .iOS,
        product: .app,
        bundleId: "com.pentagram.example",
        deploymentTargets: .iOS("16.0"),
        infoPlist: .extendingDefault(with: [
            "UILaunchStoryboardName": "LaunchScreen",
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                        ],
                    ],
                ],
            ],
        ]),
        sources: ["PentagramExample/Sources/**"],
        resources: [
            "PentagramExample/Resources/**",
            ".swiftlint.yml",
        ],
        scripts: [
            .pre(
                script: lintScript,
                name: "SwiftLint",
                basedOnDependencyAnalysis: false
            ),
        ],
        dependencies: [
            .target(name: "PentagramFramework"),
        ],
        settings: .settings(
            base: [
                "SWIFT_VERSION": "6.1",
            ],
        )
    )
}
