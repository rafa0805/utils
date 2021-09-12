import os
import smtplib
from email.mime.text import MIMEText
from email.utils import formatdate

class Smtp():
  
  def __init__(self):

    # Configuration
    self.smtp_hostname = os.getenv('SMTP_HOSTNAME')
    self.smtp_port = os.getenv('SMTP_PORT')
    self.smtp_email = os.getenv('SMTP_EMAIL')
    self.smtp_password = os.getenv('SMTP_PASSWORD')

    # Start SMTP
    try:
      res = self.login()
      # if (self.smtpobj.SMTPAuthenticationError) :
      #   raise ValueError

    except ValueError:
      print('Oops! Failed at SMTP connection...')

  def login(self):
    self.smtpobj = smtplib.SMTP(self.smtp_hostname, self.smtp_port)
    self.smtpobj.starttls()
    self.smtpobj.login(self.smtp_email, self.smtp_password)

  def set_body(self, text):
    self.msg = MIMEText(text)

  def set_subject(self, text):
    self.msg['Subject'] = text

  def set_to_mail(self, mail):
    self.msg['To'] = mail
    
  def set_from_mail(self, mail):
    self.msg['From'] = mail

  def set_date(self):
    self.msg['Date'] = formatdate()

  def prepare(self, values):
    self.set_body(values['body'])
    self.set_subject(values['subject'])
    if ('from' in values):
      self.set_from_mail(values['from'])
    else:
      self.set_from_mail(self.smtp_email)
    self.set_to_mail(values['to'])
    self.set_date()

  def send(self, values):

    self.prepare(values)
    self.smtpobj.send_message(self.msg)
    self.smtpobj.close()
