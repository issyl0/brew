# frozen_string_literal: true

module Homebrew
  module MissingFormula
    class << self
      def cask_reason(*)
        # Casks aren't supported on non-MacOS.
      end
    end
  end
end
