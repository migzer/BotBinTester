require "proxy_fetcher"
require "rubygems"
require "selenium-webdriver"
require "mechanize"
require "uri"

def getCountry()
  country = gets.downcase;
  country = country.to_s.capitalize;
  country = country.split.map(&:capitalize).join(" ");
  return (country);
end

def getProxy(country)
  ip = "";
  port = "";
  new = [];
  i = 1;
  agent = Mechanize.new;
  c = country[0].capitalize + country[1].capitalize;
  page = agent.get("http://www.freeproxylists.net/?s=rs&pr=HTTPS&c=" + c);
  proxy = page.search(".Odd").text;
  proxy += page.search(".Even").text;
  proxy = proxy.split("IPDecode");
  while (i < proxy.length)
    ip = proxy[i].split("(")[1];
    ip = ip.split(")")[0].to_s;
    ip[0] = '';
    ip[ip.length - 1] = '';
    ip = URI.unescape(ip);
    ip = ip.split(">")[1].split("<")[0];
    port = proxy[i].split(")")[1].split("HTTPS")[0];
    new[i] = ip + ":" + port;
    i += 1;
  end
  return(new);
end

def setProxy(proxy)
  puts(proxy);
  profile = Selenium::WebDriver::Firefox::Profile.new;
  profile.proxy = Selenium::WebDriver::Proxy.new(
    :http => proxy,
    :ftp => proxy,
    :ssl => proxy
  )
  profile["browser.cache.disk.enable"] = false;
  profile["browser.cache.memory.enable"] = false;
  profile["browser.cache.offline.enable"] = false;
  profile["network.http.use-cache"] = false;
  driver = Selenium::WebDriver.for :firefox, :profile => profile;
  driver.manage.delete_all_cookies;
  return(driver);
end

def goSignUp(driver)
  driver.navigate.to "http://www.deezer.com/register";
  element = driver.find_element(:id => "register_form_mail_input");
  element.send_keys("tot");
  element = driver.find_element(:id => "register_form_password_input");
  element.send_keys("tot1");
  element = driver.find_element(:id => "register_form_username_input");
  element.send_keys("tot2");
  element = driver.find_element(:id => "register_form_gender_input");
  element.click().send_keys("keyDown");
  sleep(5);
  driver.quit;
end

def main()
  puts("[!] What location do you want to use ? [!]\n\n");
  country = getCountry();
  proxy = getProxy(country);
  driver = setProxy(proxy[1]);
  goSignUp(driver);
end

main();
