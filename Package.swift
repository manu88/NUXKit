import PackageDescription

let package = Package(
    name: "NUXKit",
    targets: [
    			Target(name: "objc", dependencies:["StoryBoardParser" ]),
    			Target(name: "UIKit", dependencies:["StoryBoardParser" , "objc"]),
    			Target(name: "TestUI", dependencies:["UIKit"])
    			]
)
