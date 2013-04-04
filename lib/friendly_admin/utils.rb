class FA::Utils

  @@models = nil

  class << self

    def structure
      @@models ||= FA::Utils::Structurizer.fetch
    end

  end
end
