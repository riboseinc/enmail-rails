class LimerickMailer < ActionMailer::Base
  FROM = "edward.lear@example.test"
  TO = "world.poetry@example.test"
  SUBJECT = "There Was an Old Man With a Beard"

  default(
    from: FROM, to: TO, subject: SUBJECT, template_path: "limerick_mailer"
  )

  def beard
    mail
  end
end
