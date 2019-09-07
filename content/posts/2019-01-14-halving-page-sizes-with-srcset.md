---
author: lbrito1
comments: true
created_at: 2018-09-03
kind: article
title: "Halving page sizes with srcset"
excerpt: "There are many different devices accessing the internet, and they all have different screens. By using srcset to optimize the images served by our webapp, we reduced page sizes by up to 50%."
categories:
- Engineering
- Code
tags:
- Web development
---

[Web bloat](https://www.webbloatscore.com/) is [discussed](http://idlewords.com/talks/website_obesity.htm) a lot nowadays. Web pages with fairly straightforward content — such as a Google search results page — are substantially bigger today than they were a few decades ago, even though the content itself hasn't changed that much. We, web developers, are at least partly to blame: laziness or just [bad programming](http://www.haneycodes.net/npm-left-pad-have-we-forgotten-how-to-program/) are definitively part of the problem (of course, laziness might stem from a tight or impossible deadline, and bad code might come from inexperienced programmers — no judgment going on here).

<!-- more -->

But here at Guava we believe that software should not be unnecessarily bloated, even though it could be slightly easier to develop and ship. We believe in delivering high quality production code, and a part of that is not taking the easy way out in detriment of page size.

We frequently have to start working on long-running software that has more than a few coding shortcuts that were probably necessary at the time to ship something quickly to production, but are now aching for optimization. Sometimes the improvements are too time-consuming to be worth our trouble, but sometimes they are an extremely easy win.

Such is the case of separating image assets by pixel density (DPI). As the name implies, DPI (dots per inch) is the amount of dots (or pixels, in our case) that fit in a square inch of screen real estate. The exact definition varies according to context, so for the sake of readability we'll say that low DPI means the average desktop or laptop screen and budget smartphones, while high DPI means the average smartphone, tablet or higher-resolution computer screens (e.g. Retina displays and 4k monitors).

Nowadays, smartphone customers are important to most online retail businesses, which means that we should serve high DPI images _when necessary_. The "when necessary" part is important because the easy way out is to _always_ serve high DPI assets, even though the client device might not need them. The problem with this is that high DPI images are roughly 4 times as big as their low DPI counterparts, so low DPI devices would be getting unnecessarily big images for nothing at all — web bloat!

Serving different assets according to the client's DPI was not a trivial task a few years ago, which means that the web is probably filled with pages that still serve high DPI assets by default to all client browsers. But now that HTML5 is widely adopted we can make good use of [srcset](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img) to do just that. To each their own: `srcset` takes a list of different images and serves the most appropriate one to each client. In image-heavy sites such as retail stores this is an excellent tool to optimize average page size and save a good deal of bandwidth — which means saving money. Smaller images also take less time to load, so customers will also see product images faster than before.

This very simple change allowed us to decrease page sizes in one of our projects over 50% in some of its most-accessed endpoints, and an overall average 25% page size reduction for low DPI customers. Considering that some of the pages were 4 or 5MB big, halving those sizes was a great improvement to our customers — even more so considering that some of them might access our site on low-quality mobile networks, which can be excruciatingly slow sometimes. Considering the proportion of low DPI customers we have on an average day, this improvement saved our client some 7.5% of bandwidth.

Now that we've got some hindsight, it seems glaringly obvious that we should have been using this feature all along. But more often than not, extremely simple optimizations such as the one we described are overlooked by less experienced teams or worse — deemed "not important" by management because customers nowadays supposedly can spare a few megabytes per page (that may be so, but they don't want to!).

We think that bloated web pages hurt everyone involved: web developers, customers and businesses. We strive to achieve what we think is good quality web code: that which delivers optimized, slim web pages to all clients.

By [Leonardo Brito](https://medium.com/@lbrito) on [January 14, 2019](https://medium.com/p/f82a1c5deb26).

[Canonical link](https://medium.com/@lbrito/halving-page-sizes-with-srcset-f82a1c5deb26)

Exported from [Medium](https://medium.com) on May 1, 2019.
