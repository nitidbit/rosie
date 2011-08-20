require 'find'
require 'fileutils'
require 'tmpdir'
require 'yaml'

rosie = nil
ts = nil

def get_db_config
  alldbconf = YAML.load_file( File.join( [Rails.root, 'config','database.yml' ] ))
  env = Rails.env
  alldbconf[env]
end

def get_db_cmdline_args
  dbcnf = get_db_config
  args = []
  # NOTE: Assuming that database is running on localhost
  # TODO - if you use other args like :socket, or ? they are ignored
  # we could add host, port etc to make this more flexible
  [['--user=','username'], ['--password=','password']].each do |entry|
    if dbcnf[entry[1]].present?
      args << "#{entry[0]}#{dbcnf[entry[1]]}"
    end
  end
  args
end

namespace :rosie do
  task :init do
    rosie = Rosie::Config.new
  end

  desc "show config"
  task :config => 'rosie:init' do
    puts "Rosie Config: read from #{rosie.config_file}"
    puts "mysql: #{rosie.mysql_cmd}"
    puts "mysqldump: #{rosie.mysqldump_cmd}"
    puts "backup dir: #{rosie.backup_dir}"
    puts "assets dir: #{rosie.assets_dir}"
  end

  desc "restore data from backup tarball"
  task :restore => 'rosie:init' do
    puts "Restoring data..."    
    tarball = ENV["datafile"]
    if tarball.present? 
      tarball = File.expand_path(tarball)
      tmp = File.join(Dir.tmpdir, "rosie-restore")
      FileUtils.remove_dir(tmp, true)
      FileUtils.mkdir_p(tmp)
      if !File.exists?(tmp) 
        msg = "Unable to create a temporary directory.  Please check your file permissions.\nAttempted to create #{tmp}"
        raise msg
      end
      files_before = Dir.entries(tmp)
      sh "cd #{tmp} && tar -xzf #{tarball}"
      ts = Dir.entries(tmp).reject{ |f| files_before.include? f }.first
      unless ts.present?
        puts "*** Something went wrong while trying to unpack the datafile."
        exit 1
      end
      dbcnf = get_db_config
      data_dir = File.join(tmp, ts)
      image_tarball = File.join(data_dir, Dir.entries(data_dir).select{|f| f =~ /#{ts}.*\.tar/}.first)
      sql_dump = File.join(data_dir, Dir.entries(data_dir).select{|f| f =~ /#{ts}.*\.sql/}.first)
      args = get_db_cmdline_args
      `tar -C #{rosie.assets_dir} -xf #{image_tarball} && #{rosie.mysql_cmd} #{args.join(' ')} #{dbcnf['database']} < #{sql_dump}`
      
    else
      puts "*** You must specify the datafile from which to restore"
      puts "*** e.g.  % datafile=/home/me/2011010101.tgz rake rosie:restore"
      exit 1
    end
  end

  desc "backup all data"
  task :backup => ["rosie:backups:db", "rosie:backups:assets"] do
    `cd #{rosie.backup_dir}/#{ts}/../ && tar -czvf #{ts}.tgz ./#{ts} && rm -rf #{ts}`
  end

  namespace :backups do
    task :init => 'rosie:init' do
      ts = Time.now.strftime('%Y%m%d%H%m%S')
    end

    task :db => 'rosie:backups:init' do
      dbcnf = get_db_config
      db_file = "#{dbcnf['database']}-#{ts}.backup.sql"
      path = File.join(rosie.backup_dir, ts, db_file)
      args = get_db_cmdline_args
      `mkdir -p #{rosie.backup_dir}/#{ts} && #{rosie.mysqldump_cmd} #{args.join(' ')} --single-transaction #{dbcnf['database']} > #{path}`
    end

    task :assets => 'rosie:backups:init' do
      `tar -C #{rosie.assets_dir} -cvf #{rosie.backup_dir}/#{ts}/rosie_backup_#{Rails.env}_#{ts}.tar .`
    end

  end
  
end

