---
title: Advanced tips and tricks
description: A detailed look into more advanced concepts
display: article
weight: 4
menu:
  integrations:
    title: Tips and tricks
    parent: iOS client
---

This guide contains some tips on the less obvious parts of using the client, like lifecycle, start-stop acknowledgments, optional initialiser parameters and concurrency.

## Application and client lifecycle

As you know, iOS manages the apps by suspending and resuming their execution, whenever they are not actively in use (e.g. in the background). It does so to reduce instantaneous resource usage and improve battery life.

In practice it means that as a developer, you need to make sure you have logic that takes care of properly suspending and resuming your app. The OS provides a number of methods to monitor for the state change, but here we'll look at the simplest way to do that in a SwiftUI app with a single scene.

Speechly client provides two API methods for suspending and resuming it, called `.suspend()` and `.resume()`.

It's advisable to call these methods in your app, let's take a look at our manager example:

```swift
class SpeechlyManager: ObservableObject {
    var client: SpeechClient
    var active: Bool = true

    func suspend() {
        if !self.active {
          return
        }

        self.client?.suspend()
        self.active = false
    }

    func resume() {
        if self.active {
            return
        }

        do {
            try self.client?.resume()
            self.active = true
        } catch {
            print("Error resuming Speechly client:", error)
        }
    }
}
```

You might notice that we have to add an extra logic that checks whether the manager is active or not. If necessary, you can even make the `active` property published in the manager and observe it elsewhere in your app, if you want to perform some extra logic based on that.

Now, in our app we can use the `@Environment` attribute with `.scenePhase` selector to subscribe to scene phase updates and suspend and resume our client accordingly:

```swift
import SwiftUI
import Speechly

@main
struct MySpeechlyApp: App {
    @Environment(\.scenePhase) var scenePhase

    let speechlyManager = SpeechlyManager()

    var body: some Scene {
        WindowGroup {
            Text("Hello from Speechly!")
        }.onChange(of: self.scenePhase) { newPhase in
            switch newPhase {
            case .background:
                self.speechlyManager.suspend()
            case .active:
                self.speechlyManager.resume()
            default:
                return
            }
        }
    }
}
```

When the client is suspended, it will shut down the microphone handling and network connections, to minimise resource usage. Take note, that resuming the client might throw an error which you'll have to handle - check our [error handling guide](/client-libraries/ios/error-handling/).

## Handling start-stop acknowledgments

You might have already noticed, that alongside the `.start()` and `.stop()` methods, the client also provides two extra methods to the delegate - `speechlyClientDidStart` and `speechlyClientDidStop`.

This is because starting and stopping requires some asynchronous operations to perform. Thusly, calling `.start()` and `.stop()` methods only **request** the client to start or stop. The delegate methods provide you with a way to react to the client start or stopping.

It might be useful to use those methods to reflect the status of the recognition in the UI. You can add some code for updating the state of the manager and publish said state, which can then be consumed in you app:

```swift
enum SpeechlyState {
    case stopped, starting, started, stopping
}

class SpeechlyManager: ObservableObject {
    let client: SpeechClient

    @Published var state = SpeechlyState.stopped

    func start() {
        guard self.client != nil else {
            return
        }

        if !self.active {
            return
        }

        self.client?.start()

        DispatchQueue.main.async {
            self.state = .starting
        }
    }

    func stop() {
        guard self.client != nil else {
            return
        }

        if !self.active {
            return
        }

        self.client?.stop()

        DispatchQueue.main.async {
            self.state = .stopping
        }
    }
}

extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidStart(_: SpeechClientProtocol) {
        DispatchQueue.main.async {
            self.state = .started
        }
    }

    func speechlyClientDidStop(_: SpeechClientProtocol) {
        DispatchQueue.main.async {
            self.state = .stopped
        }
    }
}
```

And then consume it in your app to show e.g. some status text:

```swift
import SwiftUI

@main
struct RepoFilteringApp: App {
    @ObservedObject var speechlyManager = SpeechlyManager()

    var body: some Scene {
        WindowGroup {
            Text(statusText())
        }
    }

    func statusText() -> String {
        switch self.speechlyManager.state {
        case .started:
            return "Recognition in progress"
        case .starting:
            return "Starting recognition..."
        case .stopping:
            return "Stopping recognition..."
        case .stopped:
            return "No active recognition"
        }
    }
}
```

