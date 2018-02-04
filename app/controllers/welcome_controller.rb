class WelcomeController < ApplicationController
  def index
    flash[:notice] = "發表你的評論吧～"
  end
end
