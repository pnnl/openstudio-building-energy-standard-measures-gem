# insert your copyright here

# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/

# start the measure
class GenerateUserDataCSVs < OpenStudio::Measure::ModelMeasure
  require 'openstudio-standards'
  
  def name
    return 'Generate User Data CSVs'
  end

  def description
    return "Measure to generate unpopulated CSV's for user data from a user model and save the CSVs to a given path. This measure generates one user data CSV based on selection or a full set of user data CSV's if unselected."
  end

  def modeler_description
    return ''
  end

  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new
	
	# Assign defaults
	user_data_path_default = File.dirname(__FILE__)
	
	# Make an argument for the path
    user_data_path_input = OpenStudio::Measure::OSArgument::makeStringArgument('user_data_path_input', false)
    user_data_path_input.setDisplayName('User Data Path:')
	user_data_path_input.setDefaultValue(user_data_path_default)
    args << user_data_path_input
	
	# Make argument for csv choices
	csv_chs = OpenStudio::StringVector.new
	csv_chs << 'userdata_airloop_hvac'
	csv_chs << 'userdata_airloop_hvac_doas'
	csv_chs << 'userdata_building'
	csv_chs << 'userdata_design_specification_outdoor_air'
	csv_chs << 'userdata_electric_equipment'
	csv_chs << 'userdata_exterior_lights'
	csv_chs << 'userdata_space'
	csv_chs << 'userdata_spacetype'
	csv_chs << 'userdata_thermal_zone'
	csv_choices = OpenStudio::Measure::OSArgument.makeChoiceArgument('csv_choices', csv_chs, false)
	args << csv_choices

    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)  # Do **NOT** remove this line

	args = arguments(model)
	
    # use the built-in error checking
    if !runner.validateUserArguments(args, user_arguments)
      return false
    end

	# assign user inputs to variables
	path = runner.getStringArgumentValue('user_data_path_input', user_arguments)
	optionalChoice = runner.getOptionalStringArgumentValue('csv_choices', user_arguments)
	
	if optionalChoice.is_initialized
		choice = optionalChoice.get
	else
		choice = nil
	end
	
	# check if path exists	
	if !Dir.exist?(path)
		runner.registerError("The input user data path #{path} is not a valid file path! Please input a valid file path.")
        return false
    end

	# build 90.1-PRM-2019 standard and run generate_userdata_to_csv
	std = Standard.build('90.1-PRM-2019')
	
	std.generate_userdata_to_csv(model, path, choice)
	
	if choice
		runner.registerInfo("#{choice} generated at #{path}")
	else
		runner.registerInfo("All user data files generated at #{path}")
	end
	
    return true
  end
end

# register the measure to be used by the application
GenerateUserDataCSVs.new.registerWithApplication
