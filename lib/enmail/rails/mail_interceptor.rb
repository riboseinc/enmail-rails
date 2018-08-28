# (c) 2018 Ribose Inc.

class MailInterceptor
  class << self

    def adapter_class
      ::EnMail::Adapters::RNP
    end

    # = Example usage:
    #
    # module SignedMailable
    #   def mail(headers={}, &block)
    #     new_headers = headers.merge(
    #       enmail_options: {
    #         sign:    true,
    #         sign_as: "myemail@example.com",
    #       },
    #     )
    #     super(new_headers, &block)
    #   end
    # end
    #
    # ActionMailer::Base.register_interceptor(MailInterceptor)
    # ActionMailer::Base.include(SignedMailable)
    #
    def delivering_email(mail)
      super

      return unless mail[:enmail_options]

      options = eval mail[:enmail_options].value

      # encrypt and sign are off -> do not encrypt or sign
      if options[:encrypt]

        EnMail.protect(
          :sign_and_encrypt_encapsulated,
          mail,
          adapter: adapter_class,
        )

      elsif options[:sign] || options[:sign_as]

        signers = if options[:sign_as]
                    options.delete(:sign_as)
                  else
                    mail.from
                  end

        EnMail.protect(
          :sign,
          mail,
          adapter: adapter_class,
          signer: signers,
        )
      end
    rescue Exception
      raise $! if mail.raise_encryption_errors
    ensure
      mail[:enmail_options] = nil
    end
  end
end
