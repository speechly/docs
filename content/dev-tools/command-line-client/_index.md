---
title: Speechly Command Line Tool
description: The Speechly Command Line Tool provides additional configuration options and allows you to efficiently integrate Speechly to your development workflow.
weight: 5
category: "User guide"
menu:
  sidebar:
    title: "Command Line Tool"
    weight: 8
    parent: "Development tools"
---

# What is the Command Line Tool and what does it do?

The Command Line Tool (CLI) is a simple program that works in a Unix shell or Windows Terminal. It allows you to create, maintain and deploy Speechly applications on the command line. It provides the same functionalities as the Dashboard, as well as the following additional benefits:

1. The CLI gives you access to some advanced configuration options (most notably [Imports and Lookups](/slu-examples/imports-and-lookups/)) that are not available on the Dashboard.
2. Using the CLI allows you to use standard tools to maintain Speechly configurations as part of your other development workflow.

# Installation

The tool is open-source and can be found at our [Github repository](https://github.com/speechly/cli). For easy installation, we also provide binary releases for macOS, Linux and Windows. Once installed, the tool is invoked by typing `speechly`.

Select your OS for quick installation instructions.
<div class="tab">
  <button class="tablinks macos active" onclick="openTab(event, 'macos')">MacOS</button>
  <button class="tablinks windows" onclick="openTab(event, 'windows')">Windows</button>
  <button class="tablinks linux" onclick="openTab(event, 'linux')">Linux</button>
</div>

<div class="macos tabcontent code" style="display: block;">
If you are using MacOS, the easiest way to install is by using <a href="https://brew.sh">Homebrew</a>. 

```bash
$ brew tap speechly/tap
$ brew install speechly
```
After tapping, brew updates will include the new versions of `speechly`.
</div>

<div class="windows tabcontent code">
If you are using Windows, the easiest way to install is by using <a href="https://github.com/lukesampson/scoop">Scoop</a>.

```posh
C:\> scoop bucket add speechly https://github.com/speechly/scoop-bucket
C:\> scoop install speechly
```
You can update the tool by using `scoop update`.
</div>

<div class="linux tabcontent code">
For Linux, we provide a pre-compiled x86_64 binary at
<a href="https://github.com/speechly/cli/releases/latest">https://github.com/speechly/cli/releases/latest</a>.
The release package contains a README as well as the binary. Just put it anywhere on your PATH and you are good to go.
<br><br>
Of course you can also build the client from source if you need to run this on an exotic architecture.
</div>

# Adding an API token
After installing the CLI, you must obtain an API token from the [Dashboard](https://api.speechly.com/dashboard). Please follow these steps to create an API token:

1. Log on to the [Dashboard](https://api.speechly.com/dashboard).
2. Click on the project menu in the top right corner (to the left of your user name), and select "Project settings".
3. On the page that opens, click on "Create API Token" and give the token a name (this can be whatever).
4. Click "Show" to see the API Token (It is a long, random string.), and click "Copy" to copy the token to the clipboard.

You have now created an API token for the project that is active on the Dashboard. It provides access to all app_ids within the active project.

Once you have copied the API token to the clipboard, run the command below where `<API_Token>` has been replaced with your API token. (Simply paste it in your terminal.) You should also specify a name for the project by replacing `project_name` with something descriptive.
```bash
speechly config add --name project_name --apikey <API_Token> --host api.speechly.com
```
Now you are ready to start using the CLI!


# Managing multiple projects

If you have split your applications to multiple projects, you must configure the CLI for each of the projects by following the steps in [Adding an API token](#adding-an-api-token) separately for each project. NOTE: Before selecting "Project settings", please ensure that you have the correct project currently selected in the Dashboard!

You can see a list of all projects (called "Contexts" in the CLI) that have an API token, as well as the one that is currently active, by invoking
```bash
speechly config
```
The project that is currently active is indicated by "Current config" in the listing.

Switching between projects is done by invoking
```bash
speechly config use --name name_of_my_other_project
```


# Basic usage and getting help

This is a brief overview of how the CLI works in general. A [reference](#cli-reference) of the most important commands is at the end of this document.

The CLI follows an approach similar to e.g. `git` or `docker` where different functionalities of the tool are accessed by specifying a command followed by arguments to this command. The tool provides usage instructions when invoked without sufficient parameters.

For example, invoking
```bash
speechly
```
without other arguments, will print a list of all commands supported by the CLI. Running `speechly command` will print a brief usage guide for the given `command`, e.g. typing
```bash
speechly create
```
gives instructions on how to create a new application.


# Deploying with the CLI

When deploying a Speechly application with the CLI, the application configuration (SAL templates, Entity Data Types, etc) are defined in a YAML formatted file. This *Configuration YAML*, together with other configuration files if needed, should all be put in the same directory. The contents of this directory are deployed by invoking
```bash
speechly deploy name_of_directory -a deployment_app_id -w
```
where `deployment_app_id` should be replaced with the app_id you want to deploy the application to. The `-w` flag means the Command Line Tool will wait until model training is complete.

Note that the CLI builds and uploads a deployment package that contains *all files* in the specified directory! It is thus highly recommended to store there only files that are relevant to the configuration. In the simplest case this is only the Configuration YAML.


# Configuration YAML
The configuration YAML defines a dictionary of `(key, value)` pairs that contain definitions both for SAL templates and Entity Data Types as described below. Also, [Imports and Lookups](/slu-examples/imports-and-lookups/) are configured within the same Configuration YAML.

## Defining SAL templates
Templates are defined with key `templates` within a "Literal Block Scalar":
```yaml
templates: |
  SAL line 1
  SAL line 2
  ...
```

## Defining Entity Data Types
Entity Data Types are defined with key `entities` that has a list of `(name, type)` pairs as its value:
```yaml
entities:
 - name: entity1_name
   type: entity1_type
 - name: entity2_name
   type: entity2_type
   ...
```

## Example configuration YAML
This is a simple example that shows what a complete configuration YAML with entity types and templates looks like:
```yaml
entities:
 - name: product_name
   type: string
 - name: product_amount
   type: number
 - name: delivery_date
   type: date
templates: |
  product = [apples | oranges | bananas | grapefruits | mangoes | apricots | peaches]
  amount = [1..99]
  *add_to_cart {add} $amount(product_amount) $product(product_name)
  *set_delivery_date [{schedule} delivery for | delivery on] $SPEECHLY.DATE(delivery_date)
```

## Suggested workflow

1. Create a directory for your application's configuration.
2. Save files in git or other version control system.
3. Use `speechly deploy` in your CI pipeline for deploying the configuration.


# Updating the API token

Updating the API token of a project in the command line tool is done by modifying the CLI config file. You can see where the config file is located by invoking
```
speechly config
```
The first output line should indicate the "Config file used". The name of the config file should be `.speechly.yaml` and it should be located in your home directory. Open this file in a text editor. You should see something like
```yaml
contexts:
- apikey: A_REALLY_LONG_SEEMINGLY_RANDOM_STRING
  host: api.speechly.com
  name: my_project
current-context: my_project
```
where `A_REALLY_LONG_SEEMINGLY_RANDOM_STRING` is the current API token of project `my_project`. If you have several projects, they are all shown separately, each with their own API token.

You can generate a new API token by following steps 1-4 in [Adding an API token](#adding-an-api-token). (Ensure that you are viewing the appropriate project in the Dashboard before generating the token!) When you have copied the new token, replace `A_REALLY_LONG_SEEMINGLY_RANDOM_STRING` with the new token, which is just another really long seemingly random string. Save the config file, and the new API token for project `my_project` is immediately in use.

If you have several projects, you must separately replace the API token for each of these by creating a new token for every project in the Dashboard, and pasting it in the config file.


# CLI Reference
The Command Line Tool has a built-in help functionality. This is a brief reference of the most important commands.

## List applications
You can print all applications in the currently active project by invoking:
```bash
speechly list
```

## Create a new application
A new Speechly app_id is created by invoking
```bash
speechly create -l en-US -n name-of-my-app
```
where you should replace `name-of-my-app` with a descriptive name of the application. The command will print the newly created app_id.

## Deploy a configuration
The simplest way is to enter the directory that contains your configuration files, and run
```bash
speechly deploy . -a app-id
```
where `app-id` is replaced with the app_id to which you want to deploy the configuration. (Note that `app_id` must belong to the project that is currently active in the Command Line Tool. See also `speechly config`.)

## Print random Example utterances
When working on a configuration, it can be very useful to inspect the Example utterances that the templates are expanded to. This way you can spot mistakes and other problems with your configuration.

Enter the directory that contains your configuration files, and run
```bash
speechly sample . -a app-id
```
and again replace `app-id` with a valid app-id from your current project.

By default the above command returns 100 randomly generated Example utterances from the configuration. If you want to see a larger sample, you can specify the number of Example utterances to generate with the `--batch-size` (or `-s` for short) flag:
```bash
speechly sample . -a app-id --batch-size 1000
```
samples 1000 Example utterances.
