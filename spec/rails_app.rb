require 'rails'
require 'action_controller/railtie'

class Dummy < Rails::Application
  config.root = File.dirname(__FILE__)
  config.session_store :cookie_store, key: '****************************************'
  config.secret_token = '****************************************'
  config.logger = Logger.new(STDOUT)
  Rails.logger = config.logger
  routes.draw do
    get '/dummies'  => 'dummy#index', as: :dummies
  end
end

class DummyController < ActionController::Base
  def index
    render text: 'Home'
  end
end
