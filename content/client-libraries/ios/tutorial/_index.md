---
title: iOS client tutorial
description: Get started with iOS and Speechly
display: article
weight: 1
menu:
  integrations:
    title: Tutorial
    parent: iOS client
---

## Introduction

This tutorial will help you to get up and running with Speechly by guiding you through the process of building a simple voice filtering web app with Speechly and SwiftUI.

You can find the source code for this tutorial [on GitHub](https://github.com/speechly/ios-repo-filtering).

## Prerequisites

We'll be using Xcode and iOS simulator, so make sure you have those installed.

- Xcode 12
- iOS Simulator with iOS version 14.0 or later

This tutorial assumes that you know the basics of iOS development and the Swift programming language. Feel free to check the official Apple documentation to get started with [Swift](https://developer.apple.com/documentation/swift) or [SwiftUI](https://developer.apple.com/tutorials/swiftui).

## Create a new Xcode project

First, we'll need a new iOS app project. Let's create one!

1. Open Xcode and go to **File > New > Project**.
2. Under the set of iOS templates, choose **App**:

{{< figure src="0_new_project.png" alt="Xcode project template picker" >}}

3. Click **Next** and fill in your project details. Name your project **SpeechlyRepoFiltering**, choose **SwiftUI** as your interface option, **SwiftUI App** as life cycle and **Swift** for the language.

{{< figure src="1_new_name.png" alt="Xcode new project options" >}}

4. Click **Next** once more and you should have your project created for you.

## Adding Speechly client dependency

Next we need to add Speechly client library to our project.

1. Click **File > Swift Packages > Add Package Dependency**:

{{< figure src="2_spm_add.png" alt="Xcode add SPM dependency" >}}

2. Specify `https://github.com/speechly/ios-client.git` as the package repository and click **Next**:

{{< figure src="3_dep_repo.png" alt="Xcode SPM dependency repository" >}}

3. Xcode will fetch the package information for you and will ask you to specify the version. Leave the default rules in and click **Next**:

{{< figure src="4_dep_version.png" alt="Xcode SPM dependency version" >}}

4. After the Xcode fetches the package and its dependencies, it will ask which target you want to add it to. Make sure you have **Speechly** product added to **SpeechlyRepoFiltering** and the checkbox checked and then click **Finish**:

{{< figure src="5_dep_target.png" alt="Xcode SPM dependency target" >}}

## Add repo data and layout

Now that we have the project ready, let's start coding!

Since we are building a filtering app, let's add some data to filter and layout to display it.

To make it simple, our data source will be just a static array with some popular repositories on GitHub.

First, let's add the data model and save it as `GithubRepoModel.swift`:

```swift
import Foundation

struct GithubRepo: Hashable, Identifiable {
    enum Language: String, Hashable {
        case Go = "Go"
        case Python = "Python"
        case TypeScript = "TypeScript"
    }

    let id: Int
    let name: String
    let organisation: String
    let language: Language
    let followers: Int
    let stars: Int
    let forks: Int
}
```

Now let's add a repository that will return us some sample data. Add the following code to `GithubRepoRepository.swift`:

```swift
import Foundation

class GithubRepoRepository {
    static let shared = GithubRepoRepository()

    func list() -> [GithubRepo] {
        return self.repositories
    }

    private let repositories = [
        GithubRepo(
            id: 1,
            name: "typescript",
            organisation: "microsoft",
            language: .TypeScript,
            followers: 2200,
            stars: 65000,
            forks: 8700
        ),
        GithubRepo(
            id: 2,
            name: "nest",
            organisation: "nestjs",
            language: .TypeScript,
            followers: 648,
            stars: 30900,
            forks: 2800
        ),
        GithubRepo(
            id: 3,
            name: "vscode",
            organisation: "microsoft",
            language: .TypeScript,
            followers: 3000,
            stars: 105000,
            forks: 16700
        ),
        GithubRepo(
            id: 4,
            name: "deno",
            organisation: "denoland",
            language: .TypeScript,
            followers: 1700,
            stars: 68000,
            forks: 3500
        ),
        GithubRepo(
            id: 5,
            name: "kubernetes",
            organisation: "kubernetes",
            language: .Go,
            followers: 3300,
            stars: 70700,
            forks: 25500
        ),
        GithubRepo(
            id: 6,
            name: "moby",
            organisation: "moby",
            language: .Go,
            followers: 3200,
            stars: 58600,
            forks: 16900
        ),
        GithubRepo(
            id: 7,
            name: "hugo",
            organisation: "gohugoio",
            language: .Go,
            followers: 1000,
            stars: 47200,
            forks: 5400
        ),
        GithubRepo(
            id: 8,
            name: "grafana",
            organisation: "grafana",
            language: .Go,
            followers: 1300,
            stars: 37500,
            forks: 7600
        ),
        GithubRepo(
            id: 9,
            name: "pytorch",
            organisation: "pytorch",
            language: .Python,
            followers: 1600,
            stars: 43000,
            forks: 11200
        ),
        GithubRepo(
            id: 10,
            name: "tensorflow",
            organisation: "tensorfow",
            language: .Python,
            followers: 8300,
            stars: 149000,
            forks: 82900
        ),
        GithubRepo(
            id: 11,
            name: "django",
            organisation: "django",
            language: .Python,
            followers: 2300,
            stars: 52800,
            forks: 22800
        ),
        GithubRepo(
            id: 12,
            name: "airflow",
            organisation: "apache",
            language: .Python,
            followers: 716,
            stars: 18500,
            forks: 7200
        )
    ]
}
```

Now that we have the data, time to visualise it. Let's add some `SwiftUI` components for that.

Let's start by adding a list view, save the following code as `RepoList.swift`:

```swift
import SwiftUI

struct RepoList: View {
    var repos: [GithubRepo] = []

    var body: some View {
        NavigationView {
            List(repos) { repo in
                RepoRow(repo: repo)
            }
            .navigationBarTitle(Text("Repositories"), displayMode: .inline)
        }
    }
}

struct RepoList_Previews: PreviewProvider {
    static var previews: some View {
        RepoList(repos: GithubRepoRepository.shared.list())
    }
}
```

Notice the `RepoList_Previews` - it's a handy way to quickly preview your components without running the app!

As you can see, our list view uses another component, `RepoRow`. Let's add some code to `RepoRow.swift` to define it:

```swift
import SwiftUI

struct RepoRow: View {
    let repo: GithubRepo

    var body: some View {
        HStack {
            Image(imageName())
                .resizable().frame(width: 32, height: 32, alignment: .center)

            VStack(alignment: .leading, spacing: 7) {
                Text("\(repo.organisation) / ").font(.system(size: 20)).fontWeight(.light) +
                    Text(repo.name).font(.system(size: 20)).fontWeight(.bold)

                HStack(alignment: .lastTextBaseline) {
                    LabeledIcon(name: "arrow.branch", label: formatNumber(repo.forks))
                    LabeledIcon(name: "star", label: formatNumber(repo.stars))
                    LabeledIcon(name: "eye", label: formatNumber(repo.followers))
                }
            }
        }
    }

    private func formatNumber(_ value: Int) -> String {
        if (value < 1000) {
            return String(value)
        }

        if (value < 10000) {
            return "\(String(Double(value) / 1000))K"
        }

        return "\(String(value / 1000))K"
    }

    private func imageName() -> String {
        switch self.repo.language {
        case .Go:
            return "logo-go"
        case .Python:
            return "logo-python"
        case .TypeScript:
            return "logo-ts"
        }
    }
}
```

OK, now as you can see we are referencing some images with language logos, so let's add those to our project. Download and extract [LanguageLogos.zip](LanguageLogos.zip), then you should have the following files:

- `logo-go.png`
- `logo-python.png`
- `logo-typescript.png`

Now let's add them to our project:

1. Select **Assets.xcassets** in the navigation bar in Xcode, then click the **+** button in the bottom pane and finally click on the **Image Set**:

{{< figure src="6_imageset.png" alt="Xcode add new image set" >}}

2. Type `logo-go` as the name, then drag and drop the `logo-go.png` file to all sizes (1x, 2x and 3x) placeholders. Repeat the same for `logo-python` and `logo-typescript` and you should have the following result:

{{< figure src="7_imageset_added.png" alt="Xcode added imagesets" >}}

Lastly, there is one more component to add - the `LabeledIcon`. Let's add the following code and save it as `LabeledIcon.swift`:

```swift
import SwiftUI

struct LabeledIcon: View {
    let name: String
    let label: String

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: name).foregroundColor(.gray).imageScale(.small)
            Text(label).font(.system(.caption)).fontWeight(.ultraLight)
        }
    }
}
```

Voila! Now you can go ahead and try running the preview for `RepoList`. You should see something like this:

{{< figure src="8_preview.png" alt="Xcode RepoList preview" >}}

## Add microphone button and transcript text

Now that we have some data to work with and we can visualise it, time to add a button for activating the microphone and a simple component to display the transcript of what a user is saying.

Save the following code as `Microphone.swift`:

```swift
import SwiftUI

struct MicrophoneButton: View {
    let onStart: () -> Void
    let onStop: () -> Void

    var body: some View {
        ToggleButton(onDown: startRecording, onUp: stopRecording) {
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .overlay(
                    Image(systemName: "mic.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                )
        }.buttonStyle(Style())
    }

    private func startRecording() {
        self.onStart()
    }

    private func stopRecording() {
        self.onStop()
    }

    private struct Style: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 1.25 : 1.0)
                .animation(.easeInOut)
        }
    }
}

struct MicrophoneButton_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneButton(onStart: {}, onStop: {})
    }
}
```

And since it uses a `ToggleButton` component, let's add it as `ToggleButton.swift`:

```swift
import SwiftUI

struct ToggleButton<Content: View>: View {
    @State private var isDown = false

    let onDown: () -> Void
    let onUp: () -> Void
    let content: () -> Content

    var body: some View {
        Button(action: {}, label: {
            self.content()
        }).simultaneousGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { _ in
                    if self.isDown {
                        return
                    }

                    self.isDown = true
                    self.onDown()
                }
                .onEnded { _ in
                    self.isDown = false
                    self.onUp()
                }
        )
    }
}
```

And for the trasncript, let's add the following to `TranscriptText.swift`:

```swift
import SwiftUI
import Speechly

struct TranscriptText: View {
    let words: [SpeechTranscript]

    var body: some View {
        words.reduce(Text("")) { (acc, word) in
            acc + Text(" ") + Text(word.value).fontWeight(word.isFinal ? .bold : .light)
        }
    }
}

struct TranscriptText_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptText(words: [
            SpeechTranscript(
                index: 1,
                value: "SHOW",
                startOffset: TimeInterval(0),
                endOffset: TimeInterval(0.1),
                isFinal: true
            ),
            SpeechTranscript(
                index: 2,
                value: "ME",
                startOffset: TimeInterval(0),
                endOffset: TimeInterval(0.1),
                isFinal: true
            ),
            SpeechTranscript(
                index: 3,
                value: "ALL",
                startOffset: TimeInterval(0),
                endOffset: TimeInterval(0.1),
                isFinal: true
            ),
            SpeechTranscript(
                index: 4,
                value: "GO",
                startOffset: TimeInterval(0),
                endOffset: TimeInterval(0.1),
                isFinal: false
            ),
            SpeechTranscript(
                index: 5,
                value: "REPOS",
                startOffset: TimeInterval(0),
                endOffset: TimeInterval(0.1),
                isFinal: false
            )
        ])
    }
}
```

Notice that we are using a `SpeechTranscript` here - a type imported from `Speechly` package. We show final transcripts (those that won't change in the future) as bold and tentative (or non-final, meaning they can still change) as light to differentiate between them.

Finally, let's update our `ContentView.swift` and add our new components and a preview:

```swift
import SwiftUI
import Speechly

struct ContentView: View {
    let repos: [GithubRepo]
    let transcript: [SpeechTranscript]
    let startRecording: () -> Void
    let stopRecording: () -> Void

    var body: some View {
        VStack {
            TranscriptText(words: transcript)
            RepoList(repos: repos)
            MicrophoneButton(onStart: startRecording, onStop: stopRecording)
                .padding(.bottom, 15)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            repos: GithubRepoRepository.shared.list(),
            transcript: [
                SpeechTranscript(
                    index: 1,
                    value: "SHOW",
                    startOffset: TimeInterval(0),
                    endOffset: TimeInterval(0.1),
                    isFinal: true
                ),
                SpeechTranscript(
                    index: 2,
                    value: "ME",
                    startOffset: TimeInterval(0),
                    endOffset: TimeInterval(0.1),
                    isFinal: true
                ),
                SpeechTranscript(
                    index: 3,
                    value: "ALL",
                    startOffset: TimeInterval(0),
                    endOffset: TimeInterval(0.1),
                    isFinal: true
                ),
                SpeechTranscript(
                    index: 4,
                    value: "GO",
                    startOffset: TimeInterval(0),
                    endOffset: TimeInterval(0.1),
                    isFinal: false
                ),
                SpeechTranscript(
                    index: 5,
                    value: "REPOS",
                    startOffset: TimeInterval(0),
                    endOffset: TimeInterval(0.1),
                    isFinal: false
                )
            ],
            startRecording: {},
            stopRecording: {}
        )
    }
}
```

To make sure our project can still be built, we also need to update `SpeechlyRepoFilteringApp.swift`:

```swift
import SwiftUI

@main
struct SpeechlyRepoFilteringApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                repos: GithubRepoRepository.shared.list(),
                transcript: [],
                startRecording: {},
                stopRecording: {}
            )
        }
    }
}
```

Go ahead and build the project and then check out the `ContentView` preview. You should see something like this:

{{< figure src="9_preview_full.png" alt="Xcode ContentView preview" >}}

## Configure your Speechly application

Before we proceed with the app, let's take a quick detour and create our Speechly app.

Go to https://api.speechly.com/dashboard and login (or sign up if you haven't yet) and create a new app (you can [check our Speechly Dashboard quickstart guide](/quick-start/) if you feel lost).

Let's add a couple of simple commands for manipulating the data we see in the table:

- A command to filter by programming language, e.g., when a user says, "Show me TypeScript repos," the app will only show repos with that specific language.
- A command to sort the results in a specific order, e.g., "Sort the results by forks," will sort the repos by the number of forks it has.
- A command to reset the filters, e.g., "Reset the filters to default," will remove the language filter and reset the sorting to some default.

Let's add the following to our app configuration:

```
languages = [
    Go
    TypeScript
    Python
]

sort_fields = [
    name
    language
    followers
    stars
    forks
]

results = [
    items
    results
    repos
    repositories
]

*filter show {me} {[all | only]} $languages(language) {$results}
*filter filter {$results} by $languages(language) {language}

*sort [sort | order] {the} {$results} by $sort_fields(sort_field)

*reset [reset | remove] {[the | all]} {filters} {to default}
```

Don't forget to add `sort`, `filter`, and `reset` as intents and `languages` and `sort_fields` as entities!

As you can see from the comments, this configuration will make our Speechly app understand the commands we need and properly detect entities and intents. Keep in mind that the cool part is that the model will also be able to understand the variations of commands that are not explicitly defined in our configuration. The same also applies to entities - the app won't be limited to only detecting "Go", "TypeScript", and "Python" as options for the language, but other words as well, which will be roughly in the same place in a phrase. For instance, you could try saying, "Show me all Javascript repos"). However, with very domain-specific words, it's always a good idea to list them all in your configuration; otherwise, they might be mistaken for some regular words. For example, the API might not properly detect "Rust" as a programming language if you say, "Show me all Rust repositories," because it would think that you meant "rust" as that thing that destroys metals. You can read more about how to configure Speechly applications [in our documentation](/slu-examples/).

Now that we have our Speechly app deployed, let's integrate it!

## Integrate Speechly client

Let's use an observable pattern and create a manager which will handle Speechly connection and provide us with the recognition results. Add the following code to `SpeechlyManager.swift`:

```swift
import Foundation
import SwiftUI
import Speechly

class SpeechlyManager: ObservableObject {
    let client: SpeechClient
    var active: Bool

    @Published var transcript: [SpeechTranscript] = []
    @Published var filter: GithubRepoFilter = GithubRepoFilter.empty

    init() {
        self.active = true
        self.client = try! SpeechClient(
            appId: UUID(uuidString: "your-speechly-app-id")!,
            language: .enUS
        )

        self.client.delegate = self
    }

    func start() {
        if !self.active {
            return
        }

        self.client.start()
    }

    func stop() {
        if !self.active {
            return
        }

        self.client.stop()
    }

    func suspend() {
        if self.active {
            self.client.suspend()
            self.active = false
        }
    }

    func resume() {
        if !self.active {
            try! self.client.resume()
            self.active = true
        }
    }
}

extension SpeechlyManager: SpeechClientDelegate {
    func speechlyClientDidStart(_: SpeechClientProtocol) {
        DispatchQueue.main.async {
            self.transcript = []
        }
    }

    func speechlyClientDidStop(_: SpeechClientProtocol) {
        DispatchQueue.main.async {
            self.transcript = []
        }
    }

    func speechlyClientDidUpdateSegment(_ client: SpeechClientProtocol, segment: SpeechSegment) {
        DispatchQueue.main.async {
            switch segment.intent.value.lowercased() {
            case "filter":
                self.filter = GithubRepoFilter(
                    languageFilter: self.parseLanguageFilter(segment),
                    sortOrder: self.filter.sortOrder
                )
            case "sort":
                self.filter = GithubRepoFilter(
                    languageFilter: self.filter.languageFilter,
                    sortOrder: self.parseSortOrder(segment)
                )
            case "reset":
                self.filter = GithubRepoFilter.empty
            default:
                break
            }

            self.transcript = segment.transcripts
        }
    }

    private func parseSortOrder(
        _ segment: SpeechSegment, defaultOrder: GithubRepoFilter.SortOrder = GithubRepoFilter.empty.sortOrder
    ) -> GithubRepoFilter.SortOrder {
        var order = defaultOrder

        for e in segment.entities {
            if e.type.lowercased() != "sort_field" {
                continue
            }

            switch e.value.lowercased() {
            case "name":
                order = .name
            case "language":
                order = .language
            case "followers":
                order = .followers
            case "stars":
                order = .stars
            case "forks":
                order = .forks
            default:
                continue
            }
        }

        return order
    }

    private func parseLanguageFilter(_ segment: SpeechSegment, initialValue: [GithubRepo.Language] = []) -> [GithubRepo.Language] {
        var languages = initialValue

        for e in segment.entities {
            if e.type.lowercased() != "language" {
                continue
            }

            switch e.value.lowercased() {
            case "go":
                languages.append(.Go)
            case "python":
                languages.append(.Python)
            case "typescript":
                languages.append(.TypeScript)
            default:
                continue
            }
        }

        return languages
    }
}
```

Make sure you update the language and the app id in the initialiser!

Now, there's a lot to explain here, so here's the gist:

- `SpeechlyManager` creates our client. To initialise the client you need to pass at least `appId` and `language`, which you can find from the app page in the dashboard.
- To enable the microphone and start sending data to the API you should use `client.start()` method. Similarly, you use `client.stop()` for stopping current call.
- To receive recognition results (and also some status updates and errors) you need to implement the `SpeechClientDelegate` pattern and pass the delegate to the client. Our manager uses `speechlyClientDidUpdateSegment` to react to recognition results and `speechlyClientDidStart` / `speechlyClientDidStop` for resetting current transcript. Note also the usage of `DispatchQueue.main` - this is a requirement of the platform that observable values should only be updated from the main dispatch queue.
- To handle the results, you would need to parse them, relying on intent values and entity types / values.
- `client.suspend()` and `client.resume()` provide functionality for suspending and resuming the client execution - this will come in handy later!
- Check out [this article in our documentation](/speechly-api/#understanding-server-responses) for more information about how SLU API works!

As you probably noticed, we are using a `GithubRepoFilter` as a container for our filters, but we haven't defined it yet. Let's do that! Add the following to `GithubRepoFilter.swift`:

```swift
import Foundation

class GithubRepoFilter {
    enum SortOrder {
        case name, language, followers, stars, forks
    }

    static let empty = GithubRepoFilter(languageFilter: [], sortOrder: .name)

    var languageFilter: [GithubRepo.Language]
    var sortOrder: SortOrder

    init(languageFilter: [GithubRepo.Language], sortOrder: SortOrder) {
        self.languageFilter = languageFilter
        self.sortOrder = sortOrder
    }

    func apply(_ input: [GithubRepo]) -> [GithubRepo] {
        var res = input

        if self.languageFilter.count > 0 {
            res = res.filter { repo in
                self.languageFilter.contains(repo.language)
            }
        }

        return res.sorted { (left, right) in
            switch self.sortOrder {
            case .name:
                return left.name < right.name
            case .language:
                return left.language.rawValue < right.language.rawValue
            case .followers:
                return left.followers < right.followers
            case .stars:
                return left.stars < right.stars
            case .forks:
                return left.forks < right.forks
            }
        }
    }
}
```

Nothing fancy here - just some logic for sorting and filtering an array of `GithubRepo` structs!

## Tying everything together

Now that we have all the pieces ready, let's tie them all together in our `SpeechlyRepoFilteringApp.swift`! Let's update it with the following code:

```swift
import SwiftUI
import Speechly

@main
struct RepoFilteringApp: App {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var speechlyManager = SpeechlyManager()

    var body: some Scene {
        WindowGroup {
            ContentView(
                repos: self.speechlyManager.filter.apply(GithubRepoRepository.shared.list()),
                transcript: self.speechlyManager.transcript,
                startRecording: self.speechlyManager.start,
                stopRecording: self.speechlyManager.stop
            )
        }.onChange(of: self.scenePhase) { newPhase in
            switch newPhase {
            case .background:
                self.speechlyManager.suspend()
            case .active:
                self.speechlyManager.resume()
            default:
                break
            }
        }
    }
}
```

A couple of things going on here:

- We use the `@ObservedObject` to observe the state of `SpeechlyManager`. This will automatically update our app with new values of `filter` and `transcript` properties defined by the manager.
- We use the `@Environment(\.scenePhase)` to track the state of our main (and only) scene phase and react when the scene (and thus the application) enters background state (i.e. it gets suspended by the OS) and leaves it. We use this to suspend and resume our Speechly client - this ensures that we release the microphone and disconnect from the API when those resources are not needed.

## Conclusion

And that's it! Now you can build the app and run it in the simulator. Keep in mind that many of the `SwiftUI` features are only available on iOS 14.0 and above, so make sure to pick the appropriate simulator target.

Go ahead and try out your app - you can filter the repos by language, apply a sorting order, and reset the filters:

{{< figure src="10_simulator.png" alt="App running in iOS Simulator" >}}

If you want to delve into the details, go ahead and check out [our documentation](https://docs.speechly.com/) and [our public GitHub](https://github.com/speechly).

You can also find the source code for this tutorial at https://github.com/speechly/ios-repo-filtering - feel free to poke around or use it as a starter for your next Speechly app!
