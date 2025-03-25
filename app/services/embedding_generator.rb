require 'net/http'
require 'json'

class EmbeddingGenerator
  API_KEY = ENV['OPENAI_API_KEY']

  def self.generate_embedding(text)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-ada-002',
        input: text
      }
    )

    response['data'][0]['embedding']
  end
end
