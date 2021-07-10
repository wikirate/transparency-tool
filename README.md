
# FashionChecker transparency tool

## embedding
Add the following code to your website to embed (adjusting width and height as necessary):
```
<iframe src="https://fashionchecker.org/embed.html" style="width: 100%; height: 600px"></iframe>
```
Note: supported languages can be embedded by adding the language prefix to the source url, eg `https://fashionchecker.org/de/embed.html`.

## developer setup
The site is developed with [Middleman](https://middlemanapp.com). It depends on Ruby and the 
RubyGems package manager. If you don't have that you can follow these [instructions](https://middlemanapp.com/basics/install/). 
 
 
### installation 
```
git clone https://github.com/wikirate/transparency-tool
cd transparency-tool
bundle install
```

### build site
```
bundle exec middleman build
```

### run local server
```
bundle exec middleman server
```  

The command returns a url where you can access the site.
Middleman automatically picks up source changes and refreshes
the site in the browser.

### deploy to wikirate server
``` 
bundle exec cap production deploy
```


