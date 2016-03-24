wifi.setmode(wifi.STATION)
wifi.sta.config("Himesh","himesh1729")
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function() 
if wifi.sta.getip()== nil then print("WiFi not connected") 
else tmr.stop(1) print("Connection done, IP is "..wifi.sta.getip())
end end)
pin = 5
gpio.mode(pin, gpio.INPUT)

function sendData()   
    local check = gpio.read(pin)
        if check==1 then          
            conn1=net.createConnection(net.TCP, 0)
            conn1:on("connection",
                function(conn1,payload)
                print("Sending Data to PubNub")
                conn1:send('GET /publish/pub-c-55d4e23d-87db-483b-8aa8-c54adc73d825/sub-c-aab766da-bde9-11e5-a316-0619f8945a4f/0/SensorDatav2.1/0/{"eon":{"pot":'..adc.read(0)..'}} \r\n')
                conn1:send('Host: pubsub.pubnub.com//\r\n') 
                conn1:send('Accept: */*\r\n') 
                conn1:send('User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n')
                conn1:send('\r\n')
                end)
            conn1:on("receive",function(conn1,payload) print(payload) end)
            conn1:on("disconnection",function(conn1,payload) conn1:close() print ("disconnected")end)
            conn1:connect(80,'54.241.191.241') 
            gpio.write(1,gpio.HIGH)
            print(adc.read(0))
        else
            gpio.write(1,gpio.LOW)           
        end
end
tmr.alarm(2,2000,1,function() sendData() end)
