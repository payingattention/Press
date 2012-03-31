RubyPress
---------

RubyPress will be a fully featured blogging solution that is designed to replace Wordpress and was started as a test
project where I could play with Ruby on Rails and learn it's ropes.  It's blossomed into something more.  My desire to
do this stems from my wanting something that was 100% my very own from the ground up, not because I hate Wordpress or
anything like that.  Wordpress is a great blogging solution, it's just not "mine".

I'm still very much kicking the tires and tweaking things to see what they do and as such this isn't a stable product yet.
But I have high hopes.

Please feel free to download, make comments and push back your results.. For right now, this is about my learning RoR,
TwitterBootstrap, Devise, CanCan, Nokogiri..etc..



Intended Features
-----------------

It only takes a few minutes of playing with Wordpress to realize that it is extremely feature packed..  As such replicating
all of it's features is a very tall order.. But that's the intent.

I'm going to start by getting core functionality in place and actually making a usable product.. this means a lot of the
nicer features likely wont be in place yet..  But that doesn't mean they wont be there eventually.. Baby steps.. It took
Wordpress a long time to get where it is today..

There are some things that I don't think wordpress did correctly, or at the very least I disagree with the direction that
was taken and would like to do things differently..  Those will be listed below.


  * Allow a post or page #show to define it's own layout / theme.  I think WP can do some of this

  * There is no good reason a single taxonomy entry can't be multiple classifications with the same slug.. Fix this.  WP did this wrong.

  * If someone sets a post password, it should be a real honest secure password system.. not clear text in the db.. WP did this wrong.


Key Differences
---------------

As I go through and implement my blogging software I'm going to try to duplicate a lot of the good stuff of Wordpress but
there are going to be differences; Some unintentional, some intentional.  I'll try to detail those here as I come across them.

  * If you sort by a category, I intentionally only show results from that category, rather than the results from the entire parent
  child structure. I really think that the way WP did this was incorrect.  If you have categories with a relationship of A/B/C/D and
  you click on category C in order to see its contents, in Wordpress it shows all the contents of A, B and C.. I disagree with this and
  only show the contents of C as I feel one would expect.