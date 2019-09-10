require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]
    source_options = through_options.model_class.assoc_options[source_name]
    source_table = source_options.model_class.table_name
    through_table = through_options.model_class.table_name

    define_method(name) do
      source_objs = DBConnection.execute(<<-SQL)
        SELECT
          #{source_table}.*
        FROM
          #{self.class.table_name}
        JOIN
          #{through_table}
          ON #{through_table}.id = #{self.class.table_name}.#{through_options.foreign_key}
        JOIN
          #{source_table}
          ON #{source_table}.id = #{through_table}.#{source_options.foreign_key}
        WHERE
          #{self.class.table_name}.id = "#{self.id}";
      SQL
      source_options.model_class.parse_all(source_objs).first
    end
  end
end
