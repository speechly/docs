---
title: iOS usage guide
description: A guide for using Speechly on iOS
display: article
weight: 2
menu:
  integrations:
    title: Usage guide
    parent: iOS client
---

This usage guide will explain how to integrate Speechly client into your app and consume the recognition results. It doesn't showcase an end-to-end experience of building an app with Speechly, for that we recommend you go check out [our iOS tutorial](/client-libraries/ios/tutorial/).

## Integrating the client

In order to use Speechly in your app, you will have to do the following:

1. Add a Swift Package dependency to `https://github.com/speechly/ios-client.git` and make sure it is linked to your product.
2. Initialise `Speechly.SpeechClient(appId: UUID, language: Speechly.SpeechClient.LanguageCode)` somewhere in your app.
3. Provide the initialised client with a `Speechly.SpeechClientDelegate` to receive recognition results.
4. Call `Speechly.SpeechClient#start()` and `Speechly.SpeechClient#stop()` to start and stop recognition.

There's a couple of different approaches you can use, depending on whether you are working with a SwiftUI or an UIKit application.

### SwiftUI application

If you are working with a SwiftUI app, a good idea would be to implement a manager class that will use the `ObservableObject` protocol in order to publish a property, which will be updated whenever the manager receives new data:

```swift
import Foundation
import Speechly

class SpeechlyManager: ObservableObject {
    let client: SpeechClient

    // Publish current speech segment,
    // which will be updated when we receive new data from Speechly.
    @Published var segment: SpeechSegment? = nil

    init(appId: UUID, appLanguage: SpeechClient.LanguageCode) throws {
        self.client = try SpeechClient(appId: appId, language: appLanguage)
        self.client.delegate = self
    }

    func start() {
        self.client.start()
    }

    func stop() {
        self.client.stop()
    }
}

extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidStart(_: SpeechClientProtocol) {
        // SpeechClientDelegate methods are invoked in background threads.
        // Since updating a published variable will cause UI updates,
        // it is important that we use main dispatch queue here.
        DispatchQueue.main.async {
            self.segment = nil
        }
    }

    func speechlyClientDidStop(_: SpeechClientProtocol) {
        // SpeechClientDelegate methods are invoked in background threads.
        // Since updating a published variable will cause UI updates,
        // it is important that we use main dispatch queue here.
        DispatchQueue.main.async {
            self.segment = nil
        }
    }

    func speechlyClientDidUpdateSegment(_: SpeechClientProtocol, segment: SpeechSegment) {
        // SpeechClientDelegate methods are invoked in background threads.
        // Since updating a published variable will cause UI updates,
        // it is important that we use main dispatch queue here.
        DispatchQueue.main.async {
            self.segment = segment
        }
    }
}
```

Once created, you can use the manager together with `@ObservedObject` attributed in your SwiftUI `App`, e.g. like this:

```swift
import Foundation
import SwiftUI
import Speechly

let speechlyAppId = UUID(uuidString: "my-speechly-app-id")!
let speechlyAppLanguage = SpeechClient.LanguageCode.enUS

@main
struct RepoFilteringApp: App {
    // Use @ObservedObject attribute
    // to listen for the changes on the published properties of the manager.
    @ObservedObject var speechlyManager = try! SpeechlyManager(
        appId: speechlyAppId, appLanguage: speechlyAppLanguage
    )

    var body: some Scene {
        WindowGroup {
            VStack {
                // Use a Text component to render transcribed text from the API.
                TranscriptText(segment: self.speechlyManager.segment)

                // Use a button to start and stop recognising voice.
                MicrophoneButton(
                    onStart: self.speechlyManager.start, onStop: self.speechlyManager.stop
                )
            }
        }
    }
}

struct TranscriptText: View {
    let segment: SpeechSegment?

    var body: some View {
        // Since segment can be nil, guard against that here.
        guard let segment = self.segment else {
          return Text("")
        }

        // Visualise segment transcript as text
        return segment.words.reduce(Text("")) { (acc, word) in
            acc + Text(" ") + Text(word.value).fontWeight(word.isFinal ? .bold : .light)
        }
    }
}

struct MicrophoneButton: View {
    @State var isRecording = false

    let onStart: () -> Void
    let onStop: () -> Void

    var body: some View {
        Button("Recognise", action: toggleRecording)
    }

    func toggleRecording() {
        if self.isRecording {
            self.isRecording = false
            self.onStop()

            return
        }

        self.isRecording = true
        self.onStart()
    }
}
```

