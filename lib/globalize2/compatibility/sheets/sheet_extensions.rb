module Globalize2
  module Compatibility
    module Sheets::SheetExtensions
      def self.included(base)
        base.class_eval do
          def self.root
            sheet_root ||= Page.find_by_slug('/').children.first(:conditions => {:class_name => self.to_s})
          end
        end
      end
    end
  end
end
