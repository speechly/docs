---
title: Client Libraries
description: Available for Web, React, iOS, and Android.
weight: 3
category: "References"
display: article
menu:
  sidebar:
    title: "Client Libraries"
---
The Client libraries take care of audio capture, bidirectional streaming, authentication, and other technical complexities. They also come bundled with common UI components (a microphone button, transcript view).

# Installing and using the Client Libraries
See [Basic usage instructions](usage) to learn how to install and use the Client libraries.

All Client libraries also adhere to the same [high-level API](client-api-reference). There are some platform specific differences, but conceptually we have tried to make the Clients as similar as possible. If you know how to use one, getting started with another should be easy (provided both platforms are familiar to you).

# Web Speech API polyfill
We also provide a [Web Speech API](https://wicg.github.io/speech-api/) compliant speech recognition [polyfill](https://github.com/speechly/speech-recognition-polyfill) that uses our API as the backend. It does not come bundled with UI components, nor does it provide any natural language processing functionalities that are available with the other Client Libraries. But it is a good choice if you only need cross-browser compliant speech-to-text in your web application.

# More information
Our Client libraries are open source. You can find more information about them as well as other usage examples on Github:
- [Web client](https://github.com/speechly/browser-client)
- [React client](https://github.com/speechly/react-client)
- [iOS client](https://github.com/speechly/ios-client)
- [Android client](https://github.com/speechly/android-client)
- [Web Speech API polyfill](https://github.com/speechly/speech-recognition-polyfill)

We are very happy to receive pull requests to the above repositories, but it is a good idea to be in touch with us first, for example by opening an issue or by sending email to hello@speechly.com.
