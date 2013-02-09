module FriendlyAdmin
  module Dsl
    module Base
      extend ActiveSupport::Concern

      included do
        inherit_resources
        layout 'friendly_admin'

        prepend_before_filter :lookup_friendly_admin_templates
        helper_method :controller_namespace
      end

      # Current controller namespace
      def controller_namespace
        controller_path.split('/').slice(0..-2).join('/')
      end

      private
      # Sets folder precedence to lookup admin template overrides for.
      # It looks at:
      #   - current controller folder
      #   - app/views/#{namespace}/#{base controller name}
      #   - app/views/friendly_admin
      #   - gem view folder
      def lookup_friendly_admin_templates
        self.lookup_context.prefixes << "#{controller_namespace}/friendly_admin"
        self.lookup_context.prefixes << 'friendly_admin'
      end
    end
  end
end