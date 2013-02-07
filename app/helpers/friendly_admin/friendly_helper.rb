module FriendlyAdmin
  module FriendlyHelper
    # TODO: :badge, :badge_class, :container_options, :link_options
    # Creates menu item in navbar.
    def friendly_menu_item(label, path)
      state = path_state(url_for(path))

      if label.is_a?(Symbol)
        label = label.to_s.singularize.classify.constantize.model_name.human
      end

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

    def friendly_resource_title
      I18n.t(
        "#{controller.controller_path}/#{controller.action_name}",
        scope: 'controllers',
        default: resource_class.model_name.human
      )
    end

    def friendly_form_actions
      %{
        <div class="form-actions">
          #{submit_tag :save, class: 'btn btn-primary'}
          or
          #{link_to :cancel, collection_url}
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