module Globalize2
  module SiteControllerExtensions
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :find_page, :globalize
        alias_method_chain :show_page, :homepage_redir
        before_filter :set_locale
      end
    end


    module InstanceMethods
      def set_locale
        @locale = params[:locale] || Globalize2Extension.default_language
        Globalize2Extension.content_locale = I18n.locale = @locale.to_sym
      end
    end

    def show_page_with_homepage_redir
      url = params[:url]
      if Array === url
        url = url.join('/')
      else
        url = url.to_s
      end

      if url == '/'
        locale = params[:locale] || cookies[:locale] || session[:locale] || Globalize2Extension.ip_lookup(request.remote_ip)
        redirect_to CGI.unescape('/' + locale + '/') and return
      end

      show_page_without_homepage_redir
    end
    
    def find_page_with_globalize(url)
      url = '/' + I18n.locale.to_s + '/' + url if Globalize2Extension.locales.size > 1
      find_page_without_globalize(url)
    end
  end
end