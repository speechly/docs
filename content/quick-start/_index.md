---
title: Quick Start
description: The Speechly Quick Start helps you get started on developing with Speechly Dashboard. 
weight: 1
display: article
category: "User guide"
menu:
  sidebar:
    title: "Quick Start"
---
Below are three different ways for you to start trying out Speechly. They are self-contained, and you can freely choose which one you would like to start with. However, the first one (Video Quick Start) is recommended for everyone.

# 1) Video Quick Start

This Quick Start will guide you through the basics of building Spoken Language Understanding models with Speechly Dashboard. It covers the following steps:

1. Creating an application
2. Creating your first Configuration
3. Trying out the application in the Speechly Playground

{{<youtube PVYEMqnykro>}}

# 2) Web Integration Quick Start

A walk-through on integrating Speechly to a Web based application can be found in this [simple and plain but very informative tutorial](https://speechly.github.io/browser-ui/v1/). You can either use the ready-made Application Id on the page (Usage section), or replace this with your own (maybe after completing the Video Quick Start).

# 3) Complete Integration
Do you already have an application that you would like to integrate with Speechly?

1. Sign-up on the [Speechly Dashboard](https://api.speechly.com/dashboard).
2. As a simple example, deploy the Home Automation Configuration that you can find on the Dashboard when creating a new application. (Also see the video tutorial above.)
3. Install and take a [Client Library](/client-libraries/usage) of your choice into use. They are available for Web, React, iOS and Android. Use the Application Id that you obtained in step 2. above. There is no need to do anything in particular with the events returned by the API yet. Just log them to a console.
4. Make a test utterance from your own application, and inspect the returned events to get an idea of how the API works.

After you've completed this, the next step is to [design a configuration](/slu-examples/) that is tailored for your application. (The reason to deploy the Home Automation example at first is to give an overview of the end-to-end integration process that you would follow when developing a voice UI with Speechly.)

5. Once you have written a configuration on your own, you should change your application logic so that it reacts to the returned events in an appropriate manner.

# Learn more!

- Take a look at our [Development tool offering](/dev-tools).
- Read about how to [Configure](/slu-examples/) Speechly for the needs of your Application.
- Check out some [Example Configurations](/slu-examples/example-configuration/).
- Explore the [Documentation](/).
- Browse our [public GitHub repositories](https://github.com/speechly/).
