module FriendlyAdmin
  module Dsl
    extend ActiveSupport::Concern

    included do
      include Base
      include SharedActions
    end
  end
end