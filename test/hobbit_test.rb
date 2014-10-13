require 'helper'

require 'hobbit'
require 'hobbit/render'

class HobbitApp < Hobbit::Base
  include Hobbit::Render
  include LazyForm::Helper

  def views_path
    'test/fixtures'
  end

  get '/' do
    partial 'form'
  end
end

scope 'test Hobbit' do
  def app
    HobbitApp
  end

  test 'displays a form' do
    get '/'
    assert_status 200
    assert last_response.body.include? "<form action=\"/person\" method=\"POST\">\n  <label for=\"person_first_name\">First name</label>\n  <input id=\"person_first_name\" name=\"person[first_name]\" type=\"text\"/>\n</form>"
  end
end
