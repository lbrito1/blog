---
title: Did software-related job offers explode during the pandemic?
description: Analyzing my Linkedin data export to see if and by how much the software industry exploded during the pandemic.
created_at: 2021-09-30 13:54:30 -0300
kind: article
published: true
tags:
- career
---
<%= render('/post_hero.*', src: '/blog/assets/images/2021/linkedin-wordcloud.png', alt: "Bar chart showing distribution of jobs I applied to per country. US ranks first with over 10 applications.", caption: "") %>


I've been using Linkedin basically since I started working as an intern back in 2012. My usage is mostly limited to posting my blog posts and looking for jobs when I'm actively searching. The rest of the time, it used to be pretty slow-paced, with maybe half a dozen random recruiters reaching out per year.

However, since the Covid-19 pandemic started, things seem to have gone a little crazy, with a _lot_ more recruiter activity. I was curious to see just how much things had changed, so I looked at Linkedin's data export.

<!-- more -->

First I requested my data from Linkedin:

<%= render('/image.*', src: '/blog/assets/images/2021/linkedin-request.png', alt: "", caption: "") %>

Messages, Connections and Invitations seem like the most promising sources of data:

<div class="highlight"><pre><code class="language-bash">
➜  Basic_LinkedInDataExport_10-01-2021 ls -lahtS
total 1020K
-rw-rw-r-- 1 leo leo 577K out  1 13:06  messages.csv
-rw-rw-r-- 1 leo leo 146K out  1 13:05  Connections.csv
-rw-rw-r-- 1 leo leo 113K out  1 13:05  Contacts.csv
-rw-rw-r-- 1 leo leo  43K out  1 13:05  Learning.csv
-rw-rw-r-- 1 leo leo  23K out  1 13:05  Invitations.csv
</code></pre></div>

The Connections export is somewhat limited for our purposes: I only actively add people on Linkedin during a job search.

Messages are a bit more interesting because a lot of recruiters immediately offer a position in their first contact (sometimes even with a pre-scheduled Google calendar event! I wish things were this straightforward back when I was finishing school).

Invites are also a good source, complimentary to Messages. After accepting or rejecting an invite, the Invitation is deleted, so there's no danger of double counting an interaction that started as Invitation and then evolved to Messaging.

Focusing first on the Messages export, here are some relevant info we might aspire to extract:

* Job offers (as in "I have a job I want you to apply for") per date
* Keywords mentioned in messages ("Ruby", "Rails" etc)

Let's see if we can extract those.

## Job offers per month

Job offers mainly come from messages, and the bulk of my messages come from recruiters. However, I do get a few scattered personal messaging from old acquaintances, some professional but not interview-related conversations, etc.

A simple approach to estimate how many messages are actually from someone promoting a job opening is to look for certain job-related terms: in my case, as a Ruby engineer, if a message contains "Ruby" it is probably from a recruiter advertising a Ruby-related position. This is only an estimate: maybe I chatted about Ruby at some point with an acquaintance, which of course is non-related to our objective here. Those cases are few and far apart compared to the recruiter conversations though.

With that in mind, I built a list of terms that are related to job searches:

<div class="highlight"><pre><code class="language-ruby">
job offer opportunity ruby developer engineer talent salary relocation position role recruiter talent looking interested oportunidade trabalho vaga software experience tech rails interesse interested company email work senior contato vagas remote working stack backend technical developers skill skills
</code></pre></div>

Most of the messaging I get is in English, but I do get a significant amount of contacts in Portuguese as well, so we have terms in both languages.

With that list of terms, we can simply `select` all the relevant ones and group those by month:

