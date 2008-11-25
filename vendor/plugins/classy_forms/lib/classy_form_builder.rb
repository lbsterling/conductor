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

protected
  def classy_options(options, div_class)
    classes = div_class.split(' ')
    classes << 'input'
    classes << 'disabled' if options[:disabled]
    [:label].inject({:class => classes.join(' ')}) do |h,o|
      h[o] = options.delete(o) if options.include?(o)
      h
    end
  end
  
  def classy_content(method, content, options)
    label = options.delete(:label)
    div_class = options[:class].split(' ')
    if label != false
      if div_class.include?('checkbox') || div_class.include?('radio')
        content = content + label(method, label)
      else
        content = label(method, label) + content
      end
    end
    @template.content_tag('div', content, options)
  end
end
