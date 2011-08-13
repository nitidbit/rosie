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

Configuration values can be set by placing a rosie.yml file in your config directory.  Default keys and values are as follows:

<pre>
# sample rosie.yml
#
backup_dir:backups    
assets_dir:public/system
mysql_bin_dir: 

</pre>

* `backup_dir`: This should be specified relative to your Rails root.  This setting would give you `#{Rails.root}/backups`.
* `assets_dir`: This should be specified relative to your Rails root.  This directory is the one that is holding any system assets you'd like to have backed up along side the database dump.
* `mysql_bin_dir`: If mysql and mysqldump are not on the path of the user running this rake task, you may need to specify the directory where those commandline applications live.  This should be an absolute path.   By default, Rosie will try to find these in the user's PATH.

## Validation

Tested on OSX 10.6/Ubuntu 11

## Usage

## Credits
Developed by Jon Rogers and Jeremy Yun @ 2rye.com
