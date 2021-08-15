import smtplib
from email.mime.text import MIMEText
from email.utils import formatdate

sendAdress = 'theryk0805@gmail.com'
password = 'zbedevionjulboov'

subject = '件名'
bodytext = '本文'
fromAdress = sendAdress
toAdress = 'kosaka@bp-net.co.jp'

smtpobj = smtplib.SMTP('smtp.gmail.com', 587)
smtpobj.starttls()
smtpobj.login(sendAdress, password)

msg = MIMEText(bodytext)
msg['Subject'] = subject
msg['From'] = fromAdress
msg['To'] = toAdress
msg['Date'] = formatdate()

smtpobj.send_message(msg)
smtpobj.close()