<div class="highlight"><pre><code class="language-ruby">
  def job_messages_per_month
    job_related_messages = @input.select { |row| row["CONTENT"] =~ /#{@relevant_words.join("|")}/i }
    metric_per_month(job_related_messages) { |row| Time.parse(row["DATE"]).to_date }
  end
</code></pre></div>

Now, when I'm not actively looking for another job, I tend not do look at Linkedin too much, so the Invitations tend to pile up. As already mentioned, accepted/rejected invites get "deleted" from Linkedin's data export (which doesn't seem like a great practice IMO, as they probably still have that data), so only invites that you haven't acted on either way are available in the CSV export.

Just like with messages, we group the relevant invites ("Inbound", meaning someone is adding you as opposed to "Outbound" where you're adding someone) by date. I didn't bother filtering by terms because nearly everyone that adds me is a recruiter these days:

<div class="highlight"><pre><code class="language-ruby">
  def recruiters_per_month
    received_invites = @input.select { |row| row["Direction"] == "INCOMING" }
    metric_per_month(received_invites) { |row| Time.strptime(row["Sent At"], "%m/%d/%y").to_date }
  end
</code></pre></div>

Here's the result of summing both data, messages and invites:

<%= render('/image.*', src: '/blog/assets/images/2021/linkedin-offers-month.png', alt: "", caption: "") %>

There was a spike in early 2019, when I actively pursued a new job. I also gave a [conference talk](http://www.thedevelopersconference.com.br/tdc/2019/florianopolis/trilha-web-frontend) at that time and added a bunch of people on Linkedin, so the spike makes sense.

After that, activity dropped to back to lower levels (I also ticked "not looking for a job" on Linkedin right after I signed the offer at my new job around April 2019).

Interestingly, since late 2020 invites/job messaging has grown steadily. I'm curious to see if other people also had a similar pattern. Perhaps this is a reflection of an increase of demand in some specific skillset (Ruby) or experience level (X years of experience), but I'm guessing its part of a general upwards trend in the industry since the beginning of the pandemic.

## Most common terms

Another interesting piece of information is the most common words mentioned in the conversations.

We could just count how frequently each word pops up, but irrelevant words like "the", "a" and so on would rank in the top. So first we need to get rid of those words, then look at the linted text. I'm sure there's an API that does just that somewhere out there, but I created my own list of non-relevant words manually and used that instead.

<div class="highlight"><pre><code class="language-ruby">
  def word_frequencies
    full_text = @input.map { |row| row["CONTENT"] }.compact.join(" ")
    normalize_words(full_text.split(/\s+/))
      .map { |w| w.gsub(/[^a-z]+/, "") }
      .reject { |w| w.size < 3 || @nonrelevant_words.include?(w) }
      .group_count.sort_by{ |a| a[1] }.reverse
  end
</code></pre></div>

Using the [MagicCloud](https://github.com/zverok/magic_cloud) gem, here's the plotted results:

<%= render('/image.*', src: '/blog/assets/images/2021/linkedin-wordcloud.png', alt: "", caption: "") %>

No surprises there -- terms like "Ruby" and "Rails" are among the most frequent. Other bland job-related terms compose the bulk of the word cloud.

Here are the actual numbers for these terms:

<%= render('/image.*', src: '/blog/assets/images/2021/linkedin-terms.png', alt: "", caption: "") %>

## What happened/is happening?

Going back to the original question: did software-related job offers explode during the pandemic? My anecdata presented above points to an obvious Yes. Most articles discussing this question are just opinion pieces stating that engineering demand increased because digital services sharply expanded with the lockdowns. I couldn't find any hard data supporting these assumptions.

One of the major impacts of the pandemic, being forced to remote-only did have pretty obvious effects in non-US job markets. Before the pandemic, I suspect that many very competent people were hesitant to leave their jobs for strictly non-remote reasons: nice offices, work colleagues, local benefits like healthcare, maybe even specific labor laws regarding vacation time and so on. Remote jobs based in strong currency countries, especially the US, were already "a thing" long before the pandemic, but with remote work being mandatory rather than an option, local remote vs foreign remote boils down to a huge pay gap in most cases, with US-based software engineering salaries being hard to compete with anywhere else in the world.

I'm very curious to see how this pans out for local software shops. These local companies are really bleeding talent leaving for stronger currencies; if these dynamics go on for too long, I can't see how most of them will last.

## Code

[Here's the repo](https://github.com/lbrito1/linkedin-insights) with all the scripts needed to reproduce these results.
