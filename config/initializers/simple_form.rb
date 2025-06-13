SimpleForm.setup do |config|

  config.wrappers :default, tag: 'div', class: 'form-control mb-2', error_class: '', valid_class: '' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: "label-text text-sm ps-2"
    b.use :input, class: "input input-bordered w-full"
    b.use :full_error, wrap_with: { tag: 'p', class: 'text-xs text-red-600' }
    b.use :hint, wrap_with: { tag: :label, class: "label label-text-alt" }
  end

  config.wrappers :vertical_radio, tag: 'div', class: 'form-control w-fit', error_class: '', item_wrapper_class: 'form-check', item_label_class: 'label gap-2 items-center justify-start' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'label-text'
    b.use :input, class: 'radio'
    b.use :full_error, wrap_with: { tag: 'p', class: 'text-xs text-red-600' }
    b.use :hint, wrap_with: { tag: :label, class: "label label-text-alt" }
  end

  config.default_wrapper = :default
  config.boolean_style = :nested
  config.button_class = nil
  config.error_notification_tag = :div
  config.error_notification_class = ''
  config.label_text = lambda { |label, required, explicit_label| "#{label}" }
  config.default_form_class = nil
  config.generate_additional_classes_for = []
  config.browser_validations = false
  config.wrapper_mappings = {
    string: :default,
    text: :default,
    radio_buttons: :vertical_radio,
  }
  config.boolean_label_class = 'checkbox'
end
