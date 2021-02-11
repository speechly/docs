---
title: Command Line Configuration Tool
description: Use the Speechly Command Line tool to integrate Speechly to your development workflow for easier and more productive collaboration. 
weight: 5
category: "User guide"
menu:
  sidebar:
    title: "Configuration Tool"
    weight: 8
    parent: "Configuring Your Application"
---

Once you've created your first application on the [Speechly Dashboard](https://www.speechly.com/dashboard/) and start inviting more developers to collaborate with your configuration, you might find yourself missing `Git` and other familiar collaboration tools. 

The solution is to start using our [command line configuration tool](https://github.com/speechly/cli) that enables developers to integrate Speechly to their current workflow.

## Installing the tool

There are binary releases for macOS, Linux and Windows, see [releases](https://github.com/speechly/cli/releases).

#### Homebrew (for macOS)

If you are using macOS, the easiest way to install is by using [Homebrew](https://brew.sh). 

- `brew tap speechly/tap`
- `brew install speechly` to get the latest release

After tapping, brew updates will include the new versions of `speechly`.

### Scoop (for Windows)

`speechly` can be installed for Windows with [Scoop](https://github.com/lukesampson/scoop) by using:

- `scoop bucket add speechly https://github.com/speechly/scoop-bucket`
- `scoop install speechly` to install the latest release

You can update the tool by using `scoop update`.

## Configuration

{{< info title="You need an API token to access the API" >}} You can find instructions for getting the token [here](/faq/#how-can-i-find-my-speechly-api-token-for-command-line-tool) {{</info>}}

`speechly config add --name default --apikey <API Token> [--host api.speechly.com]`

The latest context added will be used as the current context. 

## Usage

### Supported commands

- `config` manage the Speechly API access configurations
- `create` create a new application in the current context (project)
- `delete` delete an existing application
- `deploy` deploy to upload a directory containing SAL configuration file(s), train a model out of them and take the model into use.
- `describe` describe apps to get their status
- `list` list apps in project
- `sample` sample a set of examples from the given SAL configuration
- `validate` validate the given SAL configuration for syntax errors

The versioning of the SAL configuration files should be done properly, i.e., keep them in a version control system. Consider the deploy/download functionality to be a tool for the training pipeline instead of collaboration or versioning.

## Suggested workflow

1. Create a directory for your application's configuration
2. Save files in git or other versioning tool
3. Use `speechly deploy` in your CI for deploying the configuration 


### More information

Read our [tutorial](https://www.speechly.com/blog/configure-voice-ui-command-line/) for downloading and using the Command Line Tool



