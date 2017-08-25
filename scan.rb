require "proxy_fetcher"
require "rubygems"
require "mechanize"
require "nokogiri"

def getProxyChosen(country, proxies)
  i = 0;
  while (i < proxies.length)
    proxies[i] = proxies[i].to_s;
    if proxies[i].include? country
      return (proxies[i]);
    else
      i += 1;
    end
  end
end

def getCountry()
  country = gets.downcase;
  country = country.to_s.capitalize;
  country = country.split.map(&:capitalize).join(" ");
  return (country);
end
    
def getProxyList()
  manager = ProxyFetcher::Manager.new;
  return (manager.proxies);
end

def getIpAddress(proxy)
  ip = proxy.split("addr=")[1];
  ip = ip.split(",")[0];
  ip[0] = "";
  ip[ip.length - 1] = "";
  return (ip);
end

def getPort(proxy)
  port = proxy.split("port=")[1];
  port = port.split(",")[0];
  return (port);
end

def setProxy(ip, port)
  agent = Mechanize.new;
  page = agent.get("http://www.netflix.com/signup/");
  puts page.body
  #agent.set_proxy ip, port.to_i;
end

def main()
  puts("What location do you want to use ?");
  country = getCountry();
  proxies = getProxyList();
  if (!(proxy = getProxyChosen(country, proxies)))
    puts("No proxy actually found..");
    exit;
  end
  ip = getIpAddress(proxy);
  port = getPort(proxy);
  puts("#{ip} => #{port}");
  setProxy(ip, port);
end

main();
