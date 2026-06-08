const SchoolRegistry = require(script.Parent:FindFirstChild("SchoolRegistry"))

const School = {}

School.LoadMode = {
	Default = "Lazy",
	Lazy = "Lazy",
	Immediate = "Immediate",
}

function School.new(schoolContainer: Instance, loadMode: keyof<typeof(School.LoadMode)>?)
	loadMode = loadMode or School.LoadMode.Default
	
	const classes = {}
	
	for _, classScript in schoolContainer:QueryDescendants("ModuleScript") do
		if loadMode == School.LoadMode.Immediate then
			classes[classScript.Name] = require(classScript)
		elseif loadMode == School.LoadMode.Lazy then
			classes[classScript.Name] = classScript
		end
	end
	
	SchoolRegistry._schools[schoolContainer.Name] = classes
end

return School
