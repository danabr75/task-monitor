class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  COPYABLE_FIELDS_AND_ASSOCIATIONS_AND_ASSOCIATIONS = []

  # this apparently depended on our activerecord patch where we allowed 'accepted_nested_attribs' to match assocs on attribs other than IDs.
  def create_assignable_attributes options = {}
    result = {}

    associations_for_nested_attributes = {}
    self.class.nested_attributes_options.keys.each do |n|
      associations_for_nested_attributes[n.to_sym] = "#{n}_attributes".to_sym
    end

    if options[:include_id]
      result[:id] = self.id
    end

    errors = []

    self.class::COPYABLE_FIELDS_AND_ASSOCIATIONS_AND_ASSOCIATIONS.each do |field|
      if !options[:only].nil?
        if options[:only].include?(field.to_sym)
          # GOOD TO GO
        else
          next
        end
      end
      
      field = field.to_sym
      if self.class.column_names.include?(field.to_s) || field.to_s.ends_with?("_ids")
        result[field.to_sym] = self.send(field)
      elsif associations_for_nested_attributes.keys.include?(field)
        reflection = self.class.reflect_on_association(field)
        # "assoc_name" + "_attributes"
        attrib_nested_name = associations_for_nested_attributes[field]
        if reflection.macro == :has_many
          # partially supported atm. No way to 'destroy/remove' associations
          result[attrib_nested_name] = []
          self.send(field).each do |current_association|
            # ID should be fine, but it is not. Need to use 'update_on_fields' option on 'accepts_nested_attributes_for' hooks
            # result[attrib_nested_name] << current_association.create_assignable_attributes({include_id: true})
            result[attrib_nested_name] << current_association.create_assignable_attributes
          end
        else
          current_association = self.send(field)
          if current_association.present?
            result[attrib_nested_name] = current_association.create_assignable_attributes
          else
            result[attrib_nested_name] = {}
          end
        end
      else
        errors << "invalid clonable field value for class: #{self.class.name}, value: #{field}"
      end
    end

    if errors.any?
      raise "Internal Server Error. Errors found: #{errors.join('; ')}"
    end

    return result
  end


end
