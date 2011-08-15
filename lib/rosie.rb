rootpath = File.join(File.dirname(__FILE__),'..')
require File.join(rootpath, 'lib/rosie/version')

Dir[File.join(rootpath, "lib/tasks/**/*.rake")].each { |ext| load ext } if defined?(Rake)

module Rosie
  class Config
    @@allowed_attributes = [:backup_dir, :assets_dir, :mysql_bin_dir, :config_file]
    
    attr_accessor *@@allowed_attributes

    def initialize
      _config = {"backup_dir"=>"backups", "assets_dir"=>"public/system", "mysql_bin_dir"=>nil} 
      self.config_file = File.join(Rails.root, 'config/rosie.yml')
      if File.exists? self.config_file
        _config.merge!(YAML.load(File.open(self.config_file)))
      end
      _config.keys.each do |attr|
        self.send(attr+"=",_config[attr]) if @@allowed_attributes.include? attr.to_sym
      end
    end
    
    def backup_dir
      File.join(Rails.root, @backup_dir)
    end
    
    def assets_dir
      File.join(Rails.root, @assets_dir)
    end

    def mysql_cmd
      mysql_bin_dir.present? ? File.join(mysql_bin_dir, 'mysql') : 'mysql'
    end

    def mysqladmin_cmd
      mysql_bin_dir.present? ? File.join(mysql_bin_dir, 'mysqladmin') : 'mysqladmin'
    end
  end

end

