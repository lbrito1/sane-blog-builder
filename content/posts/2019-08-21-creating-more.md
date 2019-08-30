---
title: "My attempt at creating more"
created_at: 2019-08-29 21:00:00 -0300
kind: article
tags: ['hello world']
---

I began blogging in the now prehistoric late 2000s.

I've done a few blogs about different subjects (computer science, algorithms, web development, short stories and political ramblings). I've had blogs on Blogspot, Wordpress and, more recently, Medium.

Those platforms were (or are, I suppose) an easy way to spew your ideas over the Internet while also being nice and comfy for other people to actually read (this last point is important for the CSS-challenged such as yours truly). In other words, those services Got Shit Done™.

<!-- more -->

Alas, as I opened my eyes to the wonders of web development I started noticing a few things. First, Wordpress is written in PHP, which is gross (just kidding). Second, you don't really control much: you can pick themes or whatever, but you won't have the full control you'd have by creating a website from scratch or nearly scratch. Third, and maybe a corollary to the previous point, that stuff is *bloated*. There's approximately 3 terabytes of mostly useless JavaScript, ads and all kind of crap I don't care about.

But most importantly, I understood the hidden costs of most "free" web services. You don't really own anything. You provide content, and Wordpress or Google or whoever package that content into a neat bundle and servce it to your audience together with whatever else (*cough, trackers*) they see fit.

That's one of the reasons that pushed me towards a less-walled-garden approach towards blogging. But there's a nother reason as well.

As [many others](https://code.divshot.com/geo-bootstrap/), I have fond memories of the late-90s/early-2000s Web 1.0 Internet. There is something warm and fuzzy about those beautifully terrible Geocities pages. They pierced the eyes of the viewer but were wondrous in a way. As I said, I'm not alone: Web 1.0 nostalgia is definitively [on the rise](https://gizmodo.com/the-great-web-1-0-revival-1651487835).

But why? What is not to like in our world of beautiful walled gardens? Surely it is better than those gross-looking Web 1.0 fan sites about some crappy GameBoy game, right? ...Right?


<%= render('/image.*', src: '/assets/images/fan_page_screenshot.png', alt: 'View of an old website about Pokemon', caption: 'We\'re soooo cooler than this in 2019.') %>

*Wrong.*

Well, in many ways the Internet has of course improved over time. It has useful things like search engines and Wikipedia, and convenient subscription-based entertainment like Netflix. It has a whole bunch of nice stuff I could spend hours blabbering about.

But it also has a lot of problems. At this point there are surely many PhD theses about most of them, so I won't bother. I'm just going to recommend one [New York Times article](https://www.nytimes.com/2019/08/11/world/americas/youtube-brazil.html) that explains how YouTube indirectly helped elect a buffoon that [makes high school-tier penis jokes](https://extra.globo.com/noticias/brasil/bolsonaro-faz-piada-com-oriental-tudo-pequenininho-ai-veja-video-rv1-1-23668287.html) as president of Brazil.

Now, the specific problem with today's Internet that I feel is most relevant regarding blogging is how we're gravitating towards all these "free" services all the time. Medium, for instance, is so *nice looking* that one doesn't even think of perhaps using something else. But what happens when *everyone* uses Medium? First: all the blogs look exactly the same, which is lame. Second, Medium gets all that content and traffic for itself, for free.

Of course, not everyone is skilled enough to build a personal blog from scratch. I am just barely able, as you can see from my lackluster front-end skills (I promise you I'm good on back-end things). So I'm definitively not dismissing the inclusiveness that services like Medium offer.

But as I searched for a way out of the walled gardens and fiddled with [Jekyll](https://jekyllrb.com/) for a while, I figured I might as well just [build something to call my own](https://tjcx.me/posts/consumption-distraction/).

## So I built this.

The goals were to create the simplest possible blogging system with as little fluff as possible. It should meet what I defined as basic blogging needs: list posts, show post, use tags, use images etc. And also not have 3 terabytes of JavaScript split in 90 requests just to show a fancy menu button.

So I started messing with Nanoc, an excellent Ruby library for static page generation, and came up with [this bad boy](https://github.com/lbrito1/sane-blog-builder).

I won't pretend these ideas are new. They aren't! I feel there's been an increasing amount of [Web 1.0 nostalgia](https://code.divshot.com/geo-bootstrap/) going on, and a big part of that is probably fueled by [similar sentiments](https://tjcx.me/posts/consumption-distraction/) as those I described. The [longing for simplicity](https://thebestmotherfucking.website/) in a world of trillions of new JS frameworks is also quite widespread these days.

This small project is nothing special. There are [much better projects](https://github.com/remko/blog-skeleton) [available for free](https://clarkdave.net/2012/02/building-a-static-blog-with-nanoc/) on the Internet done by people that actually know what they're doing with a CSS file. This here is just a tiny vase with some ugly flowers -- it would be ridiculous to compare it to the beautiful walled gardens of Medium or Wordpress. But, ugly as they are, they're **mine**!
