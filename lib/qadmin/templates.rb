module Qadmin
  module Templates

    def self.included(klass)
      if klass.respond_to?(:helper_method) 
        klass.module_eval do
          helper_method :template_for_section, :partial_for_section
        end
      end
    end

    protected        
    def render_template_for_section(action = nil, options = {})
      action ||= action_name
      render({:template => template_for_section(action)}.merge(options))
    end

    def template_for_section(template_name, file_name = nil, options = {})
      file_name ||= template_name
      section_specific_template?(file_name, options) ? section_specific_template(template_name, options) : default_section_template(template_name, options)
    end

    def partial_for_section(partial_name, options = {})
      template_for_section(partial_name, "_#{partial_name}", options)
    end

    def section_specific_template?(template_name, options = {})
      template_exists?(section_specific_template(template_name, options))
    end

    def section_specific_template(template_name, options = {})
      "#{current_section_name(options)}/#{template_name}"
    end

    def default_section_template(template_name, options = {})
      "default/#{template_name}"
    end

    def current_section_name(options = {})
      options[:section_name] ? options[:section_name] : (@section ? @section.name : controller_name)
    end
    
    def template_exists?(template_path)
      logger.info "Checking for template: #{template_path} in #{self.view_paths.inspect}"
      ActionView::Template.new("#{template_path}.erb", self.view_paths)
    rescue ActionView::MissingTemplate => e
      logger.info "Template not found: #{template_path}, #{e}"
      false
    end

  end
end