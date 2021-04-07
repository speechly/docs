---
title: Basic usage
description: All Speechly Client Libraries follow the design paradigm outlined below.
display: article
category: "User guide"
weight: 1
menu:
  sidebar:
    title: "Basic usage"
    parent: "Client Libraries"
---

# Import the client library
Import and instantiate the client library.
<div class="tab">
  <button class="tablinks WebClient active" onclick="openTab(event, 'WebClient')">Web Browser</button>
  <button class="tablinks React" onclick="openTab(event, 'React')">React</button>
  <button class="tablinks Android" onclick="openTab(event, 'Android')">Android</button>
</div>

<div id="WebClient-import" class="tabcontent code" style="display: block;">
Include the resources in your <code>head</code> block:
{{< highlight html >}}
<head>
  <script type="text/javascript" src="https://speechly.github.io/browser-ui/v1/push-to-talk-button.js"></script>
  <script type="text/javascript" src="https://speechly.github.io/browser-ui/v1/big-transcript.js"></script>
  <link rel="stylesheet" href="https://speechly.github.io/browser-ui/v1/speechly-ui.css">
</head>
{{< /highlight >}}
</div>

<div id="React-import" class="tabcontent code">
{{< highlight typescript >}}
import React from "react";
import { SpeechProvider, useSpeechContext } from "@speechly/react-client";
{{< /highlight >}}
</div>

<div id="Android-import" class="tabcontent code">
Add android-client to your build.gradle dependencies.
{{< highlight gradle >}}
dependencies {
  implementation 'com.speechly:android-client:latest'
}
{{< /highlight >}}

Import the client, as well as the <code>SpeechlyButton</code>.
{{< highlight kotlin >}}
import com.speechly.client.speech.Client
import com.speechly.client.slu.*
import com.speechly.ui.SpeechlyButton
{{< /highlight >}}

Instantiate the client in your main activity
and add a <code>SpeechlyButton</code>.
Make sure to replace <code>YOUR_APP_ID_HERE</code>
with the correct Speecly app id.
{{< highlight kotlin >}}
private val speechlyClient: Client = Client.fromActivity(
        activity = this,
        UUID.fromString("YOUR_APP_ID_HERE")
)

private var button: SpeechlyButton? = null
{{< /highlight >}}
</div>

# Take UI components to use
We provide ready-made UI components that implement a Push-to-Talk Button for
starting and stopping voice recording, and a display component for showing the returned transcript.
<div class="tab">
  <button class="tablinks WebClient active" onclick="openTab(event, 'WebClient')">Web Browser</button>
  <button class="tablinks React" onclick="openTab(event, 'React')">React</button>
  <button class="tablinks Android" onclick="openTab(event, 'Android')">Android</button>
</div>

<div id="WebClient-loadui" class="tabcontent code" style="display: block;">
Include the following lines in your <code>body</code>:
{{< highlight html >}}
<div class="BigTranscriptContainer">
  <big-transcript></big-transcript>
</div>
<div class="PushToTalkContainer">
  <push-to-talk-button appid="your-app-id-comes-here"></push-to-talk-button>
</div>
{{< /highlight >}}
</div>

<div id="React-loadui" class="tabcontent code">
{{< highlight typescript >}}
TODO
{{< /highlight >}}
</div>

<div id="Android-loadui" class="tabcontent code">
In your main activity,
define a touch listener that
activates and deactivates audio transmission.
Also, in the <code>onCreate</code> method
assign this listener to <code>SpeechlyButton</code>.
{{< highlight kotlin >}}
private var buttonTouchListener = object : View.OnTouchListener {
    override fun onTouch(v: View?, event: MotionEvent?): Boolean {
        when (event?.action) {
            MotionEvent.ACTION_DOWN -> {
                speechlyClient.startContext()
            }
            MotionEvent.ACTION_UP -> {
                speechlyClient.stopContext()
            }
        }
        return true
    }
}

override fun onCreate(savedInstanceState: Bundle?) {
    ...
    this.button = findViewById(R.id.speechly)
    this.button?.setOnTouchListener(buttonTouchListener)
    ...
}
{{< /highlight >}}
</div>

# Handle speech input
The basic idea of the client-side API is to provide a “live view” to the ongoing speech segment. This is done by registering a callback function that receives a <code>Segment</code> data structure as argument. This data structure represents the ongoing speech segment. Also see our [Client API reference](/client-libraries/client-api-reference/).

After an audio context has started, callback is called every time the Speechly API returns an event that updates the currently ongoing segment.
<div class="tab">
  <button class="tablinks WebClient active" onclick="openTab(event, 'WebClient')">Web Browser</button>
  <button class="tablinks React" onclick="openTab(event, 'React')">React</button>
  <button class="tablinks Android" onclick="openTab(event, 'Android')">Android</button>
</div>

<div id="WebClient-callback" class="tabcontent code" style="display: block;">
Listen for the broadcasted updates to <code>SpeechSegment</code>.
{{< highlight html >}}
<script type="text/javascript">
  window.addEventListener("message", (e) => {
    if (e.data.type === "segment-update") {
      const segment = e.data.segment;
      console.log("segment-update message:", segment);
    }
  });
</script>
{{< /highlight >}}
</div>

<div id="React-callback" class="tabcontent code">
{{< highlight typescript >}}
TODO
{{< /highlight >}}
</div>

<div id="Android-callback" class="tabcontent code">
In the <code>onCreate</code> method,
define the callback to be used for handling a <code>Segment</code>.
{{< highlight kotlin >}}
override fun onCreate(savedInstanceState: Bundle?) {
    ...
    GlobalScope.launch(Dispatchers.Default) {
        speechlyClient.onSegmentChange { segment: Segment ->
            // segment handling logic goes here
            ...
        }
    }
    ...
}
{{< /highlight >}}
For more details, please see our <a href="/client-libraries/client-api-reference/">Client API reference</a>,
as well as the <a href="https://github.com/speechly/android-client/blob/main/client/src/main/kotlin/com/speechly/client/slu/Segment.kt">source code of Segment on Github</a>.
</div>

# Learn more!

Learn how to [configure](/slu-examples/) your own application.

For descriptions of complete example applications built using the client libraries,
please see our [tutorials](/tutorials/).
