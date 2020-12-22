---
title: Error handling
description: Making sure you handle all corner cases
display: article
weight: 3
menu:
  integrations:
    title: Error handling
    parent: iOS client
---

Handling erroneous cases is a very important step for making sure that the users of an app are not left wondering why the app is not working as expected. It vital that at the very least the app tells the user that there's something wrong going on and it is not functioning as it should. Of course graceful degradation is even more important - some errors can be tolerated by disabling certain features of the app.

In this guide we'll walk you through the available APIs for catching the errors from Speechly client and provide some recommendation on how to handle them.

## Initialisation errors

You may have already noticed that default `SpeechClient` initialiser can throw. This is because when the client is initialised, it will try to establish API connection. By default the client will also initialise the microphone and will try to obtain an authentication token from [Speechly Identity API](/speechly-api/api-reference/#identity-service).

If any of those operations fail, the initialiser will throw an exception, because it is impossible to perform recognition without all of these operations succeeding.

Those errors may be caused by the following:

- API is unreachable because there the device is not connected to internet
- Your app id and language combination is invalid
- OS-level microphone API throws an error when initialising the microphone

Unfortunately, currently the API does not provide a clear way to distinguish between those errors, so you have to treat all of these errors equally.

The simplest approach would be have a flag that would tell the rest of your application whether Speechly client has been properly initialised and disable the VUI functionality if initialisation fails:

```swift
class SpeechlyManager: ObservableObject {
    let speechlyAppId = UUID(uuidString: "my-speechly-app")!
    let speechlyAppLanguage = SpeechClient.LanguageCode.enUS

    var client: SpeechClient?

    @Published var initialised = false

    init() {
        do {
            self.client = try SpeechClient(appId: speechlyAppId, language: speechlyAppLanguage)
            self.client?.delegate = self

            self.initialised = true
        } catch {
            print("Failed to initialise Speechly client:", error)
        }
    }

    func start() {
        guard self.client != nil else {
            return
        }

        self.client?.start()
    }

    func stop() {
        guard self.client != nil else {
            return
        }

        self.client?.stop()
    }
}
```

Additionally, you can add some logic to retry the initialisation, but make sure you use proper backoff and limit settings, so that you don't end up retrying forever every millisecond - this will make your app extremely power-hungry.

## Recognition errors

Recognition errors happen when there were issues capturing audio, sending and receiving data over network, processing it in the API or parsing the API results.

The errors are caught by the client and are dispatched to the delegate in the `speechlyClientDidCatchError` method. You can use that method to respond to these errors accordingly. A simple way to do that would be to publish a recognition error property from your manager and update it whenever an error is caught. You might want to treat different error types differently - some errors require the user to speak their command again, some can be tolerated (although recognition results will be less accurate).

Here's an example on how you can catch those errors:

```swift
struct RecognitionError {
    var description: String
    var critical: Bool
}

class SpeechlyManager: ObservableObject {
    @Published var recognitionError: RecognitionError? = nil
}

extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidCatchError(_: SpeechClientProtocol, error: SpeechClientError) {
        var recognitionError = RecognitionError(description: "", critical: false)

        switch error {
        case let .apiError(desc), let .parseError(desc):
            recognitionError.description = desc
            recognitionError.critical = false
        case let .audioError(desc), let .networkError(desc):
            recognitionError.description = desc
            recognitionError.critical = true
        }

        DispatchQueue.main.async {
            self.recognitionError = recognitionError
        }
    }
}
```

Once you have the error handling code in place, you can use the published `recognitionError` property in your app to e.g. prompt users to repeat their input or notify them about degraded recognition results. Alternatively, you can also disable VUI functionality if you see too many recognition errors happening.

## Lifecycle errors

Currently, the only lifecycle method that can throw an exception is `client.resume()`. This method is useful for re-starting a suspended client and it can throw if e.g. network connection or the microphone cannot be re-enabled. It is suggested that if that happens, you disable the VUI functionality within the app or prompt the user to reopen the app, since there is no good way of recovering from such error.

Your manager code can simply re-throw the exception when forwarding the resume call to the client:

```swift
class SpeechlyManager: ObservableObject {
    let client: SpeechlyClient

    func resume() throws {
        try self.client.resume()
    }
}
```

You can take a closer look at lifecycle methods in out [best practices guide](/client-libraries/ios/advanced-tricks/).
