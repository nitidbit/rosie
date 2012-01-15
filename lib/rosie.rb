rootpath = File.join(File.dirname(__FILE__),'..')
require File.join(rootpath, 'lib/rosie/version')

if /^3\./.match Rails.version
  Dir[File.join(rootpath, "lib/tasks/**/*.rake")].each { |ext| load ext } if defined?(Rake)
end

module Rosie
  class Config
    @@allowed_attributes = [:backup_dir, :assets_dirs, :mysql_bin_dir, :config_file, :prefix]
    
    attr_accessor *@@allowed_attributes

    def initialize
      _config = {"backup_dir"=>"backups", "assets_dirs"=> ["public/system"], "mysql_bin_dir"=>nil, 'prefix' => nil} 
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
    
    def mysql_cmd
      mysql_bin_dir.present? ? File.join(mysql_bin_dir, 'mysql') : 'mysql'
    end

    def mysqldump_cmd
      mysql_bin_dir.present? ? File.join(mysql_bin_dir, 'mysqldump') : 'mysqldump'
    end
    
  end

end

