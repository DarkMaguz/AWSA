Given(/^I am authorized with AWS and have a opened the SSM client$/) do
	$ssm = Aws::SSM::Client.new(
		access_key_id: $accessKeyID,
		secret_access_key: $secretAccessKey,
		region: $region
	)
end

When(/^I ask for the container id of the application "([^"]*)" on the EC2 instance ID "([^"]*)"$/) do |appName, instanceID|
	res = $ssm.send_command(
		document_name: 'AWS-RunShellScript',
		instance_ids: [instanceID],
		parameters: {
			commands: ["docker ps --filter \"name=#{appName}\" -q"],
			executionTimeout: ['600']
		},
		timeout_seconds: '300'
	)
	$commandID = res['command']['command_id']
end

Then(/^I wait and see if I get a response from the EC2 instance ID "([^"]*)"$/) do |instanceID|
	containerID = getCommandOutput(instanceID, $commandID)
	containerID.chomp!
	puts "containerID: \"#{containerID}\""
	expect(isContainerIDValid(containerID)).to be true
end
