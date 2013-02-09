module FriendlyAdmin
  module Dsl
    extend ActiveSupport::Concern

    included do
      include Base
      include SharedActions
      include Pagination
      include HasOrderScope
    end
  end
end