# Snake game imeplemented in Ruby (Curses, GTK3, JRuby/Swing)

# How to play the game
* Use arrow keys to move the snake
* Press "r" key to restart the game

## What was implemented
* Library functions that manipulate state and handle ENV variables
* 3 versions of UI: curses, gtk3, jruby/swing
    - `cd curses && bundle install && ruby curses.rb`
    - `cd gtk && bundle install && ruby gtk.rb`
    - `cd jruby && ruby swing.rbb`
* ENV options:
    - SIZE [>1] (defaults to 5) - width and height of game board  (example: `SIZE=2 ruby curses.rb`)
    - TIMER [0|false|off / true|on] (defaults to true) - automatically move snake by timer (example: `TIMER=off ruby curses.rb`)
    - TIMEOUT [>1] (defaults to 500) - time interval for times (used only if TIMER options is true) (example: `TIMER=on TIMEOUT=100 ruby curses.rb`)
    

## Things that were intentially not implemented due to lack of time (but it's not hard to implement them)
* I'm not checking if snake collides with itself
* I'm not checking if snake collides with the border
* I'm not using colors
* There is no UI for game settings
* I'm  not using canvas in GUI versions (I'm drawing game in TextView with pseudographics)

# How to run the game without docker
* Install all required deps: gnupg2, build-essential, default-jdk
* Install RVM: https://rvm.io/ (nowadays I prefer ASDF, but it's hard to install JRuby with it, so I'm using RVM in this project)
* Install rubies: `rvm install 3.2.2 && rvm install jruby-9.4.5.0`
* To run curses version: cd curses && bundle install && ruby curses.rb
* To run gtk version: cd gtk && bundle install && ruby gtk.rb
* To run swing version: cd jruby && ruby swing.rb

# How to run the game with docker-compose
```
docker-compose up
```
Open http://localhost:8080/, click on "vnc_auto.html@"
Launch the game from terminal.

# How to run the game with docker
```
# this one:
make docker-build-and-run
# or that one:
docker build -t ruby-snake . && docker run -it -p 8080:8080 ruby-snake
```
Open http://localhost:8080/, click on "vnc_auto.html@"
Launch the game from terminal.
