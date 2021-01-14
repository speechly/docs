---
title: React Client Usage Guide
description: Learn to use Speechly React Client Library
display: article
draft: true
---

This usage guide will explain how to integrate Speechly client into your React app and consume the recognition results. It doesn't showcase an end-to-end experience of building an app with Speechly, for that we recommend you go check out our [tutorial](/client-libraries/react/tutorial/). 

## Installing the client

In order to use Speechly in your app, you will have to install the client library to your project by using npm:

```terminfo
$ npm install --save @speechly/react-client
````

## Integrating the client

To integrate the client to your application, you'll need to first import the `SpeechProvider` component:

```react
import { SpeechProvider, useSpeechContext } from '@speechly/react-client'
```

Then use the SpeechProvider component and configure it with the application ID and language of your Speechly application. You'll get the application ID from the [Speechly Dashboard](/quick-start/)

```react
export default function App() {
  return (
    <div className="App">
      <SpeechProvider appId="my-app-id" language="my-app-language">
        <SpeechlyApp />
      </SpeechProvider>
    </div>
  )
}
```





