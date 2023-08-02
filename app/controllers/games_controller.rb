require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def initialize
    @letters = []
  end

  def new
    @letters = Array.new(9) { ('A'..'Z').to_a.sample } #how do i ensure that my @letters variable can also be used in score
  end

  def score
    @answer = params[:answer]
    @result = run_game(@answer, @letters) #not sure why none of my results are showing but ok!
  end

  private

  def run_game(attempt, grid)
    if check_letters(attempt, grid) == false
      return `Sorry but #{attempt} can't be built out of #{grid}.` # need to change this to bolded ans and letters w/o array
    elsif check_letters(attempt, grid)
      return `Sorry but #{attempt} does not seem to be a valid english word.`
    elsif eng_word_checker(attempt)["found"] && check_letters(attempt, grid)
      return `Congratulations! #{attempt} is a valid english word`
    end
  end

  def eng_word_checker(attempt)
    url_checker = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    url_serialized = URI.open(url_checker).read
    eng_word = JSON.parse(url_serialized)
    return eng_word
  end

  def check_letters(attempt, grid)
    attempt_array = attempt.upcase.chars

    attempt_array.each do |letter|
      return false unless grid.include?(letter)
      return false unless attempt_array.count(letter) <= grid.count(letter)
    end
    return true
  end


end