### UIKit application

If you are using UIKit, then you can add the logic to control the client and receive recognition results to a `UIViewController`.

Here's a simple example using the main `ViewController`, a label and a button outlets from Storyboard:

```swift
import UIKit
import Speechly

let speechlyAppId = UUID(uuidString: "my-speechly-app-id")!
let speechlyAppLanguage = SpeechClient.LanguageCode.enUS

class ViewController: UIViewController {
    // A button to start and stop voice recognition.
    @IBOutlet var micButton: UIButton!

    // A label to render transcribed voice input.
    @IBOutlet var transcriptLabel: UILabel!

    private let speechlyClient: SpeechClient

    required init?(coder: NSCoder) {
        self.speechlyClient = try! SpeechClient(
            appId: speechlyAppId,
            language: speechlyAppLanguage
        )

        super.init(coder: coder)

        self.speechlyClient.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hook up touch down / touch up events to our start / stop logic.
        self.micButton.addTarget(self, action: #selector(self.onMicButtonDown), for: .touchDown)

        self.micButton.addTarget(
            self, action: #selector(self.onMicButtonUp), for: .touchUpInside
        )

        self.micButton.addTarget(
            self, action: #selector(self.onMicButtonUp), for: .touchUpOutside
        )
    }

    @objc func onMicButtonDown(_ button: UIButton) {
        self.speechlyClient.start()
    }

    @objc func onMicButtonUp(_button: UIButton) {
        self.speechlyClient.stop()
    }
}

extension ViewController: SpeechClientDelegate {
    func speechlyClientDidUpdateSegment(_ : SpeechClientProtocol, segment: SpeechSegment) {
        // Update the transcript label whenever we receive new speech segment from the API.
        self.updateTranscript(segment)
    }

    func updateTranscript(_ segment: SpeechSegment) {
        var finalWords = ""
        var tentativeWords = ""

        for transcript in segment.transcripts {
            if transcript.isFinal {
                finalWords.append(" \(transcript.value)")
            } else {
                tentativeWords.append(" \(transcript.value)")
            }
        }

        let transcriptText = NSMutableAttributedString(
            string: finalWords,
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        )

        transcriptText.append(
            NSMutableAttributedString(string: tentativeWords)
        )

        // Since delegate methods are invoked from a background thread,
        // make sure that we update the UI from the main dispatch queue.
        DispatchQueue.main.async {
            self.transcriptLabel.attributedText = transcriptText
        }
    }
}
```

## Processing results

The client offers a couple of different ways to consume the recognition results.

The high-level segment API provides the user with an aggregate view of the responses included in a single speech segment, which is easier to use and covers most of the use cases.

The low-level API allows the user to react to individual recognition results without aggregating them. This API might be useful, if for some reason you do not need aggregation or you want to do it differently.

### Using segment API

The segment API consists of a single delegate method - `speechlyClientDidUpdateSegment`.

This method passes current version of current speech segment to the delegate every time the client receives a new recognition result or a segment finalisation message.

In other words this API allows the delegate to tap into the timeline view of segment(s), allowing you to react to new and old recognition results alike.

Consider the case when a user says the phrase `Book a flight to New York`. This will result in `speechlyClientDidUpdateSegment` being called with the following parameters, depending on how the SLU API returns the messages:

