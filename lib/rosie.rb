rootpath = File.join(File.dirname(__FILE__),'..')
require File.join(rootpath, 'lib/rosie/version')

Dir[File.join(rootpath, "lib/tasks/**/*.rake")].each { |ext| load ext } if defined?(Rake)

module Rosie
  class Config
    @@allowed_attributes = [:backup_dir, :assets_dir, :mysql_bin_dir]
    
    attr_accessor *@@allowed_attributes

    def initialize
      _config = {"backup_dir"=>"backups", "assets_dir"=>"public/system", "mysql_bin_dir"=>nil} 
      config_file = File.join(File.dirname(__FILE__), '../config/rosie.yml')
      if File.exists? config_file
        _config.merge!(YAML.load(config_file))
      end
      _config.keys.each do |attr|
        self.send(attr+"=",_config[attr]) if @@allowed_attributes.include? attr.to_sym
      end
    end
  end

end

