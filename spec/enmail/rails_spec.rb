# (c) 2018 Ribose Inc.
#

RSpec.describe EnMail::Rails do
  it "has a version number" do
    expect(EnMail::Rails::VERSION).not_to be nil
  end

  it "doesn't affect mailers in which protection is unset" do
    mail = send_email(LimerickMailer)
    common_expectations(mail)
  end

  def send_email(mailer, **args)
    mailer.with(args).beard.deliver_now
    ActionMailer::Base.deliveries.last
  end

  def common_expectations(mail)
    expect(mail.to).to contain_exactly(LimerickMailer::TO)
    expect(mail.from).to contain_exactly(LimerickMailer::FROM)
    expect(mail.subject).to eq(LimerickMailer::SUBJECT)
  end
end
