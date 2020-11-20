---
title: React Client
description:  The official Speechly client libraries for React clients. 
display: article
weight: 1
aliases: ["/client-libraries/react-client/"]
menu:
  sidebar:
    title: "React Client"
    weight: 1
    parent: "Client Libraries"
---

{{< button "/client-libraries/react/tutorial/" "flash-outline" "light" "React Tutorial" >}}

{{< button "https://github.com/speechly/react-client" "logo-github" "light" "GitHub" >}}

Speechly is a developer tool for building real-time voice user interfaces for touch screen and web applications.

After you've [configured your application](/quick-start/) and have it's App ID available, you can integrate it to your application. 

{{< youtube "xI68NT8D1m8" >}}
*e-Commerce demo built on Speechly React Client* 

## Usage

Install the package:

```shell
# Create a new React app
create-react-app .

# Install Speechly client
npm install --save @speechly/react-client
```

Start using the client:

```typescript
import React from 'react'
import { SpeechProvider, useSpeechContext } from '@speechly/react-client'

export default function App() {
  return (
    <div className="App">
      <SpeechProvider appId="my-app-id" language="my-app-language">
        <SpeechlyApp />
      </SpeechProvider>
    </div>
  )
}

function SpeechlyApp() {
  const { speechState, segment, toggleRecording } = useSpeechContext()

  return (
    <div>
      <div className="status">{speechState}</div>
      {segment ? <div className="segment">{segment.words.map(w => w.value).join(' ')}</div> : null}
      <div className="mic-button">
        <button onClick={toggleRecording}>Record</button>
      </div>
    </div>
  )
}
```

Check out the [react-example-repo-filtering](https://github.com/speechly/react-example-repo-filtering) repository for a demo app built using this client.



