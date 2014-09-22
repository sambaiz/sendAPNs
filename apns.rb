require 'grocer'
#Connecting
pusher = Grocer.pusher(
    certificate: "secret/myapp.pem",      # required
    passphrase:  "",                       # optional
    gateway:     "gateway.push.apple.com", # optional
    port:        2195,                     # optional
    retries:     3                         # optional
) #pusherは使い回す

def make_notification(device_token, alert)
  Grocer::Notification.new(
      device_token:      device_token,
      alert:             alert,
      badge:             42,
      category:          "a category",         # optional; used for custom notification actions
      sound:             "siren.aiff",         # optional
      expiry:            Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
      identifier:        1234,                 # optional; must be an integer
      content_available: true                  # optional; any truthy value will set 'content-available' to 1
  )
end

n = 0
open("secret/devicetokens.txt") {|file|
  while l = file.gets
    n+=1
    pusher.push(make_notification(l, "Notification #{n}"))
  end
}