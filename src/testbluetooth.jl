module testbluetooth


using SimpleBLE
using JSON

function (@main)(ARGS)
	SERVICE_UUID					= "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
	CHARACTERISTIC_UUID_TX		= "beb5483e-36e1-4688-b7f5-ea07361b26a8"
	CHARACTERISTIC_UUID_RX		= "6d68ef76-79f6-4b8a-bf9d-05fc906b8290"
	CHARACTERISTIC_UUID_CONFIG	= "3c3d5e6f-7a8b-4c9d-9e0f-1a2b3c4d5e6f"


	connect_peripheral(peri->begin
		periid = peripheral_identifier(peri)
		return occursin("SiNW", periid)
	end) do peri
		rxchar = Characteristic(SERVICE_UUID, CHARACTERISTIC_UUID_RX)
		txchar = Characteristic(SERVICE_UUID, CHARACTERISTIC_UUID_TX)
		confchar = Characteristic(SERVICE_UUID, CHARACTERISTIC_UUID_CONFIG)

		write(peri, rxchar, JSON.json(Dict("cmd"=>"start")))
		write(peri, rxchar, JSON.json(Dict("cmd"=>"set_rate", "rate"=>0)))
		sleep(1)
		responce = read(peri, txchar) |> JSON.parse
		println(JSON.json(responce))
		write(peri, rxchar, JSON.json("cmd"=>"get_config"))
		responce = read(peri, txchar) |> JSON.parse
		println(JSON.json(responce))
		usersaidyes = Channel{Bool}()
		@async begin 
			readline()
			put!(usersaidyes, true)
		end
		while !isready(usersaidyes)
			responce = read(peri, txchar) |> JSON.parse
			println(JSON.json(responce))
		end
	end
end



end # module testbluetooth
