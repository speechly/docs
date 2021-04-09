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

{{< button "https://github.com/speechly/ios-repo-filtering" "flash-outline" "light" "Tutorial" >}}
{{< button "https://github.com/speechly/ios-client" "logo-github" "light" "GitHub" >}}

Speechly iOS client uses the power of Swift to make our product easy to use in your next iOS app.

## Installation

### Swift package dependency

The client is distributed using [Swift Package Manager](https://swift.org/package-manager/), so you can use it by adding it as a dependency to your `Package.swift`:

```swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MySpeechlyApp",
    dependencies: [
        .package(name: "speechly-ios-client", url: "https://github.com/speechly/ios-client.git", from: "0.3.0"),
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

And then running `swift package resolve`.

### Xcode package dependency

If you are using Xcode, check out the [official tutorial for adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## Client Usage

The client exposes methods for starting and stopping the recognition, as well as a delegate protocol to implement for receiving recognition results. The `startContext()` method will open the microphone device and stream audio to the API, and the `stopContext()` method will close the audio context and the microphone.

Note: the application's `Info.plist` needs to include key `NSMicrophoneUsageDescription` to actually enable microphone access. The value is a string that iOS presents to the user when requesting permission to access the microphone.

```swift
import Foundation
import Speechly

class SpeechlyManager {
    let client: Speechly.Client

    public init() {
        client = try! Speechly.Client(
            // Specify your Speechly application's identifier here.
            appId: UUID(uuidString: "your-speechly-app-id")!,
            // or, if you want to use the project based login, set projectId.
            //projectId: UUID(uuidString: "your-speechly-project-id")!,
        )

        client.delegate = self
    }

    public func start() {
        // Use this to unmute the microphone and start recognising user's voice input.
        // You can call this when e.g. a button is pressed.
        // startContext accepts an optional `appId` parameter, if you need to specify it
        // per context.
        client.startContext()
    }

    public func stop() {
        // Use this to mute the microphone and stop recognising user's voice input.
        // You can call this when e.g. a button is depressed.
        client.stopContext()
    }
}

// Implement the `Speechly.SpeechlyDelegate` for reacting to recognition results.
extension SpeechlyManager: SpeechlyDelegate {
    // (Optional) Use this method for telling the user that recognition has started.
    func speechlyClientDidStartContext(_: SpeechlyProtocol) {
        print("Speechly client has started an audio stream!")
    }

    // (Optional) Use this method for telling the user that recognition has finished.
    func speechlyClientDidStopContext(_: SpeechlyProtocol) {
        print("Speechly client has finished an audio stream!")
    }

    // Use this method for receiving recognition results.
    func speechlyClientDidUpdateSegment(_ client: SpeechlyProtocol, segment: Segment) {
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

## User Interface Components

The client library also includes a couple of ready-made UI components which can be used together with `Speechly.Client`.

`MicrophoneButtonView` presents a microphone button using build-in icons and visual effects which you can replace with your own if needed. The microphone button protocol can be forwarded to `Speechly.Client` instance easily.

`TranscriptView` visualizes the transcripts received in the `speechlyClientDidUpdateSegment` callback, automatically highlighting recognized entities. For other callbacks, see [the protocol docs](docs/SpeechlyProtocol.md).

These can be used, for example, in the following way (`UIKit`):

```swift
import UIKit
import Speechly

class ViewController: UIViewController {
    private let manager = SpeechlyManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        manager.addViews(view: view)
    }
}

class SpeechlyManager {
    private let client: Speechly.Client
    private let transcriptView = TranscriptView()

    private lazy var speechButton = MicrophoneButtonView(delegate: self)

    public init() {
        client = try! Speechly.Client(
            appId: UUID(uuidString: "your-speechly-app-id")!
        )
        client.delegate = self
        speechButton.holdToTalkText = "Hold to talk"
        speechButton.pressedScale = 1.5
        transcriptView.autohideInterval = 3
    }

    public func addViews(view: UIView) {
        view.addSubview(transcriptView)
        view.addSubview(speechButton)

        transcriptView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
        }

        speechButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    public func start() {
        client.startContext()
    }

    public func stop() {
        client.stopContext()
    }
}

extension SpeechlyManager: MicrophoneButtonDelegate {
    func didOpenMicrophone(_ button: MicrophoneButtonView) {
        self.start()
    }
    func didCloseMicrophone(_ button: MicrophoneButtonView) {
        self.stop()
    }
}

extension SpeechlyManager: SpeechlyDelegate {
    func speechlyClientDidUpdateSegment(_ client: SpeechlyProtocol, segment: Segment) {
        DispatchQueue.main.async {
            self.transcriptView.configure(segment: segment, animated: true)
        }
    }
}
```

For a `SwiftUI` example, check out the [ios-repo-filtering](https://github.com/speechly/ios-repo-filtering) demo app.
