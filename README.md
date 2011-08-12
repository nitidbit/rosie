# Rosie

## Intro

Backup and restore your MySQL db and dependent local assets (e.g. PaperClip uploads)

Named after Rosie, the maid from the Jetsons (http://en.wikipedia.org/wiki/Rosie_the_Robot_Maid#Rosie).  The gem provides two rake tasks which will backup or restore a MySQL database along with any dependent file system assets (like uploaded files from PaperClip) into a single timestamped file.  

## Requirements

* Rails3
* MySQL > 5 with commandline tools (mysql, mysqladmin, mysqldump)
* Unix(ish) system shell with tar

## Installation

Add rosie to your Gemfile:

<pre>
gem 'rosie'
</pre>

Use bundler to install it:

<pre>
bundle install
</pre>

## Configuration

<pre>
YourApp::Application.configure do
  config.rosie.something = something
end
</pre>


## Validation

Tested on OSX 10.6/Ubuntu 11

## Usage

## Credits
Developed by Jon Rogers and Jeremy Yun @ 2rye.com
