require 'bundler/setup'

require 'oktobertest'
require 'oktobertest/contrib'

require 'lazy_form'

class Person
  attr_accessor :birth_date, :first_name, :gender, :last_name
end
