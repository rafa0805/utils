import datetime
import ssl
import OpenSSL

class Cert():

  # def __init__(self, url):
  #   self.url = url
  #   self.get_cert_data()

  def get_cert_data(self, url):
    cert = ssl.get_server_certificate((url, 443))
    x509 = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_PEM, cert)

    data = dict()

    data["start"] = x509.get_notBefore().decode('utf-8')
    data["end"] = x509.get_notAfter().decode('utf-8')

    components = x509.get_subject().get_components()


    for component in components:
      key = component[0].decode('utf-8')
      val = component[1].decode('utf-8')
      data[key] = val

    return data

  def evaluate(self, url):
    result = dict()

    res = self.get_cert_data(url)
    
    s_year = int(res["start"][0:4])
    s_month = int(res["start"][4:6])
    s_day = int(res["start"][6:8])
    e_year = int(res["end"][0:4])
    e_month = int(res["end"][4:6])
    e_day = int(res["end"][6:8])
    dt_now = datetime.datetime.now()
    dt_start = datetime.datetime(year=s_year, month=s_month, day=s_day)
    dt_end = datetime.datetime(year=e_year, month=e_month, day=e_day)

    # time delta
    td = dt_end - dt_now
    
    if (res['CN'] == url):
      result['domain'] = 'ok'
    else:
      result['domain'] = 'ng'
    
    if (td.days > 30):
      result['date'] = 'ok'
    elif (td.days > 0):
      result['date'] = 'alert'
    else:
      result['date'] = 'ng'

    return result