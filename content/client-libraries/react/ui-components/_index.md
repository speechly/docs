---
title: Speechly React UI components
description: Ready-made UI components for React apps
display: article
menu:
  integrations:
    title: UI components
    weight: 2
    parent: Speechly React client
---

{{< button "https://github.com/speechly/react-ui" "logo-github" "light" "GitHub" >}}

&nbsp;

Speechly React UI components library provides developers with resusable pieces for building Speechly-powered apps. Those components currently include a microphone button component, and a transcript visualisation component.

## Installation

```sh
# Create a new React app
create-react-app .

# Install the package
npm install --save @speechly/react-ui

# Install peer dependencies
npm install --save @speechly/react-client
npm install --save react-spring
npm install --save styled-components @types/styled-components
```

## Push-to-Talk button

Push-to-Talk button is a React component that enables users to use Speechly voice input while holding the button down.

Upon launching the app, the component initially displays a "power on" state. Pressing the button in "power on" state initialises Speechly API and may trigger browser microphone permission prompt.

### Usage

Import the button and the container and add it to your app. Make sure you place it inside your `SpeechProvider` component, since the button uses the speech context hook internally.

```tsx
import React from "react";
import { SpeechProvider, useSpeechContext } from "@speechly/react-client";
import { PushToTalkButton, PushToTalkContainer } from "@speechly/react-ui";

export default function App() {
  return (
    <div className="App">
      <SpeechProvider
        appId="<my-app-id-here>"
        language="<my-app-language-here>"
      >
        <SpeechlyApp />
        <PushToTalkContainer>
          <PushToTalkButton captureKey=" " />
        </PushToTalkContainer>
      </SpeechProvider>
    </div>
  );
}

function SpeechlyApp() {
  const { speechState, segment, toggleRecording } = useSpeechContext();
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

The button is intended to be placed as a floating button at the lower part of the screen so mobile users can react it with ease. Desktop users can control it with an optional keyboard hotkey. Our hotkey recommendation is the spacebar. Use the `captureKey` parameter to specify a different hotkey.

### Customisation

- Mic widget size is defined by `size` property. Parameters are in css, e.g. `6rem`:

```tsx
<PushToTalkButton size="6rem" />
```

- Colors are defined by `gradientStops` property. Parameter is an array of 2 colors, e.g. `["#aaa","#ddd"]`:

```tsx
<PushToTalkButton gradientStops={["#aaa", "#ddd"]} />
```

## BigTranscript component

BigTranscript is a React component that displays the transcribed voice input of a user to provide them with feedback from your Speechly app.

### Usage

```tsx
import React from "react";
import { SpeechProvider, useSpeechContext } from "@speechly/react-client";
import {
  BigTranscript,
  BigTranscriptContainer,
  PushToTalkButton,
  PushToTalkContainer,
} from "@speechly/react-ui";

export default function App() {
  return (
    <div className="App">
      <SpeechProvider
        appId="<my-app-id-here>"
        language="<my-app-language-here>"
      >
        <BigTranscriptContainer>
          <BigTranscript />
        </BigTranscriptContainer>

        <SpeechlyApp />

        <PushToTalkContainer>
          <PushToTalkButton captureKey=" " />
        </PushToTalkContainer>
      </SpeechProvider>
    </div>
  );
}

function SpeechlyApp() {
  const { speechState, segment, toggleRecording } = useSpeechContext();

  if (segment) {
    console.log("Received a new segment!");

    // Handle the intent.
    console.log("Intent:", segment.intent);

    // Handle the entities.
    console.log("Entities:", segment.entities);
  }

  return <div>My Speechly app</div>;
}
```

### Customisation

Styling like colors can be assigned to `.BigTranscript` container class and to different entity types by using `.Entity.<EntityName>` selector. Replace `<EntityName>` with the exact entity name defined in your SAL.

```css
.BigTranscript {
  color: #fff;
  font-family: "Organetto";
  font-size: 1.4rem;
  line-height: 1.15;
}

.BigTranscript .Entity.room {
  color: #1fd3f3;
}

.BigTranscript .Entity.device {
  color: #1fd3f3;
}
```
