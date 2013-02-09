module FriendlyAdmin
  module FriendlyHelper
    # TODO: :badge, :badge_class, :container_options, :link_options
    # Creates menu item in navbar.
    def friendly_menu_item(label, path)
      state = path_state(url_for(path))

      begin
        if label.is_a?(Symbol)
          default_label = label.to_s.singularize.classify.constantize.model_name.human
        end
      rescue nil
      end

      label = friendly_t(
        label,
        default: default_label,
        count: 1
      )

      content_tag :li, :class => ('active' unless state == :inactive) do
        link_to(label, path)
      end
    end

    def friendly_table(&block)
      %{
        <table class="table table-condenced">
          #{capture(&block)}
        </table>
      }.html_safe
    end

    def friendly_row_checkbox(row)
      check_box_tag 'id[]', row.id
    end

    def friendly_resource_action(action, resource, url = nil, *args)
      icon = FRIENDLY_ACTION_ICONS[action]

      url ||= case action
      when :edit then resource_url([resource, :edit], *args)
      when :destroy then collection_url
      end

      link_to bootstrap_icon(icon), url
    end

    def friendly_column_name(id)
      resource_class.human_attribute_name(id)
    end

    def friendly_form_url(*args)
      if resource.new_record?
        collection_url(*args)
      else
        resource_url(*args)
      end
    end

    def friendly_t(key, options = {})
      options[:default] ||= []
      options[:default] = Array.wrap(options[:default])

      controller_path_dotted = controller_path.gsub('/', '.')

      options[:default].unshift(:"defaults.#{key}")
      options[:default].unshift(:"#{controller_path_dotted}.defaults.#{key}")
      options[:default].unshift(:"#{controller_path}.#{action_name}.#{key}")
      options[:default].unshift(:"#{controller_path_dotted}.#{action_name}.#{key}")

      options[:scope] = ['friendly_admin', options[:scope]].compact.flatten

      t(
        key,
        options
      )
    end

    def friendly_simple_form_actions(f)
      %{
        <div class="form-actions">
          #{f.button :submit, class: 'btn btn-primary'}
          &nbsp;
          &nbsp;
          #{link_to friendly_t(:cancel), collection_url}
        </div>
      }.html_safe
    end

    # TODO: Parameterize sort param
    def friendly_sort_mark(id)
      attribute, direction = params[:order]
      if attribute == id.to_s
        SORT_DIRECTIONS[direction.to_sym].html_safe
      end
    end

    private
    def path_state(path)
      if path == request.path
        :active
      else
        request.path.starts_with?(path) ? :chosen : :inactive
      end
    end

    FRIENDLY_ACTION_ICONS = {
      edit: :pencil,
      destroy: :trash
    }

    SORT_DIRECTIONS = {asc: '&#x25B2;', desc: '&#x25BC;'}
  end
end