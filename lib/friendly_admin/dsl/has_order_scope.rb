module FriendlyAdmin
  module Dsl
    module HasOrderScope
      extend ::ActiveSupport::Concern

      # TODO: Get it work when > 1 field (order[]=name&order[]=asc&order[]=email&order[]=desc)
      module ClassMethods
        # HasScopes extension to apply sorting scope.
        # Creates instance variable contains applied order.
        #
        # Example:
        #   has_order_scope
        #   has_order_scope columns: [:id, :email]
        #   has_order_scope :sort, param: 'sort', default: [:email, :asc]
        #   # @sort == [:email, :asc]
        def has_order_scope(*args)
          unless defined?(:has_scope)
            raise StandardError, 'Add gem "has_scopes" to your Gemfile to use has_order_scope'
          end

          options = args.extract_options!

          scope_name = args.first || :order
          param_name = options.delete(:param)
          columns    = options.delete(:columns)
          columns    = columns.map(&:to_s) if columns.present?

          options.merge!(type: :array)

          has_scope(scope_name, options) do |controller, scope, value|
            column, direction = value

            if columns.present?
              unless columns.include?(column)
                raise ArgumentError, "Can not sort by #{column}. Sorting is limited to #{columns.inspect}"
              end
            end

            unless direction.to_s.in? %w(asc desc)
              raise ArgumentError, 'Scope direction must be "asc" or "desc"'
            end

            instance_variable_set("@#{scope_name}", value)

            scope.order(%{ "#{scope.table_name}"."#{column}" #{direction} })
          end
       end
      end
    end
  end
end