namespace :radiant do
  namespace :extensions do
    namespace :groups do
      
      desc "Runs the migration of the Groups extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          GroupsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          GroupsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Groups to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[GroupsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(GroupsExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
