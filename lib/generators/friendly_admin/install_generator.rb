require 'rails/generators'

module FA
  class InstallGenerator < Rails::Generators::Base

    desc "Friendly admin installation generator"

    def install
      debugger
      FA::Utils.structure
      puts 'Hello!'
    end

  end
end
