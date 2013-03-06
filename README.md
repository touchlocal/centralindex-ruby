# centralindex-ruby

## Introduction

The centralindex Ruby module allows developers to start using the [Central Index](http://centralindex.com/) API with minimal code. The Central Index is a global data exchange, with a simple REST/JSON api. 

## What do I need before I start?

* Read up on what Central Index is here [http://centralindex.com/](http://centralindex.com/)
* Read up on the developer API here [http://developer.centralindex.com/](http://developer.centralindex.com/)
* Sign up for a Mashery account, if you don't have one already [http://developer.centralindex.com/member/register](http://developer.centralindex.com/member/register)
* Sign up for an API key here [http://developer.centralindex.com/apps/register](http://developer.centralindex.com/apps/register)

## Hello World

You'll need to put the CentralIndex.rb file alongside your code.

Then your first script could look something like:  

```
ci = CentralIndex.new('<api key goes here>', false)
puts ci.getEntity('379236608286720')
```

## Function reference

See the [API Docs](http://developer.centralindex.com/docs/read/API_Reference) for more information.

