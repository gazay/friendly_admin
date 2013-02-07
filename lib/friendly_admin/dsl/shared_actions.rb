module FriendlyAdmin
  module Dsl
    module SharedActions
      extend ActiveSupport::Concern

      included do
        cattr_accessor :shared_actions, instance_writer: false
      end

      module ClassMethods
        protected
        def shared_actions(*actions)
          actions.each do |action|
            define_method action do
              instance_exec(&shared_actions[action])
            end
          end
        end

        def define_shared_action(action, &proc)
          shared_actions[action] = proc
        end
      end
    end
  end
end