AlchemyAPI.configure do |config|
  config.apikey = ENV["ALCHEMY_API_KEY"]
end

class ThinkingSphinx::Excerpter
  def excerpt!(text)
    ThinkingSphinx::Connection.take do |connection|
      connection.query(statement_for(text)).first['snippet']
    end
  end
end