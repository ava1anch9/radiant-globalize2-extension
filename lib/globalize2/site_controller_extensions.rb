module Globalize2
  module SiteControllerExtensions
    def self.included(base)
      base.class_eval do
        alias_method_chain :find_page, :globalize
        alias_method_chain :show_page, :homepage_redir
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
      globalized_url = '/' + I18n.locale.to_s + '/' + url
      find_page_without_globalize(globalized_url)
    end
  end
end