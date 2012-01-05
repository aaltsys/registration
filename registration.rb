#! /sbin/env ruby
require 'net/http'

version=11.02
registration_number=''
activation_code=''
email=''

def verify_reg(reg)
  begin
  unless reg.nil? and reg.length != 10
    id = reg[1..8].to_i
    check = "#{id}#{id % 7}".to_i
    check = "#{check % 11}#{check.to_s.rjust(9, '0')}"
    check === reg
  else
    return false
  end
  rescue
    return false
  end
end

while true
  registration_number = `dialog --backtitle "AAltSys Registration" --inputbox "Registration Number" 8 40`
  break if (!registration_number.nil? and verify_reg(registration_number))
  `dialog --backtitle "AAltSys Registration" --msgbox "Invalid Registration Number." 5 32`
end

while true
  activation_code = `dialog --backtitle "AAltSys Registration" --inputbox "Activation Number" 8 40`
  break if (!activation_code.nil? and !activation_code.empty?)
  `dialog --backtitle "AAltSys Registration" --msgbox "Invalid Activation Number." 5 30`
end

while true
  email = `dialog --backtitle "AAltSys Registration" --inputbox "Email Address" 8 40`
  break if email.include?("@")
  `dialog --backtitle "AAltSys Registration" --msgbox "Invalid Email Address." 5 26`
end

begin
  res = Net::HTTP.get_response(URI.parse("http://register.aaltsys.net/activate?registration_number=#{registration_number}&activation=#{activation_code}&email=#{email}&version=#{version}"))

  case res
  when Net::HTTPOK
    open("/tmp/install.zip", "wb") { |file|
      file.write(res.body)
    }
    system("mkdir -p /tmp/install/")
    system("unzip /tmp/install.zip -d /tmp/install/")
    system("cd /tmp/install/; /bin/bash /tmp/install/install.sh")
    system("rm -rf /tmp/install*")
    success = true
  else
    success = false
    error = res.message
  end
rescue
  success = false
  error ||= "Unknown error"
end

if success
  puts "Registration successful"
else
  puts "Error during registration: "
  puts error
end