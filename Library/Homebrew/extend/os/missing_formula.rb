# frozen_string_literal: true

require "extend/os/mac/missing_formula" if OS.mac?
require "extend/os/linux/missing_formula" if OS.linux?
