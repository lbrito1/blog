---
title: Web analytics tool running on a phone
created_at: 2020-06-07 14:45:40 -0300
kind: article
published: false
---


## Motivation

I run my personal site, as well as this blog, on Github Pages. They're static sites - I write something (such as this blog post -- more on that in the [about page](https://lbrito1.github.io/blog/about.html)), run some compilers and the end result is an HTML page that is then served by Github Pages.

There are pros and cons to this approach. A pretty good pro is that that Github Pages is free and very simple to use. I don't have to set up billing details or worry about how to deploy my page. I compile the markdown files, commit and push, and Github takes care of the rest (there's a [deploy script](https://github.com/lbrito1/sane-blog-builder/blob/development/deploy.sh) I wrote to make that a one-step process).

A negative point is that I don't have a lot of control over the server that Github is kindly hosting and serving these pages. I'm curious about who, if anyone at all, is reading my posts and where they're from. Mind you, that's about it -- I could care less about the click heatmap, which div they interact with most or what their "online profile" is. In fact I would argue that most of those details are or lead to a lot of what is wrong with the Internet these days. I just think it is fun to know someone from Nepal or Iceland read my post about [using a phone as a Ruby server](https://lbrito1.github.io/blog/2020/02/repurposing-android.html).

## Requirements

1. Per-page view count
2. Nice to have: per-country user info


postgres, sequel gem

no password


pg_hba.conf
