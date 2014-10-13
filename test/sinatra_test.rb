require 'helper'

require 'sinatra/base'
require 'lazy_form/sinatra'

class SinatraApp < Sinatra::Base
  include LazyForm::Helper

  set :views, 'test/fixtures'

  get '/' do
    erb :'_form', layout: false
  end
end

scope 'test Sinatra' do
  def app
    SinatraApp
  end

  test 'displays a form' do
    get '/'
    assert_status 200
    assert last_response.body.include? "<form action=\"/person\" method=\"POST\">\n  <label for=\"person_first_name\">First name</label>\n  <input id=\"person_first_name\" name=\"person[first_name]\" type=\"text\"/>\n</form>"
  end
end
