require './config/environment'
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret_burrito_ingredient"
  end

  # register Sinatra::ActiveRecordExtenstion

  set :views, Proc.new { File.join(root, "../views/") }

  get "/" do
    # go to main splash/login page
    erb :'../index'
  end

  helpers do
    def is_logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
