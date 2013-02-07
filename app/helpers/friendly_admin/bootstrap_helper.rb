module FriendlyAdmin
  module BootstrapHelper
    def bootstrap_icon(type, *args)
      options = args.extract_options!
      css_class = options.delete(:class)
      args << {:class => ["icon-#{type}", css_class].compact.join(' ')}.merge(options)
      content_tag(:i, nil, *args)
    end
  end
end