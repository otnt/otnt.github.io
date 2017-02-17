---
layout: post
title: Blog with Jekyll for beginners
post-date: 2017-02-10
update-date: 2017-02-10
---

This article

- shows how to build a simple blog website with Jekyll from scratch (you could also build your blog on top of others once you learnt the essential skills)
- use [Liquid](https://github.com/Shopify/liquid) and [Jekyll plugin](https://jekyllrb.com/docs/plugins/) to customize article previews front matter
- example blog

![example-blog](d)

Pre-requists

- Basic understanding of HTML, CSS, JS and their relations
- Ruby experience or other programming experience to pick up Ruby quickly (< 3 mins)
- Mac (if you're using aother platform, please change the commands accordingly)

<!-- excerpt -->

# Build your blog with Jekyll

## Install Jekyll

Remember all the commands are only tested on Mac OS.

```
gem install jekyll
```

## Set up environment

Navigate to the directory you want your blog be put to. In my case, I will choose ```/tmp``` so that it won't miss up my whole system.

```
> cd /tmp
> jekyll new my-blog
New jekyll site installed in /private/tmp/my-blog.
```

By running the last command, you have created a directory organized in a way that Jekyll could create static website from.

## Create a post

Before all, let's remove default files Jekyll created for us. In this article, we will use much simpler layouts, but the idea is the same.

```
> mkdir /tmp/blog-backup
> mv _includes/* _layouts/* _posts/* css/* _sass/* index.html about.md /tmp/backup/
```

### Layout

#### Post layout

Now let's create a **layout** for your blog posts. A layout is same as a template. You could think about it like creating a Pointer Point / Keynote. For each slide, it has a structure, e.g. a title and a body text, and what you need to do is only fill in the content.

**Jekyll is great to separate layout/template from contents.**

We create layout using HTML, CSS, JS and Liquid. In the layout, we put some special marks as placeholders, so that the content could be inserted by Jekyll and Liquid.

Once you have created the layout, you could focus on contents and Jekyll will put them together and render the website.

This may sound abstract, let's have a dry run!

```
> cd my-blog
> vim _layout/post.html # Or use your favorite text editor to create _layout/post.html
```

This is the simple post HTML.

```html
---
layout: default
---
<div>
	<header>
		<h1>{{ page.title }}</h1>
		<p>{{ page.date | date: "%b %-d, %Y" }}</p>
	</header>

	<article>
		{{ content }}
	</article>
</div>
```

**Now, stop reading and check out [Liquid for designers](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers) to get a basic understanding of these curly brackets.**

If you did read the article, you should understand

- ```{{ foo }}``` is nothing but a placeholder, Liquid will later replace variable ```foo ``` with its actual value. For example, ```{{ content }}``` is a variable created by Jekyll, whose value is the actual blog content you composed.
- In```{{ foo | bar }}```, the ```|``` is just like Unix [pipe](https://en.wikipedia.org/wiki/Pipeline_(Unix)) supporting casacading operations.
- In ```{{ foo | bar: v1, v2 }}```, the ```: v1, v2``` is the input arguments for filter ```bar```.

Now you may have two questions:

- The HTML file is incomplete, for example ```<!DOCTYPE html>``` etc. are missing,
- The first three lines of ```post.html``` is mistery,

so let's move on.

#### The complete layout

At this point, you may be wondering what the heck is that on top of the file:

```
---
layout: default
---
```

Jekyll use [YAML](https://en.wikipedia.org/wiki/YAML) to manage meta data of your web pages. This ```layout: default``` tells Jekyll to search for ```default.html``` in directory ```_layout```, and then **replace the placeholder ```{{ content }}``` in ```default.html``` with the whole content of this file(```post.html```)**. By doing this, Jekyll enable us to define layout in a hierarchical way.

Now let's create file ```_layout/default.html``` with following content:

```html
<!DOCTYPE html>
<html>
	{% include head.html %}
	<body>
		{{ content }}
  	</body>
</html>
```

notice this is a complete HTML file and the ```{{ content }}``` placeholder is where the content of ```post.html``` should fit into.

The {% raw %}```{% include foo.ext %}```{% endraw %}s are straightforward, they will be replaced by contents of ```_include/foo.ext```.

Let's create file ```_include/head.html``` with following content:

```html
<head>
	<meta charset="utf-8">	
</head>
```

This header has many things missing, but it works for our most simple blog.

Therefore, after replacing everything, the actual HTML file for posts will be

```html
<!DOCTYPE html>
<html>
	<!-- Replace {% include head.html %} start -->
	<head>
		<meta charset="utf-8">	
	</head>
	<!-- Replace {% include head.html %} end -->
	
	<body>
	
		<!-- Replace {{ content }} start -->
		<div>
			<header>
				<h1>{{ page.title }}</h1>
				<p>{{ page.date | date: "%b %-d, %Y" }}</p>
			</header>
		
			<article>
				{{ content }}
			</article>
		</div>
		<!-- Replace {{ content }} end -->
		
  	</body>
</html>
```

### Edit home page

We will create an extremely simple home page first, which contains a list of your blog posts.

```
vim index.html
```

Put the following content in your home page.

```html
---
layout: default
---

<h1>Home page</h1>
<ul class="post-list">
{% for post in site.posts %}
  <li>
    <h2>
      <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
    </h2>
  </li>
{% endfor %}
</ul>
```

It's okay if you don't understand ```prepend: site.baseurl```. The most important thing is Jekyll will search for all files under directory ```_post``` and insert their URLs in hyper links.

### Edit blog content

Finally, we could create our blog post.

You could change the name of the blog, but the name must

- have a format ```YYYY-mm-dd-blog-name.ext```
- the ```ext``` has to be one of ```.md```, ```.markdown``` etc.

Here is an example:

```
vim _post/2017-02-10-first-blog.md
```

Now put the content in your blog post

```
---
layout: post
title: first blog
date: 2017-01-20
---

# Title

## Second-level title

some content
```

This tells Jekyll use ```post.html``` as the layout, which recursively use ```default.html```.

Remember the ```{{ page.title }}``` and ```{{ page.date }}``` in ```post.html```? Here is where we define the value of these variables.

## Time for a demo

Now let's run a local server to see how our first blog looks like.

```
jekyll server
```

In your browser, use address ```localhost:4000``` to see your blog site.

#### Moving on

Believe me, you have mastered essential skills for creating a great website with Jekyll.

The best way to step forward is downloading some nice Jekyll template and figure out how it is composed.

Here is the [source code]() of my Jekyll website. However, in order to fully understand these code, you have to learn creating Jekyll plugin, which is super easy.


# Customize article preview front matter with Jekyll plugin

## Default article preview front matter

Jekyll comes with default article preview tag -- ```post.excerpt```.

Modify our ```index.html``` page:

```html
---
layout: default
---

<h1>Home page</h1>
<ul class="post-list">
{% for post in site.posts %}
  <li>
    <h2>
      <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
      
      <!-- insert this line -->
      <p>{{ post.excerpt }}</p>
      
    </h2>
  </li>
{% endfor %}
</ul>
```

We added a paragraph section to home page, which is a preview created by Jekyll ```post.excerpt``` tag. What it does is cut the first paragraph of the post.

## Customize article preview behavior

To have a fully customized preview tool, we have to create a Jekyll plugin.

There are multiple ways to create and use such plugins [(more details)](http://jekyllrb.com/docs/plugins/#installing-a-plugin). I personally perfer put to create Ruby files (equivelent to Jekyll plugins) under ```_plugins``` directory.

Let's see the example first. Suppose we want to use the first 10 characters as article preview. One way is to use Liquid filter ```truncate```. But for the purpose of this article, we'll instead create our dumb little Jekyll plugin.

Create a Ruby file under ```_plugin``` directory.

```
mkdir _plugins
vim _plugins/example.rb
```

Put in following contents:

```ruby
module Jekyll
  module PreviewFilter
    def build_preview(content)
      return content[0, 10]
    end
  end
end

Liquid::Template.register_filter(Jekyll::PreviewFilter)
```

The ```build_preview``` function is straightforward. The other code is just tell Jekyll to register this filter in global scope.

Just as a supplementary, I suggest reading [this paragraph]([Jekyll plugin#liquid filters](http://jekyllrb.com/docs/plugins/#liquid-filters)).

## Time for a demo

Now let's change our ```index.html```

```html
---
layout: default
---

<h1>Home page</h1>
<ul class="post-list">
{% for post in site.posts %}
  <li>
    <h2>
      <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
      
      <!-- insert this line -->
      <p>{{ post.content | strip_html | build_preview }}</p>
      
    </h2>
  </li>
{% endfor %}
</ul>
```

We see that instead of using Jekyll's built-in ```post.excerpt``` tag, we use customized filter ```build_preview``` with content of post as input, to create the post preview on home page. The filter ```strip_html``` is used to remove html tags so that the preview could be rendered correctly.

Run Jekyll local server

```
jekyll server
```

And you should see the change.