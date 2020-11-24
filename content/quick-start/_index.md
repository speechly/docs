---
title: Quick Start
description: The Speechly Quick Start helps you get started on developing with Speechly Dashboard. 
weight: -999
display: article
category: "User guide"
menu:
  sidebar:
    title: "Quick Start"
    weight: 2
---

# What is Speechly?

Speechly is a tool for building real-time multi modal voice user interfaces for touch screens and web applications. 

Speechly improves your application's user experience by adding a natural and intuitive way of interacting with it.

This tutorial walks you through building your first Speechly voice application and testing it out in Speechly Playground. 

You can read more on [Speechly website](https://www.speechly.com/).

{{< figure src="developing-applications-docs.png">}}

--- 
**Are you a developer? Jump straight into a tutorial!**

{{< button "/client-libraries/react/tutorial" "flash-outline" "light" "React Tutorial" >}}

--- 

## Welcome to Speechly Quick Start!

{{<youtube PVYEMqnykro>}}

Video Quick Start

This Quick Start will guide you through the basics of building Spoken Language Understanding models with Speechly Dashboard. It covers the following steps:

1. **[Creating an application](#1-creating-an-application)**
2. **[Creating your first SLU configuration](#2-deploying-your-first-slu-model)**
3. **[Trying out the application in the Speechly Playground](#3-trying-out-the-application)**
4. **[Integrating Speechly to your application](#learn-more)**

The best way to start developing with Speechly is to complete this Quick Start.

### 1 Creating an application

The first step is to navigate to the [Speechly Dashboard](https://www.speechly.com/dashboard/) in order to create an account and accept the terms and conditions. 

{{< figure src="create_account.png" class="is-half" img-class="no-zoom" title="Creating a Speechly account screenshot." alt="Screenshot from the Speechly Dashboard signup screen">}}

After creating a user account, you will land on the Speechly Dashboard main page, where you manage your applications.

Proceed to creating a new application by clicking the blue `Create application` button. 

{{< figure class="is-128x128" src="dashboard.png" title="The Speechly Dashboard screenshot." alt="Screenshot from the Speechly Dashboard opening screen" >}} 

Name your application, select English as the language and `Home Automation` as the template.

{{< figure src="new_application.png" title="New Speechly application screenshot." alt="Screenshot from the Speechly Dashboard New Application screen">}}

### 2 Deploying your first SLU model

{{< figure src="rule-editor.png" title="The SLU Example configuration view." alt="Screenshot from the Speechly Dashboard SLU Example configuration view">}}

A Speechly application is configured by providing it with a set of annotated example utterances. Your Home Automation application contains a ready-made configuration that you can deploy by clicking the blue `Deploy` button in the bottom right corner of the screen. 

The deploying should take 1-2 minutes. 

{{< figure src="utterance-intent-entities.png" title="An utterance annotated using the Speechly Annotation Language." alt="A figure explaining one utterance with its intent and entities tagged by using Speechly Annotation Language">}}

{{< info title="Advanced SLU Examples" >}} Please take a look at [advanced SLU examples](https://www.speechly.com/docs/slu-examples/editing-slu-examples/#advanced-syntax-features) to learn more about the [SAL syntax](/slu-examples/editing-slu-examples/).{{< /info >}}

### 3 Trying out the application

Once the application has been deployed, the `Try` button next to `Deploy` should turn active, and the status bar shows a green dot reading "Deployed". Now it's time to test your application, so click `Try` to go to the Playground.

Click on `Tap to start` on the bottom of the page, and give your browser the permissions to use the microphone. A microphone button appears.

{{<videoloop src="permissions-in-playground.webm" >}}

Now you can click and hold the microphone to start sending audio to the Speechly API. Click and hold either the microphone button or the space bar and say, "Switch off the lights in the kitchen." You'll now see the transcript of what you said along with the intent (`turn_off`) and the entities (`lights` and `kitchen`).

You're done! Now you can continue trying out different utterances. Or else, you can go back to the configuration screen to edit your example phrases in order to teach your model to understand a greater variety of commands. 

### Learn more!

Next, you can try adding a new intent to the configuration. A useful function to add to a Home Automation application could be that of adjusting the brightness of the lights. Add a new intent, say, `set_brightness`, which can change the light brightness to a value ranging from 1 to 100 in different rooms. You can learn more about the SAL syntax [here](/slu-examples/editing-slu-examples/).

### React Tutorial 

Learn how you can create a simple React application with a real-time multimodal voice user interface.

[Read more &raquo;](/client-libraries/react-client/)

