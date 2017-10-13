Feature: TC001 Verify that all docker services are up and running
	As a DevOp, I would like to test if all my docker services are up and running on their respective EC2 instances

Scenario Outline: I want to test the status of my docker containers
	Given I am authorized with AWS and have a opened the SSM client
	And I am authorized with AWS and have a opened the EC2 client
	When I ask for the container id of the application <Application> on the EC2 instance ID <Instance ID>
	Then I wait and see if I get a response from the EC2 instance ID <Instance ID>

Examples:
	| Instance ID           | Application   |
	| "i-0921fc44e8cc30903" | "docker-loop" |
#	| "i-00c25c44844b72c46" | "docker-loop" |
