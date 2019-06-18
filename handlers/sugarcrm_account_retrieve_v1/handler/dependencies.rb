# Load the ruby ActiveSupport library unless it has already been loaded.  This
# prevents multiple handlers using the same library from causing problems.
if not defined?(ActiveSupport)
  # Calculate the location of this file
  handler_path = File.expand_path(File.dirname(__FILE__))
  # Calculate the location of our dependent library, we can't load this
  # initially due to a circular dependency.
  library_path = File.join(handler_path, 'vendor/i18n-0.5.0/lib')
  $:.unshift library_path
  # Calculate the location of our library and add it to the Ruby load path
  library_path = File.join(handler_path, 'vendor/activesupport-3.0.4/lib')
  $:.unshift library_path
  # Require the library
  require 'active_support'
end

# Load the ruby SugarCRM library unless it has already been loaded.  This prevents
# multiple handlers using the same library from causing problems.
if not defined?(SugarCRM)
  # Calculate the location of this file
  handler_path = File.expand_path(File.dirname(__FILE__))
  # Calculate the location of our library and add it to the Ruby load path
  library_path = File.join(handler_path, 'vendor/sugarcrm-0.9.8/lib')
  $:.unshift library_path
  # Require the library
  require 'sugarcrm'
end