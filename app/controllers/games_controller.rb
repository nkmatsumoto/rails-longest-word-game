require "open-uri"

class GamesController < ApplicationController
  def new
        # TODO: generate random grid of letters
        alphabet = ('A'..'Z').to_a * 2
        @letters = alphabet.sample(10)
        session[:score] = 0 unless session[:score]
        # raise
  end

  def score

    @letters = params[:letters]
    @attempt = params[:attempt]

    url = "https://dictionary.lewagon.com/#{@attempt}"
    attempt_serialized = URI.open(url).read
    word = JSON.parse(attempt_serialized)

    if @attempt.upcase.chars.all? { |letter| @attempt.upcase.count(letter) <= @letters.count(letter) }
      if word["found"]
        # (attempt.upcase.chars & grid) == attempt.upcase.chars
        # Calculate score
        # The score depends on the time taken to answer, plus the length of the word you submit.
        # The longer the word and the quicker the time, the better the score!
        # Feel free to invent your own penalty rules too!
        # if attempt.chars.lenght > grid_size.length
        @message = "Congratulations! #{@attempt} is a valid English word!"
        session[:score] += @attempt.length
      else
        # word["found"] == false
        @message = "Sorry, #{@attempt} doesnt seem to be an english word"
      end
    else
    # !(attempt.upcase.chars & grid).all?
    # If the word is not valid or is not in the grid, the score will be 0
    # should be accompanied by a message to the player explaining why they didn't score any points.
    @message = "Sorry, #{@attempt} can't be built from #{@letters}"
    end

  end


end
