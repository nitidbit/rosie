puts "loaded rosie.rake"
namespace :rosie do
  desc "show config"
  task :config do
    Rosie.config.each do |k,v|
      puts "Rosie: #{k} => #{v}"
    end
  end
  desc "restore data from backup tarball"
  task :restore do
    puts "Restoring data..."
  end
end


