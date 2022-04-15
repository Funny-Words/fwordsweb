require "funny_wrds"

struct APIRouter
  API_VER = "1"
  @fwords : FunnyWords = FunnyWords.new("./words.json")

  def initialize
    # Filter
    before_all "/api/v#{API_VER}/words" do |env|
      env.response.content_type = "application/json"
    end

    # Words route
    get "/api/v#{API_VER}/words" do |env|
      q = env.params.query["q"][0..2]
      words_quantity = if q.matches?(/\d+/)
        (1..40).includes?(q.to_i) ? q.to_i : 5
      else
        5
      end

      {"words": @fwords.get_words(words_quantity)}.to_json
    end

    # Filter
    before_all "/api/v#{API_VER}/cword" do |env|
      env.response.content_type = "application/json"
    end

    # Cword route
    get "/api/v#{API_VER}/cword" do
      {"cword": @fwords.get_cword}.to_json
    end

    # Filter
    before_all "/api/v#{API_VER}/allwords" do |env|
      env.response.content_type = "application/json"
    end

    # All words in Array(String) route
    get "/api/v#{API_VER}/allwords" do
      {"allwords": @fwords.get_arr}.to_json
    end

    get "/api/v1/words/add_word" do |env|
      if Storage.verify_token env
        {"msg": "LOL"}.to_json
      else
        halt env, 403, "403: Forbidden"
      end
    end
  end
end
