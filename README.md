# Speechly Documentation

This repository serves the documentation website for the Speechly Spoken Language Understanding tools. You can find the website at [https://www.speechly.com/docs](https://www.speechly.com/docs). 

## How to contribute

We are very happy to receive any contributions to our documentation. You can either send pull requests or create [issues](/issues/new). If you have no idea on how GitHub works, you can also [send us an email](mailto:hello@speechly.com) and we'll take it from there. 

## License

All content is licensed under Creative Commons [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license. If you make any contributions to this repository, your content will be licensed under the same license. 

## Building the website

This website is built with [Hugo](https://gohugo.io). Install a fresh version of Hugo, clone this repository and run `hugo server` and you should have the development environment ready with auto reload.

## Making changes

All content is under `/content/` in Markdown. To create a new page, create a new directory under `/content/` and create a new file `_index.md`. Next step is to add the Front matter using following structure.

```
---
title: NLU Basics
description: NLU or natural language understanding is a process of teaching computers to comperehend and understand human languages. It extracts meaning out of written texts and transforms it into structured form. 
weight: 3 
---
```

Weight defines the order of the page in the side bar navigation. Description is used in meta description and as the first paragraph. Use shortish descriptions. Title should be self-explanatory.

### Adding images

Images are added to the same directory as the `_index.md` file. You can reference the image using the following shortcode

```
{{< figure src="slu.png" title="Editing NLU model in the Speechly Dashboard" alt="Screenshot from the Speechly Dashboard SLU examples screen" >}}
```

NOTE: All images must have an alt tag.

### Adding warnings/notes

You can add warning/note boxes by using the following shortcode.

```
{{< warning title="Requires a Speechly API key" >}} Content of the warning (optional) {{</ warning >}}
```

### Adding subpages

If you want to add a subpage, create a new directory under the page directory under `/content/` and create a new `_index.md` file. 


## Commiting changes

You can verify everything is working (alt tags correctly placed, no incorrect urls etc) by using (`htmlproofer`)[https://github.com/gjtorikian/html-proofer/blob/master/bin/htmlproofer] Once you are happy with the changes in your local environment, do `git add . && git commit -m 'commit message'` followed by `git push`. 

## Automatic page generation with `./build-docs.sh`

Fetches docs content from other sources (e.g. GitHub repositories) and transforms it to Speechly Docs pages. The page files are modified "in place", so you can check the diffs with `git status` and `git diff` before committing and pushing.

### Generated pages

- `content/client-libraries/react/ui-components`

Requires a Unix-like environment with `bash`, `curl` and `cat` commands.
