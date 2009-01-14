module Qadmin
  class Configuration
    
    attr_accessor :controller_klass,
                  :model_name, 
                  :model_instance_name, 
                  :model_collection_name, 
                  :model_human_name, 
                  :available_actions, 
                  :display_columns
                  
    def initialize(options = {})
      extract_model_from_options(options)
      self.available_actions = Qadmin::OptionSet.new([:index, :show, :new, :create, :edit, :update, :destroy])
      self.display_columns   = Qadmin::OptionSet.new(model_klass.column_names)
    end
    
    def model_klass
      self.model_name.constantize
    end
    
    protected
    def extract_model_from_options(options = {})
      self.controller_klass      = options[:controller_klass]
      self.model_name            = options[:model_name] || controller_klass.to_s.demodulize.gsub(/Controller/,'').singularize
      self.model_instance_name   = options[:model_instance_name] || model_name.underscore
      self.model_collection_name = options[:model_collection_name] || model_instance_name.pluralize    
      self.model_human_name      = options[:model_human_name] || model_instance_name.humanize
    end
    
  end
end