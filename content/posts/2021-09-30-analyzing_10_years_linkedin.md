---
title: Analyzing 10 years of Linkedin job offers
created_at: 2021-09-30 13:54:30 -0300
kind: article
published: false
---
<%= render('/post_hero.*', src: '/blog/assets/images/2021/linkedin-wordcloud.png', alt: "Bar chart showing distribution of jobs I applied to per country. US ranks first with over 10 applications.", caption: "") %>


I've noticed a spike in Linkedin activity from recruiters since the covid-19 pandemic started. But is my perception supported by data though? Let's find out.

<!-- more -->

First I exported all conversations, invites and contacts from Linkedin:

<%= render('/image.*', src: '/blog/assets/images/2021/linkedin-export.png', alt: "", caption: "") %>

Next I ran this script to parse that data into useful information:

Here's some of the insights from 8 years of Linkedin usage.

## Recruiter contacts per month

Most messages I receive are from recruiters, but not all: I get a few scattered personal messaging from old acquaintances, some professional but not interview-related conversations, etc.

One way to try to guess the amount of job offers is looking at the content of messages. If a message contains "Ruby", probably it came from a recruiter advertising a Ruby-related job offer. So I built a list of terms that are related to job searches:

```
job offer opportunity ruby developer engineer talent salary relocation position role recruiter talent looking interested oportunidade trabalho vaga software experience tech rails interesse interested company email work senior contato vagas remote working stack backend technical developers skill skills
```

The aforementioned script goes through every message and counts how many match at least one of those terms. Here's the chart of offers per month:

<%= render('/image.*', src: '/blog/assets/images/2021/linkedin-offers-month.png', alt: "", caption: "") %>

## Most common terms

These are the most frequently mentioned terms in my conversations:

<%= render('/image.*', src: '/blog/assets/images/2021/linkedin-wordcloud.png', alt: "", caption: "") %>