```swift
// 1st call
SpeechSegment{
    segmentId: 0
    contextId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    isFinal: false,
    intent: SpeechIntent{value: "", isFinal: false},
    entities: [],
    transcripts: [
        SpeechTranscript{index: 0, value: "book", isFinal: false}
    ]
}

// 2nd call
SpeechSegment{
    segmentId: 0
    contextId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    isFinal: false,
    intent: SpeechIntent{value: "book", isFinal: false},
    entities: [],
    transcripts: [
        SpeechTranscript{index: 0, value: "book", isFinal: true},
        SpeechTranscript{index: 1, value: "a", isFinal: false}
    ]
}

// 3rd call
SpeechSegment{
    segmentId: 0
    contextId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    isFinal: false,
    intent: SpeechIntent{value: "book", isFinal: true},
    entities: [],
    transcripts: [
        SpeechTranscript{index: 0, value: "book", isFinal: true},
        SpeechTranscript{index: 1, value: "a", isFinal: true},
        SpeechTranscript{index: 2, value: "flight", isFinal: false}
    ]
}

// 4th call
SpeechSegment{
    segmentId: 0
    contextId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    isFinal: false,
    intent: SpeechIntent{value: "book", isFinal: true},
    entities: [],
    transcripts: [
        SpeechTranscript{index: 0, value: "book", isFinal: true},
        SpeechTranscript{index: 1, value: "a", isFinal: true},
        SpeechTranscript{index: 2, value: "flight", isFinal: true},
        SpeechTranscript{index: 3, value: "to", isFinal: false}
    ]
}

// 5th call
SpeechSegment{
    segmentId: 0
    contextId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    isFinal: false,
    intent: SpeechIntent{value: "book", isFinal: true},
    entities: [
        SpeechEntity{
            startIndex: 4, endIndex: 4, type: "destination", value: "New", isFinal: false
        },
    ],
    transcripts: [
        SpeechTranscript{index: 0, value: "book", isFinal: true},
        SpeechTranscript{index: 1, value: "a", isFinal: true},
        SpeechTranscript{index: 2, value: "flight", isFinal: true},
        SpeechTranscript{index: 3, value: "to", isFinal: true},
        SpeechTranscript{index: 4, value: "New", isFinal: false}
    ]
}

// 6th call
SpeechSegment{
    segmentId: 0
    contextId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    isFinal: false,
    intent: SpeechIntent{value: "book", isFinal: true},
    entities: [
        SpeechEntity{
            startIndex: 4, endIndex: 5, type: "destination", value: "New York", isFinal: false
        },
    ],
    transcripts: [
        SpeechTranscript{index: 0, value: "book", isFinal: true},
        SpeechTranscript{index: 1, value: "a", isFinal: true},
        SpeechTranscript{index: 2, value: "flight", isFinal: true},
        SpeechTranscript{index: 3, value: "to", isFinal: true},
        SpeechTranscript{index: 4, value: "New", isFinal: true},
        SpeechTranscript{index: 5, value: "York", isFinal: false}
    ]
}

// 7th call
SpeechSegment{
    segmentId: 0
    contextId: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    isFinal: true,
    intent: SpeechIntent{value: "book", isFinal: true},
    entities: [
        SpeechEntity{
            startIndex: 4, endIndex: 5, type: "destination", value: "New York", isFinal: true
        },
    ],
    transcripts: [
        SpeechTranscript{index: 0, value: "book", isFinal: true},
        SpeechTranscript{index: 1, value: "a", isFinal: true},
        SpeechTranscript{index: 2, value: "flight", isFinal: true},
        SpeechTranscript{index: 3, value: "to", isFinal: true},
        SpeechTranscript{index: 4, value: "New", isFinal: true},
        SpeechTranscript{index: 5, value: "York", isFinal: true}
    ]
}
```

As you can see with each call, the segment has increasingly more results in it and the results get finalised progressively.

Using this API makes it easy for the developer to update the state of their application without having to rely on previous state, since each next call already contains all aggregated results.

You can use this API to visualise the transcription to the user to provide them with feedback and most importantly, to react to the input. If your app allows users to book flights, you can start searching flights as soon as you detect that the intent of the user is to `book` a flight and they have said the `destination`. In a more complex example the segment can include entities like `date` or `flight_type`, depending on how you configure your Speechly application and what the users say.

In order to use this API, you need to pass the delegate and define the `speechlyClientDidUpdateSegment` method in it:

```swift
import Foundation
import Speechly

class SpeechlyManager {
    let speechlyClient: SpeechClient

    init(appId: UUID, appLanguage: SpeechClient.LanguageCode) throws {
        self.client = try! SpeechClient(appId: appId, language: appLanguage)
        self.client.delegate = self
    }
}

extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidUpdateSegment(_ : SpeechClientProtocol, segment: SpeechSegment) {
        print("Received a segment update")
        print("Intent:", segment.intent)
        print("Entities:", segment.entities)
        print("Transcripts:", segment.transcripts)
    }
}
```

