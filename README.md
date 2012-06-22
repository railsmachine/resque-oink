resque-oink
-----------

If using bundler, add to Gemfile:

    gem 'resque-oink'

Or in Rails 2.3 land, add to `config/environment.rb`:

    config.gem 'resque-oink'


Now, you can extend your job with `Resque::Plugins::Oink`. Following the [resque Archive example](https://github.com/defunkt/resque).

    class Archive
      extend Resque::Plugins::Oink

      @queue = :file_serve
    
      def self.perform(repo_id, branch = 'master')
        repo = Repository.find(repo_id)
        repo.create_archive(branch)
      end
    end   


Copyright
=========

Copyright (c) 2012 Rails Machine. See LICENSE.txt for
further details.

