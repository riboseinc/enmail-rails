# (c) 2018 Ribose Inc.

require "active_support/concern"

# Inlude this mixin in ActionMailer::Base to let EnMail add the necessary
# headers for signing all messages with the specified +active_key+, when paired
# with MailInterceptor.
#
# Override +active_key+ to make it return an object that responds to +:email+.
# This object typically respresents an OpenPGP key used for signing.
#
# = Example usage:
#
# ActionMailer::Base.register_interceptor(MailInterceptor)
# ActionMailer::Base.include(SignedMailable)
#
module SignedMailable
  extend ActiveSupport::Concern

  module InstanceMethods
    class UnimplementedError < StandardError; end

    def active_key
      raise UnimplementedError
      # Thread.current[:pgp_active_key] ||= import_active_key
    end

    # As an extension, you can add the following headers as well:
    #
    # # https://www.ietf.org/archive/id/draft-josefsson-openpgp-mailnews-header-07.txt
    # 'X-PGP-Key': key_url,
    # OpenPGP: {
    #   url: key_url,
    #   id:  key_fingerprint,
    # }.map { |k, v| "#{k}=#{v};" }.join(" "),
    #
    def headers_with_signing(headers)
      # return headers unless Flipper.enabled?(:pgp_sign_emails) && active_key
      return headers unless active_key

      new_headers = headers.merge(
        enmail_options: {
          sign:    true,
          sign_as: active_key.email,
        },
      )

      new_headers
    end

    def mail(headers = {}, &block)
      super(headers_with_signing(headers), &block)
    end
  end

  included do
    def self.apply(base = self)
      # You can't use .prepend on ActionMailer::Base, for whatever reason.
      add_to = case base
               when ActionMailer::Base
                 :include
               else :prepend
               end

      unless base < InstanceMethods
        send add_to, InstanceMethods
      end
    end

    apply
  end
end
