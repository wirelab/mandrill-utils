module Papio
  class EmailSanitizer
    # Allowed characters are based on RFC3696 (http://tools.ietf.org/html/rfc3696)
    # Wikipedia also has a good concise section (http://en.wikipedia.org/wiki/Email_address#Syntax)
    NAME_REGEXP = /(?<name>[[:word:]]+((\s|-|'|!|#|\$|%|&|\+|\/|\^|\?)*([[:word:]]+))*)/

    # Sanitize a name according to RFC3696.
    def self.sanitize_name name
      match = name.to_s.match(NAME_REGEXP)
      match.nil? ? "" : match[:name].to_s
    end

    # Format a name and an email into the approved format.
    def self.sanitize_email name, email
      "#{sanitize_name(name)} <#{email}>"
    end

    # Format a email and an optional name.
    def self.sanitize email:, name:nil
      if name.nil?
        email
      else
        sanitize_email name, email
      end
    end
  end
end
