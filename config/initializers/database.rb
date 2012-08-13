if defined?(PhusionPassenger)
	PhusionPassenger.on_event(:starting_worker_process) do |forked|
		Mongoid.master.connection.connect_to_master if forked
	end
end