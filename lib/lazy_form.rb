require 'inflecto'
require 'cgi/escape'

module LazyForm
  module Helper
    def outvar
      @_output
    end

    def form_for(object, url, attributes = {}, &block)
      attributes[:action] = url
      attributes[:method] ||= 'POST'

      attrs = attributes.collect { |k, v| "#{k}=\"#{v}\"" }
      attrs.unshift 'form'

      outvar << "<#{attrs.reject(&:empty?).join ' '}>\n"
      form_builder = Builder.new object
      block.call form_builder
      outvar << "</form>\n"
    end
  end

  class Tag
    attr_reader :name, :attributes, :block

    BOOLEAN_ATTRIBUTES = %i(autofocus checked disabled readonly required)

    def initialize(name, attributes = {}, &block)
      @name = name
      @attributes = attributes
      @block = block
    end

    def to_s
      attrs = build_attributes attributes.reject { |k, v| v.nil? }
      attrs.unshift name

      if block.nil?
        "<#{attrs.reject(&:empty?).join ' '}/>"
      else
        "<#{attrs.reject(&:empty?).join ' '}>#{block.call}</#{name}>"
      end
    end

    private

    def build_attributes(attributes = {})
      attributes.collect do |k, v|
        if v.is_a? Hash
          build_attributes Hash[v.collect { |ik, iv| [:"#{k}-#{ik}", iv] }]
        elsif BOOLEAN_ATTRIBUTES.include? k
          v ? k : ''
        else
          "#{k}=\"#{v}\""
        end
      end.flatten
    end
  end

  class Builder
    BUTTONS = %w(button image reset submit)

    INPUT_TYPES = [
      'color',
      'date',
      'datetime',
      'email',
      'file',
      'hidden',
      'month',
      'number',
      'password',
      'radio',
      'range',
      'search',
      'tel',
      'text',
      'time',
      'url',
      'week'
    ]

    attr_reader :object

    def initialize(object)
      @object = object
    end

    BUTTONS.each do |type|
      define_method type do |attributes = {}|
        attributes[:type] = type

        Tag.new 'input', attributes
      end
    end

    def checkbox(object_attribute, attributes = {})
      attributes[:id] ||= as_id object_attribute
      attributes[:name] ||= as_name object_attribute
      attributes[:type] = 'checkbox'
      begin
        attributes[:checked] = :checked if object.send object_attribute
      rescue NoMethodError
      end

      Tag.new 'input', attributes
    end

    def datetime_local(object_attribute, attributes = {})
      attributes[:id] ||= as_id object_attribute
      attributes[:name] ||= as_name object_attribute
      attributes[:type] = 'datetime-local'
      begin
        attributes[:value] ||= object.send object_attribute
      rescue NoMethodError
      end

      Tag.new 'input', attributes
    end

    INPUT_TYPES.each do |type|
      define_method type do |object_attribute, attributes = {}|
        attributes[:id] ||= as_id object_attribute
        attributes[:name] ||= as_name object_attribute
        attributes[:type] = type
        begin
          attributes[:value] ||= object.send object_attribute
        rescue NoMethodError
        end
        attributes[:value] = escape attributes[:value]

        Tag.new 'input', attributes
      end
    end

    def label(object_attribute, content = nil, attributes = {})
      attributes[:for] ||= as_id object_attribute

      Tag.new('label', attributes) { escape content }
    end

    def select(object_attribute, options = {}, attributes = {})
      attributes[:id] ||= as_id object_attribute
      attributes[:name] ||= as_name object_attribute

      Tag.new('select', attributes) { build_options object_attribute, options }
    end

    def textarea(object_attribute, content = nil, attributes = {})
      attributes[:id] ||= as_id object_attribute
      attributes[:name] ||= as_name object_attribute
      content ||= object.send object_attribute

      Tag.new('textarea', attributes) { escape content }
    end

    private

    def escape(text)
      CGI.escapeHTML text unless text.nil?
    end

    def as_id(attribute)
      Inflecto.underscore "#{object.class.name}_#{attribute}"
    end

    def as_name(attribute)
      "#{Inflecto.underscore object.class.name}[#{attribute}]"
    end

    def build_options(object_attribute, options = {})
      options.collect do |k, v|
        if v.is_a? Hash
          Tag.new('optgroup', label: k) { build_options object_attribute, v }
        else
          opts = { value: k }
          begin
            opts[:selected] = :selected if k == object.send(object_attribute)
          rescue NoMethodError
          end
          Tag.new('option', opts) { escape v }
        end
      end.join
    end
  end
end
