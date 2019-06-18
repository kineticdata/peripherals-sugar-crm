module SugarCRM; module AttributeTypeCast

  protected
  
  # Returns the attribute type for a given attribute
  def attr_type_for(attribute)
    fields = self.class._module.fields
    field  = fields[attribute]
    raise UninitializedModule, "SugarCRM::Module #{self.class._module.name} was not initialized properly (fields.length == 0)" if fields.length == 0
    raise InvalidAttribute, "#{self.class}_module.fields does not contain an entry for #{attribute} (of type: #{attribute.class})\nValid fields: #{self.class._module.fields.keys.sort.join(", ")}" if field.nil?
    raise InvalidAttributeType, "#{self.class}._module.fields[#{attribute}] does not have a key for \'type\'" if field["type"].nil?
    field["type"].to_sym
  end

  # Attempts to typecast each attribute based on the module field type
  def typecast_attributes
    @attributes.each_pair do |name,value|
      # skip primary key columns
      next if name == "id"
      attr_type = attr_type_for(name)
      case attr_type
      when :bool
        @attributes[name] = (value == "1")
      when :datetime, :datetimecombo
        begin
          @attributes[name] = DateTime.parse(value)
        rescue
          @attributes[name] = value
        end
      when :int
        @attributes[name] = value.to_i
      end
    end
    @attributes
  end

end; end