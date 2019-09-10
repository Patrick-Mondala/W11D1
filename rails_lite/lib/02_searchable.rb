require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.map { |key, value| "#{ key } = ?" }.join(" AND ")
    obj = DBConnection.execute(<<-SQL, params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    parse_all(obj)
  end
end

class SQLObject
  extend Searchable
end
