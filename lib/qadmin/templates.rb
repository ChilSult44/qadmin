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
    def namespace_name
      parts = self.class.to_s.split('::')
      if parts.size > 1
        return parts[0].downcase
      end
      return nil
    end
    
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
      tempname = [ namespace_name, controller_name ].compact.join('/')
      options[:section_name] ? options[:section_name] : (@section ? @section.name : tempname)
    end
    
    def template_exists?(template_name)
      begin
        self.view_paths.find_template(template_name, self.send(:default_template_format))
        true
      rescue ActionView::MissingTemplate
        false
      end
    end

  end
end