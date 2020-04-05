# frozen_string_literal: true

require "rubocops/extend/formula"

module RuboCop
  module Cop
    module FormulaAuditStrict
      # This cop audits `uses_from_macos` dependencies in formulae
      class UsesFromMacos < FormulaCop
        def audit_formula(_node, _class_node, _parent_class_node, body_node)
          find_method_with_args(body_node, :uses_from_macos, /^(perl|php|python@2|ruby)/).each do |method|
            dep = parameters(method).first
            problem "`uses_from_macos` should only be used for macOS dependencies, not #{dep} #{string_content(dep)}."
          end
        end
      end
    end
  end
end