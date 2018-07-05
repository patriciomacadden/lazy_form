require 'helper'

scope LazyForm::Builder do
  setup do
    @person = Person.new
    @builder = LazyForm::Builder.new @person
  end

  scope '#initialize' do
    test 'returns a form builder' do
      assert_instance_of LazyForm::Builder, @builder
    end
  end

  LazyForm::Tag::BOOLEAN_ATTRIBUTES.each do |attr|
    scope attr do
      test "returns an input with #{attr} attribute" do
        assert_equal "<input #{attr} id=\"person_name\" name=\"person[name]\" type=\"radio\"/>", @builder.radio(:name, "#{attr}": :true).to_s
      end
    end
  end

  LazyForm::Builder::BUTTONS.each do |type|
    scope type do
      test "returns a #{type} input" do
        tag = @builder.send type
        assert_equal "<input type=\"#{type}\"/>", tag.to_s
      end

      test "returns a #{type} input with attributes" do
        tag = @builder.send type, style: 'margin-top: 5px', data: { something: 'something' }
        assert_equal "<input style=\"margin-top: 5px\" data-something=\"something\" type=\"#{type}\"/>", tag.to_s
      end
    end
  end

  scope '#checkbox' do
    test "returns a checkbox input" do
      tag = @builder.checkbox :admin
      assert_equal '<input id="person_admin" name="person[admin]" type="checkbox"/>', tag.to_s
    end

    test "returns a checkbox input with attributes" do
      tag = @builder.checkbox :admin, style: 'margin-top: 5px', data: { something: 'something' }
      assert_equal '<input style="margin-top: 5px" data-something="something" id="person_admin" name="person[admin]" type="checkbox"/>', tag.to_s
    end
  end

  scope '#datetime_local' do
    test "returns a datetime-local input" do
      tag = @builder.datetime_local :birth_date
      assert_equal '<input id="person_birth_date" name="person[birth_date]" type="datetime-local"/>', tag.to_s
    end

    test "returns a datetime-local input with attributes" do
      tag = @builder.datetime_local :birth_date, style: 'margin-top: 5px', data: { something: 'something' }
      assert_equal '<input style="margin-top: 5px" data-something="something" id="person_birth_date" name="person[birth_date]" type="datetime-local"/>', tag.to_s
    end
  end

  LazyForm::Builder::INPUT_TYPES.each do |type|
    scope type do
      test "returns a #{type} input" do
        tag = @builder.send type, :first_name
        assert_equal "<input id=\"person_first_name\" name=\"person[first_name]\" type=\"#{type}\"/>", tag.to_s
      end

      test "returns a #{type} input with attributes" do
        tag = @builder.send type, :first_name, style: 'margin-top: 5px', data: { something: 'something' }
        assert_equal "<input style=\"margin-top: 5px\" data-something=\"something\" id=\"person_first_name\" name=\"person[first_name]\" type=\"#{type}\"/>", tag.to_s
      end
    end
  end

  scope '#text' do
    test 'returns a text input with the passed value escaped' do
      tag = @builder.send :text, :first_name, value: '"><script>alert("hello world")</script>'
      assert_equal "<input value=\"&quot;&gt;&lt;script&gt;alert(&quot;hello world&quot;)&lt;/script&gt;\" id=\"person_first_name\" name=\"person[first_name]\" type=\"text\"/>", tag.to_s
    end

    test "returns a text input with the object's value escaped" do
      @person.first_name = '"><script>alert("hello world")</script>'
      tag = @builder.send :text, :first_name
      assert_equal "<input id=\"person_first_name\" name=\"person[first_name]\" type=\"text\" value=\"&quot;&gt;&lt;script&gt;alert(&quot;hello world&quot;)&lt;/script&gt;\"/>", tag.to_s
    end

    test 'returns a text input with the passed value as a string' do
      some_object = Struct.new(:value) do
        def to_s
          value.to_s
        end
      end.new(:some_value)

      tag = @builder.send :text, :first_name, value: some_object
      assert_equal "<input value=\"some_value\" id=\"person_first_name\" name=\"person[first_name]\" type=\"text\"/>", tag.to_s
    end
  end

  scope '#label' do
    test 'returns a label' do
      assert_equal '<label for="person_first_name">First name</label>', @builder.label(:first_name, 'First name').to_s
    end

    test 'returns a label with attributes' do
      assert_equal '<label style="color: blue" for="person_first_name">First name</label>', @builder.label(:first_name, 'First name', style: 'color: blue').to_s
    end

    test 'returns an escaped label' do
      assert_equal '<label style="color: blue" for="person_first_name">&lt;script&gt;alert(&quot;First name&quot;)&lt;/script&gt;</label>', @builder.label(:first_name, "<script>alert(\"First name\")</script>", style: 'color: blue').to_s
    end
  end

  scope '#select' do
    test 'returns a select' do
      assert_equal '<select id="person_gender" name="person[gender]"></select>', @builder.select(:gender).to_s
    end

    test 'returns a select with attributes' do
      assert_equal '<select style="color: blue" id="person_gender" name="person[gender]"></select>', @builder.select(:gender, {}, style: 'color: blue').to_s
    end

    test 'returns a select with options' do
      assert_equal '<select id="person_gender" name="person[gender]"><option value="m">Male</option><option value="f">Female</option></select>', @builder.select(:gender, { m: 'Male', f: 'Female' }).to_s
    end

    test 'returns a select with a selected option' do
      @person.gender = :m
      assert_equal '<select id="person_gender" name="person[gender]"><option value="m" selected="selected">Male</option><option value="f">Female</option></select>', @builder.select(:gender, { m: 'Male', f: 'Female' }).to_s
    end

    test 'returns a select with options escaped' do
      assert_equal '<select id="person_gender" name="person[gender]"><option value="m">&lt;script&gt;alert(&quot;male&quot;)&lt;/script&gt;</option><option value="f">Female</option></select>', @builder.select(:gender, { m: "<script>alert(\"male\")</script>", f: 'Female' }).to_s
    end
  end

  scope '#textarea' do
    test 'returns a textarea' do
      assert_equal '<textarea id="person_first_name" name="person[first_name]"></textarea>', @builder.textarea(:first_name).to_s
    end

    test "returns a textarea with the object's value" do
      @person.first_name = 'Patricio'
      assert_equal '<textarea id="person_first_name" name="person[first_name]">Patricio</textarea>', @builder.textarea(:first_name).to_s
    end

    test "returns a textarea with the object's value escaped" do
      @person.first_name = "</textarea><script>alert('hello world')</script><textarea>"
      assert_equal '<textarea id="person_first_name" name="person[first_name]">&lt;/textarea&gt;&lt;script&gt;alert(&#39;hello world&#39;)&lt;/script&gt;&lt;textarea&gt;</textarea>', @builder.textarea(:first_name).to_s
    end

    test 'returns a textarea with a default value' do
      assert_equal '<textarea id="person_first_name" name="person[first_name]">First name</textarea>', @builder.textarea(:first_name, 'First name').to_s
    end

    test 'returns a textarea with attributes' do
      assert_equal '<textarea style="color: blue" id="person_first_name" name="person[first_name]"></textarea>', @builder.textarea(:first_name, nil, style: 'color: blue').to_s
    end
  end

  scope '#as_id' do
    test "returns an attribute's html id" do
      assert_equal 'person_first_name', @builder.send(:as_id, :first_name)
    end
  end

  scope '#as_name' do
    test "returns an attribute's html name" do
      assert_equal 'person[first_name]', @builder.send(:as_name, :first_name)
    end
  end

  scope '#build_options' do
    test 'builds options for a select' do
      assert_equal '<option value="m">Male</option><option value="f">Female</option>', @builder.send(:build_options, :gender, { m: 'Male', f: 'Female' })
    end

    test 'builds options for a select with a selected option' do
      @person.gender = :m
      assert_equal '<option value="m" selected="selected">Male</option><option value="f">Female</option>', @builder.send(:build_options, :gender, { m: 'Male', f: 'Female' })
    end

    test 'supports optgroups' do
      assert_equal '<optgroup label="1"><option value="a">A</option></optgroup><optgroup label="2"><option value="b">B</option></optgroup>', @builder.send(:build_options, :gender, { 1 => { a: 'A' }, 2 => { b: 'B' } })
    end

    test 'supports optgroups with a selected option' do
      @person.gender = :a
      assert_equal '<optgroup label="1"><option value="a" selected="selected">A</option></optgroup><optgroup label="2"><option value="b">B</option></optgroup>', @builder.send(:build_options, :gender, { 1 => { a: 'A' }, 2 => { b: 'B' } })
    end
  end

  test 'supports fields without a corresponding attribute in the receiver object' do
    assert_equal '<input name="_method" value="PUT" id="person__method" type="hidden"/>', @builder.hidden('_method', name: '_method', value: 'PUT').to_s
  end
end
