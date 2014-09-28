# Just randomly found in testing that ActiveSupport thinks the singular of "slice" is "slouse"...
ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular /^\w+lice$/, '\0'
end