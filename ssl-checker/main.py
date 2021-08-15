import os
import datetime
import json
import pprint

from cert import Cert 
from my_email import Smtp

dt_now = datetime.datetime.now()

# Configuration
base_dir = os.getcwd()
sites_file_path = base_dir + '/sites.json'
output_dir = base_dir + '\\output'
result_file_name = 'result_' + str(dt_now.year) + str(dt_now.month) + str(dt_now.day) + '.txt'

# Check before going
if (not os.path.exists(output_dir)):
  print('Error: 出力ディレクトリが存在しません。')
  exit()
if (not os.path.exists(sites_file_path)):
  print('Error: サイト一覧のjsonが存在しません。')
  exit()

f = open('./sites.json')
sites = json.load(f)

output_body = ''
warning_flag = 0

for site in sites:
  crt = Cert()
  res = crt.get_cert_data(site['url'])
  result = crt.evaluate(site['url'])

  output_body += "URL: ".rjust(16, ' ') + "dev.to" + "\n"
  output_body += "CName: ".rjust(16, ' ') + res["CN"] + "\n"
  output_body += "CA: ".rjust(16, ' ') + "hogehoge" + "\n"
  output_body += "Start: ".rjust(16, ' ') + res["start"] + "\n"
  output_body += "End: ".rjust(16, ' ') + res["end"] + "\n"
  output_body += "Valid date: ".rjust(16, ' ') + result["date"] + "\n"
  output_body += "Valid domain: ".rjust(16, ' ') + result["domain"] + "\n"
  output_body += "\n"

  if (result["date"] != "ok" or result["domain"] != "ok"):
    warning_flag += 1

# output_body = 'url'.ljust(40)+ 'domain'.ljust(40) + 'CA'.ljust(16)  + 'start'.ljust(16) + 'end'.ljust(16) + 'valid_date'.ljust(16) + 'valid_domain'.ljust(16) + '\n'

print(output_body)

if (warning_flag > 0):
  smtp = Smtp()
  msg = {
    'body': output_body,
    'subject': "[kosaka daily bot] " + str(warning_flag) + "件のサイトの証明書に問題が見つかりました",
    # 'subject': 'Result_' + str(dt_now.year) + '/' + str(dt_now.month) + '/' + str(dt_now.day),
    'to': 'theryk0805@yahoo.co.jp'
  }
  smtp.send(msg)
else:
  print("Everything is good!!")