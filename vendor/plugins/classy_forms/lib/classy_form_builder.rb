module ActiveSupport
  class OrderedHash < Array
    def each_key(&block)
      keys.each &block
    end
  end
end

class ClassyFormBuilder < ActionView::Helpers::FormBuilder
  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    div_options = classy_options(options, 'checkbox')
    classy_content(method, super, div_options)
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    div_options = classy_options(options, 'select')
    classy_content(method, super, div_options)
  end

  def country_select(method, priority_countries = nil, options = {}, html_options = {})
    div_options = classy_options(options, 'select')
    classy_content(method, super, div_options)
  end

  def datetime_select(method, options = {}, html_options = {})
    div_options = classy_options(options, 'select')
    classy_content(method, super, div_options)
  end

  def file_field(method, options = {})
    div_options = classy_options(options, 'file')
    classy_content(method, super, div_options)
  end

  def password_field(method, options = {})
    div_options = classy_options(options, 'password')
    classy_content(method, super, div_options)
  end

  def radio_button(method, tag_value, options = {})
    div_options = classy_options(options, 'radio')
    classy_content(method, super, div_options)
  end

  def select(method, choices, options = {}, html_options = {})
    div_options = classy_options(options, 'select')
    classy_content(method, super, div_options)
  end

  def submit(value = "Save changes", options = {})
    div_options = classy_options(options, 'submit')
    div_options[:label] = false unless div_options.include?(:label)
    classy_content(nil, super, div_options)
  end

  def text_area(method, options = {})
    div_options = classy_options(options, 'textarea')
    classy_content(method, super, div_options)
  end

  def text_field(method, options = {})
    div_options = classy_options(options, 'text')
    classy_content(method, super, div_options)
  end

  def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
    div_options = classy_options(options, 'select')
    classy_content(method, super, div_options)
  end

  def error_messages(options = {})
    options.symbolize_keys!
    if fields = Array(options.delete(:fields))
      # object = instance_variable_get "@#{@object_name}"
      errors = object.errors.instance_variable_get "@errors"
      ordered_errors = ActiveSupport::OrderedHash.new
      fields.each do |name|
        name = name.to_s
        ordered_errors[name] = errors.delete(name) if errors.include?(name)
      end
      errors.each do |attr,messages|
        ordered_errors[attr] = messages
      end
      object.errors.instance_variable_set "@errors", ordered_errors
    end
    super
  end

protected
  def classy_options(options, div_class)
    classes = div_class.split(' ')
    classes << 'input'
    classes << 'disabled' if options[:disabled]
    [:label,:required].inject({:class => classes.join(' ')}) do |h,o|
      h[o] = options.delete(o) if options.include?(o)
      h
    end
  end
  
  def classy_content(method, content, options)
    label = options.delete(:label)
    required = options.delete(:required)
    div_class = options[:class].split(' ')
    if label != false
      label ||= method.to_s.humanize
      required = '* required' if required == true
      label += " #{@template.content_tag 'span', required, :class => 'required'}" if required
      if div_class.include?('checkbox') || div_class.include?('radio')
        content += label(method, label)
      else
        content = label(method, label) + content
      end
    end
    @template.content_tag('div', content, options)
  end
end
