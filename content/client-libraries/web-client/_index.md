---
title: Browser Client
description: The official Speechly client libraries for browser clients.
display: article
menu:
  sidebar:
    title: "Browser Client"
    weight: 1
    parent: "Client Libraries"
---

{{< button "/client-libraries/web-client/tutorial/" "flash-outline" "light" "Browser Client Tutorial" >}}

{{< button "https://github.com/speechly/browser-client" "logo-github" "light" "GitHub" >}}

{{< info title="See it in action" >}} You can see the Speechly Browser Client in action [here](https://speechly.github.io/browser-client-example/).
 {{< /info >}}

## Web Client Quick Start

{{<warning title="Developing on Windows?">}}If you are developing on Windows, you can install Linux on a virtual machine by following [these instructions](https://itsfoss.com/install-linux-in-virtualbox/). {{</warning>}}

0. In order to install the Speechly Browser Client, you'll first need to have some common developer tools installed. These include [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [NodeJS](https://nodejs.org/en/). You'll also need a Speechly app ID, which you get by signing up to the [Speechly Dashboard](/quick-start).

1.  Clone the `browser-client-example` [Github repository](https://github.com/speechly/browser-client-example) to your home directory, and move on to the directory where the `browser-client-example` is cloned.

```terminfo
$ cd ~ && git clone https://github.com/speechly/browser-client-example/ && cd browser-client-example
```

2. Install the dependencies required for the Speechly Browser Client Example by using Yarn.

```terminfo
$ yarn install
```

3. You'll find your application ID on the Speechly Dashboard. Make sure your application status is `Deployed`.

{{< figure src="appid.png" alt="Speechly SLU Examples configuration view showing Speechly app id" title="The app ID is encircled in blue." >}}

4. Add your application ID and the model language to environmental variables. By default, your app language is `en-US`, but it can be configured in the Speechly Dashboard. You can see the app language next to your app ID.

```terminfo
$ export REACT_APP_APP_ID="your-app-id" 
```
```terminfo
$ export REACT_APP_LANGUAGE="your-app-language" 
```

5. Start the web application.

```terminfo
$ yarn start
```

{{< figure src="speechly-web-client-starting-succesfully.png" alt="Speechly Web Client example app starting in terminal" title="You should see the Speechly web client starting on your local machine." >}}

7. If your browser doesn't do it automatically, open your browser and navigate to the address visible in the terminal window. This address is likely to be `http://localhost:3000` .

8. Click `Connect`, and give permission to allow your browser to use the microphone. Then click and hold the `Record` button, and say utterances that your model understands. Once you start speaking, you should be able to see the tentative transcript, intents, and entities, until finalized as per Speechly [SLU loop](/speechly-api/#slu-event-loop). 

{{<videoloop src="book-demo-no-sound.mp4">}}