### Using low-level API

If you application already has state management and aggregation logic and receiving aggregated updates will force you to un-aggregate them, you can use the low-level API that can provide you with ability to incrementally react to incoming recognition results.

The API consists of three delegate methods:

```swift
extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidReceiveIntent(
        _: SpeechClientProtocol, contextId: String, segmentId: Int, intent: SpeechIntent
    ) {
        print("Received new intent:", intent)
    }

    func speechlyClientDidReceiveEntity(
        _: SpeechClientProtocol, contextId: String, segmentId: Int, entity: SpeechEntity
    ) {
        print("Received new entity:", entity)
    }

    func speechlyClientDidReceiveTranscript(
        _: SpeechClientProtocol, contextId: String, segmentId: Int, transcript: SpeechTranscript
    ) {
        print("Received new transcript:", transcript)
    }
}
```

You can define whichever methods you consider useful in your delegate, according to your logic. These methods can be handy if you would like to perform e.g. incremental searches or UI updates, where you use e.g. entities to filter throught a list of items and save the filtered results and then filter them again once more entities arrive.

### Parsing the results

Whichever API you choose to use (you can even use both, if your use case requires that) you will still need to parse the results to make sure you can use them in your application's logic.

Let's assume that your application uses Speechly to allow users to search for flights by destination, departure time and seating class. For that purpose, we might want to parse the segment into a `Filter` struct:

```swift
struct Filter {
    static let empty = Filter(destination: "", departure: Date(), seatClass: .any)

    enum SeatClass {
        case economy, business, any
    }

    var destination: String
    var departure: Date
    var seatClass: SeatClass
}
```

It's a very simply container for our search parameters. Now let's define our manager class:

```swift
class SpeechlyManager: ObservableObject {
    @Published var filter: Filter = Filter.empty

    let dateFormatter = ISO8601DateFormatter()
    let client: SpeechClient

    init(appId: UUID, appLanguage: SpeechClient.LanguageCode) throws {
        self.client = try SpeechClient(appId: appId, language: appLanguage)
        self.client.delegate = self
    }

    func start() {
        self.client.start()
    }

    func stop() {
        self.client.stop()
    }
}
```

Very basic setup here, except that we have a date formatter property, which we'll use for parsing departure dates from recognition results later and a published filter property, which is initially set to an empty value.

Now we want to subscribe to segment updates and use them to update or clear our filter. This code assumes that your Speechly configuration has two intents - one for resetting the filters and one for applying them.

We also assume some entity names and types.

```swift
extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidUpdateSegment(_: SpeechClientProtocol, segment: SpeechSegment) {
        // Make sure we run our code on the main dispatch queue,
        // since it reads and writes a published property
        DispatchQueue.main.async {
            // Intent dispatch logic
            switch segment.intent.value.lowercased() {
            // User wants to apply a filter to the results
            case "filter":
                // Since we want to incrementally update our filters whenever user says something,
                // let's start by copying the last value
                var newFilter = self.filter

                if let destination = self.parseDestination(segment) {
                    // Only update the destination if we had a new one in the segment
                    newFilter.destination = destination
                }

                if let departure = self.parseDeparture(segment) {
                    // Only update the departure date if we had a new one in the segment
                    newFilter.departure = departure
                }

                if let seatClass = self.parseSeatClass(segment) {
                    // Only update the seat class if we had a new one in the segment
                    newFilter.seatClass = seatClass
                }

                // Update current filter with new values
                self.filter = newFilter

            // User wants to clear the filters
            case "clear":
                self.filter = Filter.empty

            // If we get some other intent from the API, ignore it
            default:
                return
            }
        }
    }

    // Parse the destination entity from the segment.
    // Returns nil if no such entity could be found.
    func parseDestination(_ segment: SpeechSegment) -> String? {
        let destination = segment.entities.first { $0.type.lowercased() == "destination" }
        return destination?.value
    }

    // Parse the departure date entity from the segment.
    // Returns nil if no such entity could be found.
    func parseDeparture(_ segment: SpeechSegment) -> Date? {
        guard let departure = segment.entities.first(where: { $0.type.lowercased() == "departure_date" }) else {
            return nil
        }

        return dateFormatter.date(from: departure.value)
    }

    // Parse the seat class entity from the segment.
    // Returns nil if no such entity could be found.
    func parseSeatClass(_ segment: SpeechSegment) -> Filter.SeatClass? {
        guard let seatClass = segment.entities.first(where: { $0.type.lowercased() == "seat_class" }) else {
            return nil
        }

        // Check for whitelisted values
        switch seatClass.value.lowercased() {
        case "economy":
            return .economy
        case "business":
            return .business
        default:
            return .any
        }
    }
}
```

