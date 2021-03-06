# frozen_string_literal: true

module Cask
  class Cmd
    class Uninstall < AbstractCommand
      option "--force", :force, false

      def initialize(*)
        super
        raise CaskUnspecifiedError if args.empty?
      end

      def run
        self.class.uninstall_casks(
          *casks,
          binaries: binaries?,
          verbose:  verbose?,
          force:    force?,
        )
      end

      def self.uninstall_casks(*casks, verbose: false, force: false, binaries: nil)
        binaries = Homebrew::EnvConfig.cask_opts_binaries? if binaries.nil?

        casks.each do |cask|
          odebug "Uninstalling Cask #{cask}"

          raise CaskNotInstalledError, cask unless cask.installed? || force

          if cask.installed? && !cask.installed_caskfile.nil?
            # use the same cask file that was used for installation, if possible
            cask = CaskLoader.load(cask.installed_caskfile) if cask.installed_caskfile.exist?
          end

          Installer.new(cask, binaries: binaries, verbose: verbose, force: force).uninstall

          next if (versions = cask.versions).empty?

          puts <<~EOS
            #{cask} #{versions.to_sentence} #{"is".pluralize(versions.count)} still installed.
            Remove #{(versions.count == 1) ? "it" : "them all"} with `brew cask uninstall --force #{cask}`.
          EOS
        end
      end

      def self.help
        "uninstalls the given Cask"
      end
    end
  end
end
