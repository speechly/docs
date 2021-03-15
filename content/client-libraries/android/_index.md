---
title: Android Client Library
description:  The official Speechly client libraries for Android clients. 
weight: 9
display: article
category: "User guide"
menu:
  integrations:
    title: "Android"
    weight: 5
---

{{< button "https://github.com/speechly/android-repo-filtering" "flash-outline" "light" "Tutorial" >}}
{{< button "https://github.com/speechly/android" "logo-github" "light" "GitHub" >}}

This is the documentation for Speechly Android client library for building natural user interfaces with Android.

### Requirements

* Android 8.0 (API level 26) and above

## Usage

### Configuration

Add android-client to your build.gradle dependencies.

```gradle
dependencies {
  implementation 'com.speechly:android-client:0.1.7'
}
```

### Client usage

```kotlin
val speechlyClient: Client = Client.fromActivity(activity = this, UUID.fromString("yourkey"))
```

Check out the [example repo filtering app](https://github.com/speechly/android-repo-filtering) for a demo app built using this client.
