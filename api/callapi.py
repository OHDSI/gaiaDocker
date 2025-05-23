from urllib.request import urlopen
from urllib.request import Request
from os import getenv
from json import loads

x_api_key_file = getenv('GAIA_X_API_KEY_FILE')
with open(x_api_key_file) as f:
	x_api_key = f.read().strip()

url = "http://gaia-osgeo:9876"
headers = {
	"x-api-key": x_api_key,
	"Content-Type": "application/octet-stream"
}
data = """
touch test.txt
ls -altrFh
rm tmp.*
rm test.txt
ls -altrFh
""".encode('utf-8')

req = Request(url, data=data, headers=headers, method='POST')
response = urlopen(req)
output = loads(response.read().strip().replace(b'\n',b'\\\\n').decode('utf-8'))
print(output['method'])
print(output['res'].replace('\\n','\n'))
