module FriendlyAdmin
  module PieceHelper
    def friendly_piece(key, content = nil, &block)
      piece = _friendly_piece(key)
      if content || block_given?
        piece.clear
        piece.push(content || block)
        nil
      else
        piece.map { |piece|
          piece.respond_to?(:call) ? capture(&piece) : piece
        }.join.html_safe
      end
    end

    def prepend_friendly_piece(key, content = nil, &block)
      _asset_content_present(content, &block)
      _friendly_piece(key).unshift(content || block)
    end

    def append_friendly_piece(key, content = nil, &block)
      _asset_content_present(content, &block)
      _friendly_piece(key).push(content || block)
    end

    private
    def _friendly_piece(key)
      @_friendly_pieces ||= {}
      @_friendly_pieces[key] ||= []
      @_friendly_pieces[key]
    end

    def _assert_content_present(content, &block)
      raise ArgumentError, 'Give content or block' unless content || block_given?
    end
  end
end