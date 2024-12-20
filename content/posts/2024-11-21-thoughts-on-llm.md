---
title: Thoughts on LLMs in software engineering
created_at: 2024-11-21 00:00:00 -0800
kind: article
published: true
tags:
  - ai
  - career
---

The "catastrophe scenario" of AI in the software engineering job market has gained quite a lot of popularity, with people pointing out that current models already "do a better job" (what does that even mean?) than many professional programmers. I'm not sure I completely buy into this.

<!-- more -->

Personally, I've found that the most useful use of LLMs during software development is to speed up tasks that I _already know_ how to do, such as "write a spec suite with these scenarios". The results are usually reasonably good, and with some careful nudging into the right direction, I usually get things done much faster than I would have otherwise. This is fundamentally different from having a chatbot fully _replace_ me as a programmer.

I began by saying I don't buy into the fear hype, but things get complicated when you look at the big picture. The way I described using LLMs is similar or analogous as to the way an engineering manager might assign feature work to developers, or a lead programmer working along a junior programmer: I have these tasks in mind, I have a clear idea of how to get them done, and I offload to it to this thing that will hopefully spit out more or less what I was expecting. And in that similarity lays the potential issue - given enough people in the industry are using it in this same way, the necessity of more junior developers might diminish.

Another way of looking at this is through productivity. I'm probably not producing better code, but I am definitively producing code much faster than before. Let's assume this is an industry-wide trend. Other programmers are similarly experiencing increases in productivity. So, all other things equal, the industry suddenly has a considerable surplus of productivity. Where is it going? Its still too early to investigate - ChatGPT 3 came out in 2020, and only in the last couple of years have the models become very good at code. But [end of year](https://www.levels.fyi/assets/pdfs/2023Report.pdf) salary reports show no meaningful changes in software engineer salaries in the last couple of years. There are two other outlets for productivity: increasing profits and decreasing headcounts. We've seen plenty of both recently.

Also, if we zoom out a little and look at the overall economic productivity in the last decades:
<%= render('/image.*', src: '/blog/assets/images/2024/productivity.png', alt: "Productivity vs wage growth chart in the US. Both lines decouple in the 70s, with productivity growing but wage stagnating.") %>

There's absolutely no reason to believe that trend will change. If anything, dumping more productivity into the economy will just supercharge the wage-productivity decoupling even further.

While I'm not personally frightened about being replaced by an LLM - at least not in the murky, barely-visible future - I do have some concerns about the wider industry, specifically for people joining the workforce right now.
