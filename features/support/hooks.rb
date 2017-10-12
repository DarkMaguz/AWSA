#Cucumber provides a number of hooks which allow us to run blocks at various points in the Cucumber test cycle

Before do
	# Do something before each scenario.
end

Before do |scenario|
	# The +scenario+ argument is optional, but if you use it, you can get the title,
	# description, or name (title + description) of the scenario that is about to be
	# executed.
	#if scenario.name != "I want see the main page"
	#  clean_slate()
	#end
	if $address == "tjek.me"
		skip_this_scenario if $scenarios_to_skip_on_prod.include? scenario.name
	end
end

After do |scenario|
	# Do something after each scenario.
	# The +scenario+ argument is optional, but
	# if you use it, you can inspect status with
	# the #failed?, #passed? and #exception methods.
end

#Tagged hooks

Before('@initializeAWS') do
	
end

AfterStep('@Ex_tag1, @Ex_tag2') do |scenario|
	# This will only run after steps within scenarios tagged
	# with @Ex_tag1 AND @Ex_tag2.
end

Around('@Ex_tag1') do |scenario, block|
	# Will round around a scenario
end

AfterConfiguration do |config|
	# Will run after cucumber has been configured
end

# Will run just before a gracefull program termination
at_exit do
end
