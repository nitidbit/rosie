# Rosie

## Intro

Backup and restore your MySQL db and dependent local assets (e.g. PaperClip uploads)

The gem provides two rake tasks which will backup or restore a MySQL database along with any dependent file system assets (like uploaded files from PaperClip) into a single timestamped file.  

## Requirements

* Rails (2.3.x or 3.x)
* MySQL > 5 with commandline tools (mysql, mysqladmin, mysqldump)
* Unix(ish) system shell with tar

## Installation

Add rosie to your Gemfile:

    gem 'rosie'

Use bundler to install it:

    bundle install

### Rails 2.3.x
If you're using Rails 2, you'll need to add a couple lines to your `Rakefile`.  
After all the requires, add the following:
    
    require 'rosie'
    
    Dir["#{Gem.searcher.find('rosie').full_gem_path}/lib/tasks/**/*.rake"].each { |ext| load ext }
    
## Configuration

Configuration values can be set by placing a rosie.yml file in your config directory.  Default keys and values are as follows:

    # sample rosie.yml
    #
    backup_dir:backups    
    assets_dirs:
      - public/system
    mysql_bin_dir: 
    
    prefix: my_app

* `backup_dir`: This specifies the directory where the backup files will be stored.  It should be specified relative to your Rails root.  This setting would give you `#{Rails.root}/backups`.  
* `assets_dirs`: This specifies the directorys which hold system assets you want to be added to the backup file.  All entries should be specified relative to your Rails root.
* `mysql_bin_dir`: If mysql and mysqldump are not on the path of the user running this rake task, you may need to specify the directory where those commandline applications live.  This should be an absolute path.   By default, Rosie will try to find these in the user's PATH.
* `prefix`: If specified, this provides a way to prefix your database backup files with an app (or other) name.  If present, backup files will look like <my_app>_<timestamp>.tgz
The generated backup files (zipped tarballs) will be named by timestamp and placed in `backup_dir`.

## Usage

After installing the gem as described above, add the rosie.yml file to your #{Rails.root}/config/ directory with settings appropriate to your app.  The gem installs the following three tasks:

* `rosie:config`
* `rosie:backup`
* `rosie:restore`


### Task rosie:config

`rosie:config` will show you what it's derived from your config.

    % rake rosie:config
    Rosie Config: read from /projects/boilerplate/config/rosie.yml
    mysql: mysql
    mysqldump: mysqldump
    backup dir: /projects/boilerplate/my_backups
    assets dirs: public/my_assets, public/my_other_assets
    prefix: my_backup_file_prefix


### Task rosie:backup

If you've checked out the configuration, and things look good, you can run a backup like this:

    % rake rosie:backup

You'll find a new file under your `backups` dir (or whatever you've specified as the backup dir in your config).

### Task rosie:restore

To restore, run `rosie:restore`.  You'll need to add the commandline parameter `datafile` to tell rosie which file you are trying to restore from.

For example:
    % rake rosie:restore datafile=~/Downloads/20110817180817.tgz

Rosie does not run migrations, so if you're pulling data from a database whose schema may be out of date with the system on which you're restoring, you probably will want to run a db:migrate after the restore.

## Validation

Tested with Ruby 1.9.2-p180 on OSX 10.6/Ubuntu 10.10/11

## TODO
* add ability to backup remote databases (not on localhost)
* add alternate database support

## Credits
Developed by Jon Rogers and Jeremy Yun @ 2rye.com
Named after Rosie, the maid from the Jetsons (http://techland.time.com/2010/04/20/sci-fi-sexy-time-all-time-hottest-robots/500_rosie_jetsons/).  
