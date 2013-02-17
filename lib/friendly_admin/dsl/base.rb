module FriendlyAdmin
  module Dsl
    module Base
      extend ActiveSupport::Concern

      included do
        layout 'friendly_admin'

        prepend_before_filter :lookup_default_template
        helper_method         :controller_namespace
      end

      # Current controller namespace
      def controller_namespace
        controller_path.split('/').slice(0..-2).join('/')
      end

      private
      # Sets folder precedence to lookup admin template overrides for.
      # For example, any template or partial at Admin::UserController#index
      # it looks at:
      #   - app/views/admin/users
      #   - app/views/admin/friendly_admin
      #   - app/views/friendly_admin
      #   - gem
      def lookup_default_template
        lookup_context.view_paths.unshift(
          File.join(
            Rails.application.paths['app/views'].expanded.first,
            controller_namespace
          )
        )
        lookup_context.prefixes << 'friendly_admin'
      end
    end
  end
end