---
title: About
---

# About

This is a static blog generator.

There are approximately 1 trillion similar projects spread over an [unfathomable amount of different libraries](https://www.staticgen.com/).

This uses Ruby (more specifically, the excellent [Nanoc](https://nanoc.ws) lib) to generate static HTML pages from Markdown or other HTML files.

[Pure CSS](https://purecss.io/) is sparingly used to help with layouts and such. I recommend that you don't look at the CSS, just trust that it works most times.

<%= render('/image.*', src: '/assets/images/monkey.gif', alt: 'View of a city skyline', caption: 'Myself trying to write CSS.') %>

## Features
* Zero amount of Javascript;
* Basic blogging functionalities (a page that lists all posts, a page to show the actual post, tagging etc);
* Syntax highlighting;
* A page that shows posts by year;
* A page that shows posts by tag;
* A helper for images;
* A rake task that helps set up a new post;
* Small: the entire output of this skeleton is like 100KB (images excluded);
* Has stupid emojis 🎨 (okay that's just your browser);
* That's about it.

## Why?
Why not?

## Myself

My name is Leo and I'm a software developer. I enjoy Ruby. You can find my Github and Linkedin profiles in the page header.
