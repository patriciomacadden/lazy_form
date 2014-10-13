require 'helper'

scope LazyForm::Tag do
  scope '#initialize' do
    test 'creates an instance of Tag' do
      tag = LazyForm::Tag.new 'input'
      assert_instance_of LazyForm::Tag, tag
    end
  end

  scope '#to_s' do
    test 'returns an html string' do
      tag = LazyForm::Tag.new 'br'
      assert_equal '<br/>', tag.to_s
    end

    test 'returns an html string with attributes' do
      tag = LazyForm::Tag.new 'hr', style: 'margin-top: 5px'
      assert_equal '<hr style="margin-top: 5px"/>', tag.to_s
    end

    test 'returns an html string with content' do
      tag = LazyForm::Tag.new('p') { 'Hello world' }
      assert_equal '<p>Hello world</p>', tag.to_s
    end

    test 'returns an html string with attributes and content' do
      tag = LazyForm::Tag.new('p', style: 'color: blue') { 'Hello world' }
      assert_equal '<p style="color: blue">Hello world</p>', tag.to_s
    end
  end

  scope '#build_attributes' do
    setup do
      @tag = LazyForm::Tag.new 'div'
    end

    test 'returns an array of attributes (k=v)' do
      attributes = @tag.send :build_attributes, key: 'value'
      assert_equal ['key="value"'], attributes
    end

    test 'returns an array of attributes with nested keys (for data-* attributes)' do
      attributes = @tag.send :build_attributes, data: { toggle: 'toggle' }
      assert_equal ['data-toggle="toggle"'], attributes
    end

    test 'returns an array of attributes with regular keys and nested keys' do
      attributes = @tag.send :build_attributes, key: 'value', data: { toggle: 'toggle' }
      assert_equal ['key="value"', 'data-toggle="toggle"'], attributes
    end
  end
end
