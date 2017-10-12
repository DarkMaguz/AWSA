def waitForResponse(commandID)
	for i in 0..60 # 60*5 sec = 10 min.
		res = $ssm.list_commands(command_id: commandID)
		cmd = res['commands'].first
		raise "Wrong commandID: #{commandID}" if cmd['command_id'] != commandID
		status = cmd['status']
		case status
			when 'Pending', 'InProgress', 'Delayed'
				sleep 5
			when 'Success'
				puts "Command ID #{commandID}: #{status}"
				break
			when 'Cancelled', 'Failed', 'TimedOut', 'Cancelling'
				statusDetails = cmd['status_details']
				instanceIDs = cmd['instance_ids'].join(', ')
				commands = cmd['parameters']['commands'].join(', ')
				puts "Command ID #{commandID}: #{status} - #{statusDetails}\n\tInstance ID(s): #{instanceIDs}\n\tCommand(s): #{commands}"
				exit 1
		end
	end
end

def restartDockerContainer(instanceID, containerID)
	res = $ssm.send_command(
		document_name: 'AWS-RunShellScript',
		instance_ids: [instanceID],
		parameters: {
			commands: ["docker restart #{containerID.join(" ")}"],
			executionTimeout: ['600']
		},
		timeout_seconds: '300'
	)
	waitForResponse(res['command']['command_id'])
end

def getCommandOutput(instanceID, commandID)
	waitForResponse(commandID)
	res = $ssm.get_command_invocation({
		command_id: commandID,
		instance_id: instanceID
	})
	raise "Expected commandID \"#{commandID}\" to be Success. Got \"#{res['status']}\"" if res['status'] != "Success"
	return res['standard_output_content']
end

def isContainerIDValid(containerID)
	return !containerID.match(/\A[a-z0-9]*\z/).nil? && containerID.length == 12
end

def getContainerIDByAppName(instanceID, appName)
	res = $ssm.send_command(
		document_name: 'AWS-RunShellScript',
		instance_ids: [instanceID],
		parameters: {
			commands: ["docker ps --filter \"name=#{appName}\" -q"],
			executionTimeout: ['600']
		},
		timeout_seconds: '300'
	)
	commandID = res['command']['command_id']
	containerID = getCommandOutput(instanceID, commandID)
	containerID.chomp!
	puts "containerID: \"#{containerID}\""
	raise "Invalid container ID: \"#{containerID}\"\n\tCommand ID: \"#{commandID}\"\n\tInstance ID: \"#{instanceID}\"\n\tApp name: \"#{appName}\"" if !isContainerIDValid(containerID)
	return containerID
end