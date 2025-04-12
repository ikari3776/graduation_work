class ContactMailer < ApplicationMailer
    def send_mail(contact)
      @contact = contact
      mail to:   ENV["EMAIL_USER"], subject: "【お問い合わせ】" + @contact.subject
    end
end