There are three important things to note here:

- When parsing intent and entity values, always make sure that your code is case-insensitive, e.g. in our example we chose to use `.lowercased()`
- When parsing an enumerable (in our case it was the seating class), make sure to check for possible values and have some logic for "unknown" values
- Don't expect all entities to always be present, even if your configuration is such, since some entities may arrive later in the results

Now you can go ahead and use this manager in your app by subscribing to its updates.

## Final and tentative results

At this point you might be wondering, what is the deal with `isFinal` flag. This flag is actually quite important, since Speechly SLU API produces two types of results - tentative and final.

**Tentative** results are always emitted before the final ones and they may change later, depending on the contents of the phrase.

For example, if a user says something like `Show me green t-shirts`, by the time they get to say `Show me green t`, the API might recognise the sound `t` as the word `tea`, since they sound quite similar and `Show me green tea` is a perfectly valid phrase to say in the context of e.g. a online shopping platform. Depending on the configuration, this can also result in the API producing a **tentative entity** with the value of `{ "type": "product", "value": "green tea", isFinal: false }`.

However, after the user finishes his phrase, the API will correct the recognition result and update the transcript and entity values to `green t-shirts` and at some point those transcripts and entities will be marked as **final**.

**Final** results are emitted once the API is confident that the recognised values will not change in the future. Most of the time it takes more context to be able to reliably recognise what a user has said (as shown in our toy example above), so final results take longer to be produced. On the other hand, final results are more reliable, especially in some contexts where a lot of ambiguity is possible.

