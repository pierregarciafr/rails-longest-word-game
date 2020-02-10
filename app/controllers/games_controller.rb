class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    require 'open-uri'
    require 'json'

    @word = params[:word].downcase
    @letters = params[:letters].upcase.chars
    url_api = "https://wagon-dictionary.herokuapp.com/#{@word}"
    @user = JSON.parse(open(url_api).read)

    @result = params[:word].upcase.chars
    @result.length.times do
      if @letters.include?(@result.first)
        remove = @result.shift
        @letters.delete_at(@letters.index(remove))
      else
        @result.push(@result.shift)
      end
    end

    if @result != []
      @message = "Sorry but #{@word.upcase} can't be built from #{params[:letters].upcase.chars.join(',')} !"
    elsif !@user["found"]
      @message = "Sorry, #{@word.upcase} is not an english word !"
    elsif @user["found"]
      @message = "Congratulations ! #{@word.upcase} is a valid english word !"
    else
      @message = 'Unknown problem happened'
    end

  end
end
