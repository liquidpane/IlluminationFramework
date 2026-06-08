const SchoolRegistry = {}

local lastSchoolName: string

const schools = {}
SchoolRegistry._schools = schools

const function startClass(className, class)
	const start = class.Start
	const concurrentStart = class.ConcurrentStart
	if not start and not concurrentStart then
		warn("Class " .. className .. " does not have a Start or a ConcurrentStart method!")
		return
	end

	if start then
		start(class)
	end

	if concurrentStart then
		task.spawn(concurrentStart, class)
	end
end

const function stopClass(className, class)
	const stop = class.Stop
	const concurrentStop = class.ConcurrentStop
	if not stop and not concurrentStop then
		warn("Class " .. className .. " does not have a Stop or a ConcurrentStop method!")
		return
	end

	if stop then
		stop(class)
	end

	if concurrentStop then
		task.spawn(concurrentStop, class)
	end
end

function SchoolRegistry.switchTo(schoolName: string)
	local classes = schools[schoolName]
	while not classes do
		print("Waiting for school: " .. schoolName)
		task.wait(0.1)
		classes = schools[schoolName]
	end
	
	if lastSchoolName then
		for className, class in schools[lastSchoolName] do
			stopClass(className, class)
		end
	end
	
	const newClasses = {}
	for className, classOrClassScript in classes do
		if typeof(classOrClassScript) == "Instance" then
			const class = require(classOrClassScript)
			newClasses[className] = class
			
			startClass(className, class)
		else
			startClass(className, classOrClassScript)
		end
	end
	
	for className, class in newClasses do
		classes[className] = class
	end
	
	lastSchoolName = schoolName
end

return SchoolRegistry
