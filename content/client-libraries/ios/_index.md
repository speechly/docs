---
title: iOS client
description: The official Speechly client for iOS apps
display: article
weight: 3
aliases: ["/client-libraries/ios-client/"]
menu:
  integrations:
    title: iOS
---

{{< button "/client-libraries/ios/tutorial/" "flash-outline" "light" "Tutorial" >}}
{{< button "https://github.com/speechly/ios-client" "logo-github" "light" "GitHub" >}}

Speechly iOS client uses the power of Swift to make our product easy to use in your next iOS app.

## Installation

### Swift Package Manager

The client is distributed using [Swift Package Manager](https://swift.org/package-manager/), so you can use it by adding it as a dependency to your package.

First, initialise a new package:

```sh
swift package init --name MySpeechlyApp --type executable
```

Then add the client as a dependency to your package:

```swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MySpeechlyApp",
    dependencies: [
        .package(name: "speechly-ios-client", url: "https://github.com/speechly/ios-client.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "MySpeechlyApp",
            dependencies: []),
        .testTarget(
            name: "MySpeechlyAppTests",
            dependencies: ["MySpeechlyApp"]),
    ]
)
```

Finally, fetch the dependencies:

```sh
swift package resolve
```

### Xcode package dependency

If you are using Xcode, check out the [official tutorial for adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## Usage

You will need to specify your Speechly application ID and language to initialise the client. Initialising the client will connect it to the API and start the audio capture stack (but it will not activate the microphone just yet, don't worry!).

Starting, stopping, resuming and suspending the client can be done through the client's public methods.

The client uses a delegate pattern, so you will have to implement a delegate for receiving recognition results.

```swift
import Foundation
import Speechly

class SpeechlyManager {
    let client: SpeechClient

    public init() {
        self.client = try! SpeechClient(
            // Specify your Speechly application's identifier here.
            appId: UUID(uuidString: "your-speechly-app-id")!,

            // Specify your Speechly application's language here.
            language: .enUS
        )

        self.client.delegate = self
    }

    public func start() {
        // Use this to unmute the microphone and start recognising user's voice input.
        // You can call this when e.g. a button is pressed.
        self.client.start()
    }

    public func stop() {
        // Use this to mute the microphone and stop recognising user's voice input.
        // You can call this when e.g. a button is depressed.
        self.client.stop()
    }
}

// Implement the `Speechly.SpeechClientDelegate` for reacting to recognition results.
extension SpeechlyManager: SpeechClientDelegate {
    // (Optional) Use this method for telling the user that recognition has started.
    func speechlyClientDidStart(_: SpeechClientProtocol) {
        print("Speechly client has started an audio stream!")
    }

    // (Optional) Use this method for telling the user that recognition has finished.
    func speechlyClientDidStop(_: SpeechClientProtocol) {
        print("Speechly client has finished an audio stream!")
    }

    // Use this method for receiving recognition results.
    func speechlyClientDidUpdateSegment(_ client: SpeechClientProtocol, segment: SpeechSegment) {
        print("Received a new recognition result from Speechly!")

        // What the user wants the app to do, (e.g. "book" a hotel).
        print("Intent:", segment.intent)

        // How the user wants the action to be taken, (e.g. "in New York", "for tomorrow").
        print("Entities:", segment.entities)

        // The text transcript of what the user has said.
        // Use this to communicate to the user that your app understands them.
        print("Transcripts:", segment.transcripts)
    }
}
```
