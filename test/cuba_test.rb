require 'helper'

require 'cuba'
require 'cuba/render'

Cuba.plugin Cuba::Render
Cuba.plugin LazyForm::Helper

Cuba.settings[:render][:views] = 'test/fixtures'

Cuba.define do
  on default do
    res.write partial '_form'
  end
end

scope 'test Cuba' do
  def app
    Cuba
  end

  test 'displays a form' do
    get '/'
    assert_status 200
    assert last_response.body.include? "<form action=\"/person\" method=\"POST\">\n  <label for=\"person_first_name\">First name</label>\n  <input id=\"person_first_name\" name=\"person[first_name]\" type=\"text\"/>\n</form>"
  end
end
