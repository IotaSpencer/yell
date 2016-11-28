# frozen_string_literal: true
module Yell #:nodoc:
  module Helpers #:nodoc:
    module Adapter #:nodoc:
      # Define an adapter to be used for logging.
      #
      # @example Standard adapter
      #   adapter :file
      #
      # @example Standard adapter with filename
      #   adapter :file, 'development.log'
      #
      #   # Alternative notation for filename in options
      #   adapter :file, :filename => 'developent.log'
      #
      # @example Standard adapter with filename and additional options
      #   adapter :file, 'development.log', :level => :warn
      #
      # @example Set the adapter directly from an adapter instance
      #   adapter Yell::Adapter::File.new
      #
      # @param [Symbol] type The type of the adapter
      # @return [Yell::Adapter] The instance
      # @raise [Yell::NoSuchAdapter] Will be thrown when the adapter is not defined
      def adapter(type = :file, *args, &block)
        adapters.add(type, *args, &block)
      end

      def adapters
        @__adapters__
      end

      private

      def reset!(options = {})
        @__adapters__ = Yell::Adapters::Collection.new

        presets = Yell.__fetch__(options, :adapters, default: [])
        presets.each do |preset|
          if preset.is_a?(Hash)
            Array(preset).each do |type, name|
              adapters.add(type, name, options)
            end
          else
            adapters.add(preset, options)
          end
        end

        super(options)
      end
    end
  end
end
