require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || (name.to_s.underscore.downcase + "_id").to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || (self_class_name.underscore.downcase + "_id").to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options_obj = BelongsToOptions.new(name, options)
    assoc_options[name] = options_obj
    define_method(name) do
      foreign_key = self.send(options_obj.foreign_key)
      foreign_class_name = options_obj.model_class
      foreign_class_name.where(:id => foreign_key).first
    end
  end

  def has_many(name, options = {})
    options_obj = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      foreign_class_name = options_obj.model_class
      foreign_class_name.where(options_obj.foreign_key => self.id)
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    @assoc_options ||= Hash.new
  end
end

class SQLObject
  extend Associatable
end
