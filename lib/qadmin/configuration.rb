module Qadmin
  class Configuration
    
    attr_accessor :controller_klass,
                  :model_name, 
                  :model_instance_name, 
                  :model_collection_name, 
                  :model_human_name,
                  :model_sti_type_column, 
                  :available_actions, 
                  :display_columns,
                  :column_headers,
                  :column_sort_overrides,
                  :multipart_forms,
                  :default_scope,
                  :ports,
                  :controls
    
    def initialize(options = {})
      extract_model_from_options(options)
      self.available_actions     = Qadmin::OptionSet.new([:index, :show, :new, :create, :edit, :update, :destroy], options[:available_actions] || {})
      self.display_columns       = Qadmin::OptionSet.new(model_column_names, options[:display_columns] || {})
      self.multipart_forms       = options[:multipart_forms] || false
      self.default_scope         = options[:default_scope]   || false
      self.ports                 = options[:ports]           || false
      self.controls              = options[:controls]        || []
      self.column_headers        = HashWithIndifferentAccess.new(options[:column_headers] || {})
      self.column_sort_overrides = HashWithIndifferentAccess.new(options[:column_sort_overrides] || {})
      self.model_sti_type_column = options[:model_sti_type_column] || nil
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
    
    def model_column_names
      model_klass.column_names
    rescue
      []
    end
    
  end
end