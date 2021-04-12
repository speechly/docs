---
title: Speechly libraries overview
description: Select the right integration library
weight: 3
category: "References"
display: article
menu:
  sidebar:
    title: "Speechly libraries"
    parent: "Development tools"
---

Our development library offering consists of
- Client libraries,
- precomplied gRPC stubs, and
- raw gRPC protocol definitions.

# Which one should I use?
**For most users we recommend the [Client libraries](/client-libraries)**, as they are the most comprehensive, and provide the fastest path to integrating your application with Speechly. Client libraries are available for **Web (vanilla JS)**, **React (Typescript)**, **iOS (Swift)** and **Android (Kotlin)**.

The Client libraries take care of audio capture, bidirectional streaming, authentication, and other technical complexities. We also provide some common UI components (a microphone button, transcript view) that come bundled with the Client libraries.

For other platforms / programming languages you must rely on our [gRPC API](/speechly-api/). We provide [precomiled gRPC stubs](https://github.com/speechly/api), some of which (e.g. Python and node.js) are available through a package manager (pip, npm). Unlike the Client libraries, these provide no additional functionality besides interacting with the Speechly gRPC API. We recommend these for advanced use-cases where none of the Client libraries can be used.

Finally, the [gRPC protocol definitions](https://github.com/speechly/api/tree/master/proto) are there for you if none of the previous solutions suits your requirements. We only recommend these for users who know their way around gRPC.

The table below provides a comparison of the libraries in terms of features and support.

|   | Client libraries | gRCP stubs | gRPC protos|
| - | --------------- | --------------- | ---- |
| simple audio capture and streaming | YES | NO | NO |
| custom UI components | YES | NO | NO |
| Client API | YES | NO | NO |
| available via a package manager | YES | YES | NO |
| integration examples | YES | YES | NO |
| documentation | YES | YES | YES |