It is recommended that you try out your Speechly applications performance before making a decision which results to rely on. Most of the time it's perfectly fine to use both results without explicitly checking their state - even if a tentative result changes its value once it becomes final, this won't happen too often and the cost of error is low enough (e.g. in the online shopping we'll just have to redo the search).

However, if you notice that there's a lot of changes happening when the results are finalised, or you cannot tolerate even small percentage of errors, you might want to consider checking for the state of the result.

We can modify our parser from [the chapter on parsing the results](#parsing-the-results) to explicitly check for final states:

```swift
extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidUpdateSegment(_: SpeechClientProtocol, segment: SpeechSegment) {
        if !segment.intent.isFinal {
            return
        }

        switch segment.intent.value.lowercased() {
        case "filter":
            var newFilter = self.filter

            if let destination = self.parseDestination(segment) {
                newFilter.destination = destination
            }

            if let departure = self.parseDeparture(segment) {
                newFilter.departure = departure
            }

            if let seatClass = self.parseSeatClass(segment) {
                newFilter.seatClass = seatClass
            }

            self.filter = newFilter
        case "clear":
            self.filter = Filter.empty
        default:
            return
        }
    }

    func parseDestination(_ segment: SpeechSegment) -> String? {
        guard let destination = segment.entities.first(where: { $0.type.lowercased() == "destination" }) else {
            return nil
        }

        if !destination.isFinal {
            return nil
        }

        return destination.value
    }

    func parseDeparture(_ segment: SpeechSegment) -> Date? {
        guard let departure = segment.entities.first(where: { $0.type.lowercased() == "departure_date" }) else {
            return nil
        }

        if !departure.isFinal {
            return nil
        }

        return dateFormatter.date(from: departure.value)
    }

    func parseSeatClass(_ segment: SpeechSegment) -> Filter.SeatClass? {
        guard let seatClass = segment.entities.first(where: { $0.type.lowercased() == "seat_class" }) else {
            return nil
        }

        if !seatClass.isFinal {
            return nil
        }

        switch seatClass.value.lowercased() {
        case "economy":
            return .economy
        case "business":
            return .business
        default:
            return .any
        }
    }
}
```

Notice the `.isFinal` checks - now our code will only work with intents and entities that were finalised.

If you want to be even more cautious, you might want to check for the final state of the whole segment. If a segment is marked as final, it is guaranteed to not change in the future and to only contain final results:

```swift
extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidUpdateSegment(_: SpeechClientProtocol, segment: SpeechSegment) {
        if !segment.isFinal {
            return nil
        }

        switch segment.intent.value.lowercased() {
        case "filter":
            var newFilter = self.filter

            if let destination = self.parseDestination(segment) {
                newFilter.destination = destination
            }

            if let departure = self.parseDeparture(segment) {
                newFilter.departure = departure
            }

            if let seatClass = self.parseSeatClass(segment) {
                newFilter.seatClass = seatClass
            }

            self.filter = newFilter
        case "clear":
            self.filter = Filter.empty
        default:
            return
        }
    }
}
```

Take note, however, that using only final results may make your application significantly less responsive to the input. Even if you have to only use final results for your application logic, it is a good idea to use all transcript results for providing visual feedback to the users.

## Understanding results

The recognition happens on a piece of audio captured from a microphone between a `client.start()` and a `client.stop()` calls.

The top-level result of the recognition is a speech context, which contains one or more speech segments. Each speech segment in turn contains exactly one speech intent, one or more speech transcripts and zero or more speech entities.

If we were to describe our schema in Swift, it would look something like this:

```swift
struct SpeechContext {
    // Unique context identifier.
    let contextId: UUID

    // One or more segments.
    let speechSegments: [SpeechSegment]

    // Whether the context has been finalised.
    // Once context has been marked as final, it will not be updated by the API anymore.
    // A finalised context is guaranteed to have only finalised segments.
    let isFinal: Bool

    struct SpeechSegment {
        // The identifier of a segment within its context.
        // It is zero-based and its NOT guaranteed to be contiguous with IDs of other segments.
        let segmentId: Int

        // Whether the segment has been finalised.
        // Once segment has been marked as final, it will not be updated by the API anymore.
        // A finalised segment is guaranteed to have only finalised intent, entities and transcripts.
        let isFinal: Bool

        // The intent of the segment.
        let intent: SpeechIntent

        // Zero or more entities of the segment.
        let entities: [SpeechEntities]

        // One or more transcribed word of the segment.
        let transcripts: [SpeechTranscript]
    }
}
```

### Context

A speech context is a collection of recognition results derived from a single piece of audio, bounded by `client.start()` and `client.stop()` calls. Normally this would represent a single phrase (or an utterance, in linguistics' terms) spoken by the user and can look something like `Book me a flight to San Francisco tomorrow morning and rent a car for a week`.

The client does not currently provide means for consuming the contexts, but you can notice that some of the `SpeechClientDelegate` methods refer to `contextId`, which is a unique identifier of any context.

A single context can contain one or more speech segments.

### Segment

A speech segment is a collection of recognition results which relate to a single intent. In short, an intent is the action that the user wants the application to perform.

A segment contains exactly one `Intent`, one or more `Transcripts` and zero or more `Entities`, depending on the configuration of the Speechly app and the spoken phrase.

Using our example from before,`Book me a flight to San Francisco tomorrow morning and rent a car for a week` contains two segments:

- `Book me a flight to San Francisco tomorrow morning` (intent - `book a flight`)
- `Rent a car for a week` (intent - `rent a car`)

You can find more details about the speech segment [in the API reference](/client-libraries/ios/api-reference/SpeechSegment/).

### Intent

An intent is an action that the user wants the application to perform, e.g. `book a flight`, `rent a car`, `find an item`, etc.

You can find more details about the intent [in the API reference](/client-libraries/ios/api-reference/SpeechIntent/).

### Entity

An entity is a specific object in the phrase that falls into some kind of category, like a date, the type of flight or its destination, etc.

You can find more details about the entity [in the API reference](/client-libraries/ios/api-reference/SpeechEntity/).

### Transcript

A transcript is a single word in a phrase recognised from the audio, e.g. "book", "flight", "rent", "car", etc.

You can find more details about the transcript [in the API reference](/client-libraries/ios/api-reference/SpeechTranscript/).