Of course in a more or less sophisticated app, you would want to use something better than just a status text. Good ideas might be to use haptic feedback and animations of the microphone button to communicate to the user when the app is ready to receive their voice input.

## Optional initialiser parameters

Let's take a quick look at `SpeechClient` initialiser and go over some optional parameters that you might want to customise in your app:

```swift
class SpeechClient {
    init(
        appId: UUID,
        language: LanguageCode,
        prepareOnInit: Bool = true,
        identityAddr: String = "grpc+tls://api.speechly.com",
        sluAddr: String = "grpc+tls://api.speechly.com",
        eventLoopGroup: EventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1),
        delegateDispatchQueue: DispatchQueue = DispatchQueue(label: "com.speechly.iosclient.SpeechClient.delegateQueue")
    ) throws {}
}
```

### prepareOnInit

For most of the apps, you'd want to leave it as it is, however if you want to delay initialising the microphone and fetching the API token for some reason (e.g. you have some splash screen you'd want to show to the user), you can set this to `false`.

If the client does not prepare itself on initialisation, it would instead call the preparation code when you call `.start()` for the first time, which might cause a bit longer delay in that case.

### eventLoopGroup

Internally the client uses the [SwiftNIO](https://github.com/apple/swift-nio) framework for non-blocking IO. This framework uses event loops for dispatching IO events, which are combined together into groups, for better throughput. By default the client uses a single group with a single event loop to minimise resource usage. However, depending on the hardware, the network and the application logic it might be beneficial to use more event loops for lower IO latency.

You can experiment with the amount of event loops to see if your application becomes more responsive. However, make sure you also monitor the amount of threads your application is using, since that might cause your application to drain too much battery or consume too much CPU.

### delegateDispatchQueue

Internally the client uses a separate dispatch queue for calling the delegate, to prevent the delegate from blocking the client execution flow (since the client cannot control the logic in the delegate). Practically it means that the delegate methods are allowed to block at the cost of extra concurrency.

If you want to share some dispatch queue between your delegate and some other parts of your application, you can pass it as a parameter to the client. Alternatively, you can create a queue with different parameters.

## Dispatch queues and concurrency

You might already know very well how GCD and specifically dispatch queues work, but if you don't - feel free to visit [the official documentation](https://developer.apple.com/documentation/dispatch/dispatchqueue).

Here are some quick and important tips and facts about concurrency in Speechly client:

- The client uses dispatch queues internally for dispatching results from the API and audio data chunks to the client
- The client uses a dedicated dispatch queue for calling the delegate
- The client dispatches delegate calls asynchronously
- Delegate methods must make sure that proper dispatch queue is used for updating the UI

In pratice, the most important thing is that if you have some code in your delegate that updates the UI (or perform actions that would lead to UI update), you must execute that code in the main dispatch queue:

```swift
import Foundation
import SwiftUI
import Speechly

@main
struct RepoFilteringApp: App {
    let speechlyAppId = UUID(uuidString: "my-speechly-app-id")!
    let speechlyAppLanguage = SpeechClient.LanguageCode.enUS

    @ObservedObject var speechlyManager = try! SpeechlyManager(
        appId: speechlyAppId, appLanguage: speechlyAppLanguage
    )

    var body: some Scene {
        WindowGroup {
            VStack {
                Text(speechlyManager.segment?.transcripts.first.value)
            }
        }
    }
}

class SpeechlyManager: ObservableObject {
    let client: SpeechClient

    @Published var segment: SpeechSegment? = nil

    init(appId: UUID, appLanguage: SpeechClient.LanguageCode) throws {
        self.client = try SpeechClient(appId: appId, language: appLanguage)
        self.client.delegate = self
    }
}

extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidUpdateSegment(_: SpeechClientProtocol, segment: SpeechSegment) {
        // IMPORTANT: make sure you use main dispatch queue here,
        // since changing segment value will cause a UI update.
        //
        // Never use `DispatchQueue.main.sync`, since it will cause a deadlock.
        DispatchQueue.main.async {
            self.segment = segment
        }
    }
}
```

If you need help with specific client APIs, please check out [the API reference](/client-libraries/ios/api-reference/).
