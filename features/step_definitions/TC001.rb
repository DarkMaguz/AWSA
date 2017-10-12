Given(/^I am authorized with AWS and have a opened the EC2 client$/) do
  $ec2 = Aws::EC2::Client.new(
  	access_key_id: $accessKeyID,
  	secret_access_key: $secretAccessKey,
  	region: $region
  )
end

When(/^I get a the EC2 instance with the instance ID "([^"]*)"$/) do |instanceID|
	$instance = $ec2.describe_instances({instance_ids: [instanceID]}).reservations.first.instances.first
end

Then(/^I should be able to see that the state is "([^"]*)"$/) do |state|
  expect($instance.state.name).to eql state
end

Then(/^I should be able to see that the type is "([^"]*)"$/) do |type|
	expect($instance.instance_type).to eql type
end
