
---
title: React Microphone Component
description: Ready-made microphone component for React
display: article
---

# Speechly Push-to-Talk Button Beta
​
Speechly Push-to-Talk Button Beta is a React component that enables users to use Speechly voice input while holding the button down.

The Push-to-Talk button is intended to be placed as a floating button at the lower part of the screen so mobile users can react it with ease. Desktop users can control it with an optional keyboard hotkey. Our hotkey recommendation is the spacebar.

These instructions assume that you have a working Speechly app created by following instructions in our [tutorial](https://github.com/speechly/react-client)

Upon launching the app, the component initially displays a "power on" state. Pressing the button in "power on" state initialises Speechly API and may trigger browser microphone permission prompt.
​
The component has been tested with Chrome on desktop (version 86), Chrome on Android and Safari on iOS.
​
## Requirements
​
- A working Speechly React app skeleton created using instructions from here: https://github.com/speechly/react-client
- The above app skeleton should contain a working Speechly `app-id` obtained from the [Dashboard](https://api.speechly.com/dashboard). For testing, you can use the Home Automation voice interface example.
- Speechly Push-to-Talk Button files that you can download [here](../SpeechlyPushToTalkButton.zip)
- [react-spring](https://www.react-spring.io/)
​
## Installation
​
### Add Speechly Push-to-Talk Button files to your project
​
Extract [SpeechlyPushToTalkButton.zip](../SpeechlyPushToTalkButton.zip) into your React app's `src` folder. This will add the following files:
​
- `components/Mic.js`
- `components/Mic.css`
​
### Install react-spring
​
Speechly Push-to-Talk Button uses react-spring for responsive animation
​
```
npm install --save react-spring
```
​
### Include the Speechly Push-to-Talk Button in `App.js`
​
Add the following line somewhere in `App.js` header:
​
```
import Mic from "./components/Mic";
```
​
### Add the Speechly Push-to-Talk Button in your component tree
​
Add the following row in App.js, inside `<SpeechProvider/>`.
​
Optionally provide a `captureKey` property to control the tangent button with a key.
​
```
<Mic captureKey=" " />
```
​
## Testing
​
- Start your react app, e.g. with `npm start`
- Tap the `Power on` button
- Give the app permission to use the microphone
- Press and hold the `Mic` button
- While holding the `Mic` button, say a test utterance like `Turn on light in the living room`.
- You should see the text transscript for your utterance displayed in real time at the top of your app window: `TURN ON LIGHT IN THE LIVING ROOM`
​
## Customization
​
Mic widget placement can be customized with css in Mic.css
​
- Mic widget size is defined by `width` and `height` of `.MicWidget`.
- Distance from bottom of the screen is defined by `height` of `.MicContainer`.
- Colors are defined by `.GradientStop1` and `.GradientStop2`
- If you created the app skeleton using the react-client tutorial, you may wish to remove the following lines containing the default button for toggling speech recording:
​
```
<div className="mic-button">
  <button onClick={toggleRecording}>Record</button>
</div>
```
​
## Putting it all together
​
The complete listing of App.js should look something like this:
​
```
import React from "react";
import { SpeechProvider, useSpeechContext } from "@speechly/react-client";
import Mic from "./components/Mic";
​
export default function App() {
  return (
    <div className="App">
      <SpeechProvider
        appId="<my-app-id-here>"
        language="en-US"
      >
        <SpeechlyApp />
        <Mic captureKey=" " />
      </SpeechProvider>
    </div>
  );
}
​
function SpeechlyApp() {
  const { speechState, segment, toggleRecording } = useSpeechContext();
​
  return (
    <div>
      <div className="status">{speechState}</div>
      {segment ? (
        <div className="segment">
          {segment.words.map((w) => w.value).join(" ")}
        </div>
      ) : null}
    </div>
  );
}
```