module FriendlyAdmin
  module Dsl
    module Pagination
      extend ActiveSupport::Concern

      included do
        protected
        cattr_accessor :pagination_settings

        if defined?(:end_of_association_chain)
          alias_method_chain :end_of_association_chain, :pagination
        end
      end

      # Applies pagination settings to given scope.
      # If inherited_resources is used it applies automatically.
      # If used standalone must be called manually.
      def apply_pagination_scope(scope)
        settings = pagination_settings
        settings = instance_exec(&settings) if settings.is_a?(Proc)

        unless settings.nil?
          page = settings[:page] || params[:page]
          per_page = settings[:per_page]
          padding = settings[:padding]

          if defined?(::Kaminari)
            scope = scope.page(page).per(per_page).padding(padding)
          elsif defined?(::WillPaginate)
            scope = scope.paginate(page: page, per_page: per)
          else
            raise StandardError, 'Only WillPaginate & Kaminari are supported by friendly_admin'
          end
        end
        scope
      end

      # InheritedResousrces hook
      def end_of_association_chain_with_pagination
        scope = end_of_association_chain_without_pagination
        scope = apply_pagination_scope(scope)
        scope
      end

      module ClassMethods
        # Set pagination options for controller
        #
        # Examples:
        #   paginated true
        #   paginated per_page: 100
        #   paginated do
        #     { per: Settings.per_page }
        #   end
        def paginated(options = {}, &block)
          self.pagination_settings = block_given? ? block : options
        end
      end
    end
  end
end