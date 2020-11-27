---
title: Speechly React client
description: The official Speechly client for React apps
display: article
weight: 1
aliases: ["/client-libraries/react-client/"]
menu:
  integrations:
    title: React
    weight: 2
---

{{< button "/client-libraries/react/tutorial/" "flash-outline" "light" "Tutorial" >}}
{{< button "https://github.com/speechly/react-client" "logo-github" "light" "GitHub" >}}

Speechly React client uses the power of React Context and React Hooks to make it super easy to integrate Speechly into your app.

{{< info title="Supported browsers">}} Please refer to [Supported Browsers](/client-libraries/supported-browsers/) to learn about compability. {{</info>}}

## Installation

You can use NPM or Yarn to install the client, here's how:

```shell
# Create a new React app
create-react-app .

# Install Speechly client
npm install --save @speechly/react-client
```

## Usage

Using the client is super simple, just import the context provider and a hook, pass the app id and the language and your good to go!

```typescript
import React from "react";
import { SpeechProvider, useSpeechContext } from "@speechly/react-client";

export default function App() {
  return (
    <div className="App">
      <SpeechProvider appId="my-app-id" language="my-app-language">
        <SpeechlyApp />
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
      <div className="mic-button">
        <button onClick={toggleRecording}>Record</button>
      </div>
    </div>
  );
}
```
