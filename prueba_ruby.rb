
require "uri"
require "net/http"
require "json"

def request (address,api_key)
url = URI(address + api_key)
    
https = Net::HTTP.new(url.host, url.port);
https.use_ssl = true
    
request = Net::HTTP::Get.new(url)
https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_PEER
response = https.request(request)
JSON.parse response.read_body
end

uri = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key='
key = 'iLae6pjZaBYvAS8bzU6yPE5LKiL4XLabqhSKfPy4'
resp = request(uri,key)

def buid_web_page(data)
photos =[]
i=0
data["photos"].each do |img| 
photos.push(data["photos"][i]["img_src"])
i+=1
   
end
html=""
photos.each do |photo|
html+="<li><img src=\"#{photo}\"></li>\n"
    
end
page = "<head>
<title>imagenes_nasa</title>
</head>
<body><ul>#{html}</ul></body>
</html>"
File.write('output.html', page)
end

def photos_count(data)
photos =[]
i=0
data["photos"].each do |cam| 
photos.push(data["photos"][i]["camera"]["name"])
i+=1
end
grouped = photos.group_by{|x|x}
    
grouped.each do |k,v|
grouped[k]=v.count
end

end

buid_web_page(resp)

print photos_count(resp)

