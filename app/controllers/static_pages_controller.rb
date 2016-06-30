class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
    authorize :StaticPage, :about?
  end

  def contact
  end
end
