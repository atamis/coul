# Thanks, http://speakmy.name/2011/05/29/simple-configuration-for-ruby-apps/
module AppData
  # we don't want to instantiate this class - it's a singleton,
  # so just keep it as a self-extended module
  extend self

  # Appdata provides a basic single-method DSL with .parameter method
  # being used to define a set of available settings.
  # This method takes one or more symbols, with each one being
  # a name of the configuration option.
  def parameter(*names)
    names.each do |name|
      attr_accessor name

      # For each given symbol we generate accessor method that sets option's
      # value being called with an argument, or returns option's current value
      # when called without arguments
      define_method name do |*values|
        value = values.first
        value ? self.send("#{name}=", value) : instance_variable_get("@#{name}")
      end
    end
  end

  def parameter_array(*names)
    names.each do |name|
      attr_accessor name
      self.send("#{name}=", [])
      define_method name do |*values|
        if values.empty?
          return instance_variable_get("@#{name}")
        else
          values.each do |v|
            instance_variable_get("@#{name}") << v
          end
        end
      end
    end
  end

  # And we define a wrapper for the configuration block, that we'll use to set up
  # our set of options
  def config(&block)
    instance_eval &block
  end

end

class NullLogger
  def debug(*); end
  def info(*); end
  def warn(*); end
  def error(*); end
  def fatal(*); end
end

