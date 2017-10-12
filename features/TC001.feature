Feature: TC001 Verify that all EC2 instanses are up and running
	As a DevOp, I would like to see if all my EC2 instanses are up and running

Scenario Outline: I want to test the status of my EC2 instances
	Given I am authorized with AWS and have a opened the EC2 client
	When I get the EC2 instance with the instance ID <Instance ID>
	Then I should be able to see that the state is <Instance state>
	And I should be able to see that the type is <Instance type>

Examples:
	| Instance ID           | Instance state | Instance type |
	| "i-0921fc44e8cc30903" | "running"      | "t2.micro"    |
	| "i-00c25c44844b72c46" | "running"      | "t2.micro"    |
