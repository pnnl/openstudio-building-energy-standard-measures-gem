# require_relative 'resources/config_loader'
# require 'openstudio-standards'
require 'yaml'
# Start the measure
class CreateBaselineBuilding < OpenStudio::Measure::ModelMeasure

  # Define the name of the Measure.
  def name
    return 'Create ASHRAE 90.1-2019 PRM Model'
  end

  # Human readable description
  def description
    return "Create the <strong>Baseline Building</strong> per ASHRAE Standard 90.1-2019 Performance Rating Method. User manual for this measure please see <a href='https://pnnl.github.io/BEM-for-PRM/'> https://pnnl.github.io/BEM-for-PRM </a>."
  end

  # Human readable description of modeling approach
  def modeler_description
    return ''
  end

  # Define the arguments that the user will input.
  def arguments(model)

    yaml_path = "#{File.dirname(__FILE__)}/../../files/config.yml"
    if File.exist?(yaml_path)
      config_data = YAML.load(File.read(yaml_path))
      building_type_wwr_default = config_data['building_type_wwr']
      building_type_swh_default = config_data['building_type_swh']
      building_type_hvac_default = config_data['building_type_hvac']
      climate_zone_default = config_data['climate_zone']
      exempt_from_rotations_default = config_data['exempt_from_rotations']
      exempt_from_unmet_load_hours_check_default = config_data['exempt_from_unmet_load_hours_check']
      user_data_default = config_data['user_data']
      user_data_path_default = config_data['user_data_path']
      evaluation_package_default = config_data['evaluation_package']
      evaluation_package_path_default = config_data['evaluation_package_path']
    else
      building_type_wwr_default = 'Grocery store'
      building_type_swh_default = 'Automotive facility'
      building_type_hvac_default = 'retail'
      climate_zone_default = 'ASHRAE 169-2013-1A'
      exempt_from_rotations_default = 'FALSE'
      exempt_from_unmet_load_hours_check_default = 'FALSE'
      user_data_default = 'FALSE'
      user_data_path_default = 'User_Data_Path'
      evaluation_package_default = 'FALSE'
      evaluation_package_path_default = 'Evaluation_Package_Path'
    end


    args = OpenStudio::Measure::OSArgumentVector.new

    # Make an argument for the building type
    building_type_wwr_chs = OpenStudio::StringVector.new
    building_type_wwr_chs << 'Grocery store'
    building_type_wwr_chs << 'Healthcare (outpatient)'
    building_type_wwr_chs << 'Hospital'
    building_type_wwr_chs << 'Hotel/motel <= 75 rooms'
    building_type_wwr_chs << 'Hotel/motel > 75 rooms'
    building_type_wwr_chs << 'Office <= 5,000 sq ft'
    building_type_wwr_chs << 'Office 5,000 to 50,000 sq ft'
    building_type_wwr_chs << 'Office > 50,000 sq ft'
    building_type_wwr_chs << 'Restaurant (quick service)'
    building_type_wwr_chs << 'Restaurant (full service)'
    building_type_wwr_chs << 'Retail (stand alone)'
    building_type_wwr_chs << 'Retail (strip mall)'
    building_type_wwr_chs << 'School (primary)'
    building_type_wwr_chs << 'School (secondary and university)'
    building_type_wwr_chs << 'Warehouse (nonrefrigerated)'
    building_type_wwr_chs << 'All others'
    building_type_wwr = OpenStudio::Measure::OSArgument.makeChoiceArgument('building_type_wwr', building_type_wwr_chs, true)
    building_type_wwr.setDisplayName('Default Building Area Type for Window To Wall Ratio:')
    building_type_wwr.setDescription('Select default building type for WWR assignment based on 90.1 Appendix G table G3.1.1-1.')
    building_type_wwr.setDefaultValue(building_type_wwr_default)
    args << building_type_wwr

    # Make an argument for the building type
    building_type_swh_chs = OpenStudio::StringVector.new
    building_type_swh_chs << 'Automotive facility'
    building_type_swh_chs << 'Performing arts theater'
    building_type_swh_chs << 'Convenience store'
    building_type_swh_chs << 'Police station'
    building_type_swh_chs << 'Convention center'
    building_type_swh_chs << 'Post office'
    building_type_swh_chs << 'Courthouse'
    building_type_swh_chs << 'Religious facility'
    building_type_swh_chs << 'Dining: Bar lounge/leisure'
    building_type_swh_chs << 'Retail'
    building_type_swh_chs << 'Dining: Cafeteria/fast food'
    building_type_swh_chs << 'School/university'
    building_type_swh_chs << 'Dining: Family'
    building_type_swh_chs << 'Sports arena'
    building_type_swh_chs << 'Dormitory'
    building_type_swh_chs << 'Town hall'
    building_type_swh_chs << 'Exercise center'
    building_type_swh_chs << 'Transportation'
    building_type_swh_chs << 'Fire station'
    building_type_swh_chs << 'Warehouse'
    building_type_swh_chs << 'Grocery store'
    building_type_swh_chs << 'Workshop'
    building_type_swh_chs << 'Gymnasium'
    building_type_swh_chs << 'Health-care clinic'
    building_type_swh_chs << 'Hospital and outpatient surgery center'
    building_type_swh_chs << 'Hotel'
    building_type_swh_chs << 'Library'
    building_type_swh_chs << 'Manufacturing facility'
    building_type_swh_chs << 'Motel'
    building_type_swh_chs << 'Motion picture theater'
    building_type_swh_chs << 'Multifamily'
    building_type_swh_chs << 'Museum'
    building_type_swh_chs << 'Office'
    building_type_swh_chs << 'Parking garage'
    building_type_swh_chs << 'Penitentiary'
    building_type_swh_chs << 'All others'
    building_type_swh = OpenStudio::Measure::OSArgument.makeChoiceArgument('building_type_swh', building_type_swh_chs, true)
    building_type_swh.setDisplayName('Default Building Area Type for Service Water Heating:')
    building_type_swh.setDescription('Select default building type for SWH system type assignment based on 90.1 Appendix G table G3.1.1-2.')
    building_type_swh.setDefaultValue(building_type_swh_default)
    args << building_type_swh

    # Make an argument for the HVAC building type
    building_type_hvac_chs = OpenStudio::StringVector.new
    building_type_hvac_chs << 'retail'
    building_type_hvac_chs << 'other nonresidential'
    building_type_hvac_chs << 'public assembly'
    building_type_hvac_chs << 'residential'
    building_type_hvac_chs << 'unconditioned'
    building_type_hvac_chs << 'heated-only storage'
    building_type_hvac_chs << 'hospital'
    building_type_hvac = OpenStudio::Measure::OSArgument.makeChoiceArgument('building_type_hvac', building_type_hvac_chs, true)
    building_type_hvac.setDisplayName('Default Building Type for HVAC:')
    building_type_hvac.setDescription('Select default building type for HVAC system type assignment based on 90.1 Appendix G table G3.1.1-3.')
    building_type_hvac.setDefaultValue(building_type_hvac_default)
    args << building_type_hvac

    # Make an argument for the climate zone
    climate_zone_chs = OpenStudio::StringVector.new
    climate_zone_chs << 'ASHRAE 169-2013-1A'
    climate_zone_chs << 'ASHRAE 169-2013-1B'
    climate_zone_chs << 'ASHRAE 169-2013-2A'
    climate_zone_chs << 'ASHRAE 169-2013-2B'
    climate_zone_chs << 'ASHRAE 169-2013-3A'
    climate_zone_chs << 'ASHRAE 169-2013-3B'
    climate_zone_chs << 'ASHRAE 169-2013-3C'
    climate_zone_chs << 'ASHRAE 169-2013-4A'
    climate_zone_chs << 'ASHRAE 169-2013-4B'
    climate_zone_chs << 'ASHRAE 169-2013-4C'
    climate_zone_chs << 'ASHRAE 169-2013-5A'
    climate_zone_chs << 'ASHRAE 169-2013-5B'
    climate_zone_chs << 'ASHRAE 169-2013-5C'
    climate_zone_chs << 'ASHRAE 169-2013-6A'
    climate_zone_chs << 'ASHRAE 169-2013-6B'
    climate_zone_chs << 'ASHRAE 169-2013-7A'
    climate_zone_chs << 'ASHRAE 169-2013-7B'
    climate_zone_chs << 'ASHRAE 169-2013-8A'
    climate_zone_chs << 'ASHRAE 169-2013-8B'
    climate_zone_chs << 'ASHRAE 169-2006-1A'
    climate_zone_chs << 'ASHRAE 169-2006-1B'
    climate_zone_chs << 'ASHRAE 169-2006-2A'
    climate_zone_chs << 'ASHRAE 169-2006-2B'
    climate_zone_chs << 'ASHRAE 169-2006-3A'
    climate_zone_chs << 'ASHRAE 169-2006-3B'
    climate_zone_chs << 'ASHRAE 169-2006-3C'
    climate_zone_chs << 'ASHRAE 169-2006-4A'
    climate_zone_chs << 'ASHRAE 169-2006-4B'
    climate_zone_chs << 'ASHRAE 169-2006-4C'
    climate_zone_chs << 'ASHRAE 169-2006-5A'
    climate_zone_chs << 'ASHRAE 169-2006-5B'
    climate_zone_chs << 'ASHRAE 169-2006-5C'
    climate_zone_chs << 'ASHRAE 169-2006-6A'
    climate_zone_chs << 'ASHRAE 169-2006-6B'
    climate_zone_chs << 'ASHRAE 169-2006-7A'
    climate_zone_chs << 'ASHRAE 169-2006-7B'
    climate_zone_chs << 'ASHRAE 169-2006-8A'
    climate_zone_chs << 'ASHRAE 169-2006-8B'
    climate_zone = OpenStudio::Measure::OSArgument.makeChoiceArgument('climate_zone', climate_zone_chs, true)
    climate_zone.setDisplayName('Climate Zone:')
    climate_zone.setDefaultValue(climate_zone_default)
    args << climate_zone

    # Make an argument for the rotation
    exempt_from_rotations_chs = OpenStudio::StringVector.new
    exempt_from_rotations_chs << 'TRUE'
    exempt_from_rotations_chs << 'FALSE'
    exempt_from_rotations = OpenStudio::Measure::OSArgument.makeChoiceArgument('exempt_from_rotations', exempt_from_rotations_chs, true)
    exempt_from_rotations.setDisplayName('Exempt From Rotations:')
    exempt_from_rotations.setDescription('Select TRUE if the building has rating authority approval that orientation is dictated by site considerations. Note: user data could override this selection.')
    exempt_from_rotations.setDefaultValue(exempt_from_rotations_default)
    args << exempt_from_rotations

    # Make an argument for the unmet load hours check
    exempt_from_unmet_load_hours_check_chs = OpenStudio::StringVector.new
    exempt_from_unmet_load_hours_check_chs << 'TRUE'
    exempt_from_unmet_load_hours_check_chs << 'FALSE'
    exempt_from_unmet_load_hours_check = OpenStudio::Measure::OSArgument.makeChoiceArgument('exempt_from_unmet_load_hours_check', exempt_from_unmet_load_hours_check_chs, true)
    exempt_from_unmet_load_hours_check.setDisplayName('Exempt From Unmet Load Hours Check:')
    exempt_from_unmet_load_hours_check.setDescription('Select TRUE if rating authority has approved allowing the models to exceed the specified values in Appendix G.')
    exempt_from_unmet_load_hours_check.setDefaultValue(exempt_from_unmet_load_hours_check_default)
    args << exempt_from_unmet_load_hours_check

    # Make an argument for the user data path input
    user_data_chs = OpenStudio::StringVector.new
    user_data_chs << 'TRUE'
    user_data_chs << 'FALSE'
    user_data = OpenStudio::Measure::OSArgument.makeChoiceArgument('user_data', user_data_chs, true)
    user_data.setDisplayName('Use User Data')
    user_data.setDescription('Project user compliance data.')
    user_data.setDefaultValue(user_data_default)
    args << user_data

    user_data_path = OpenStudio::Measure::OSArgument::makeStringArgument('user_data_path', false)
    user_data_path.setDisplayName('User Data Path:')
    user_data_path.setDescription('Required if select "TRUE" in "Use User Data". Please input a valid file path which contains the user data files.')
    user_data_path.setDefaultValue(user_data_path_default)
    args << user_data_path

    evaluation_package_chs = OpenStudio::StringVector.new
    evaluation_package_chs << 'TRUE'
    evaluation_package_chs << 'FALSE'
    evaluation_package = OpenStudio::Measure::OSArgument.makeChoiceArgument('evaluation_package', evaluation_package_chs, true)
    evaluation_package.setDisplayName('Use PRM evaluation package')
    evaluation_package.setDescription('Set to True the measure will search the local copy of OpenStudio-Standards to perform PRM')
    evaluation_package.setDefaultValue(evaluation_package_default)
    args << evaluation_package

    evaluation_package_path = OpenStudio::Measure::OSArgument::makeStringArgument('evaluation_package_path', false)
    evaluation_package_path.setDisplayName('Evaluation Package Path:')
    evaluation_package_path.setDescription('Required if select "TRUE" in "Use PRM evaluation package". Please input a valid file path which contains the evaluation package.')
    evaluation_package_path.setDefaultValue(evaluation_package_path_default)
    args << evaluation_package_path

    # Make an argument for enabling debug messages
    debug = OpenStudio::Measure::OSArgument.makeBoolArgument('debug', true)
    debug.setDisplayName('Generate logs for debug')
    debug.setDefaultValue(false)
    args << debug

    return args
  end

  # Define what happens when the measure is run.
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # Use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    # Assign the user inputs to variables that can be accessed across the measure
    building_type_hvac = runner.getStringArgumentValue('building_type_hvac', user_arguments)
    runner.registerInfo("Building HVAC Type is set to: #{building_type_hvac}")
    building_type_wwr = runner.getStringArgumentValue('building_type_wwr', user_arguments)
    runner.registerInfo("Building Window to Wall Ratio Type is set to: #{building_type_wwr}")
    building_type_swh = runner.getStringArgumentValue('building_type_swh', user_arguments)
    runner.registerInfo("Building Service Hot Water System Type is set to: #{building_type_swh}")
    climate_zone = runner.getStringArgumentValue('climate_zone', user_arguments)
    runner.registerInfo("Building Service Hot Water System Type is set to: #{building_type_swh}")
    # True if exempted, False otherwise.
    exempt_from_rotations = runner.getStringArgumentValue('exempt_from_rotations', user_arguments)
    runner.registerInfo("Project is exempted from rotations: #{exempt_from_rotations}")
    exempt_from_unmet_load_hours_check = runner.getStringArgumentValue('exempt_from_unmet_load_hours_check', user_arguments)
    runner.registerInfo("Project is exempted from unmet load hours: #{exempt_from_unmet_load_hours_check}")
    debug = runner.getBoolArgumentValue('debug', user_arguments)
    runner.registerInfo("Debug: #{debug}")
    user_data = runner.getStringArgumentValue('user_data', user_arguments)
    user_data_path = runner.getStringArgumentValue('user_data_path', user_arguments)
    evaluation_package = runner.getStringArgumentValue('evaluation_package', user_arguments)
    evaluation_package_path = runner.getStringArgumentValue('evaluation_package_path', user_arguments)

    data = {'building_type_wwr'=> building_type_wwr,
            'building_type_swh'=> building_type_swh,
            'building_type_hvac'=> building_type_hvac,
            'climate_zone'=> climate_zone,
            'exempt_from_rotations'=> exempt_from_rotations,
            'exempt_from_unmet_load_hours_check'=> exempt_from_unmet_load_hours_check,
            'user_data'=> user_data,
            'user_data_path'=> user_data_path,
            'evaluation_package'=> evaluation_package,
            'evaluation_package_path'=> evaluation_package_path}

    yaml_path = "#{File.dirname(__FILE__)}/../../files"
    yaml_file_name = 'config.yml'
    yaml_data = YAML.dump(data)
    unless File.exist?(yaml_path)
      Dir.mkdir(yaml_path)
    end
    File.open("#{yaml_path}/#{yaml_file_name}", 'w') do |f|
      f.write(yaml_data)
    end

    # Set run_all_orients variable based on exempt_from_rotations
    if exempt_from_rotations == 'TRUE'
      # if exempted, then there is no need to run all orientations.
      run_all_orients = false
    else
      run_all_orients = true
    end

    # Set unmet_load_hours_check variable based on exempt_from_unmet_load_hours_check
    if exempt_from_unmet_load_hours_check == 'TRUE'
      # if exempted, then there is no need to have unmet load hours check.
      unmet_load_hours_check = false
    else
      unmet_load_hours_check = true
    end


    # Set message log info.
    # @msg_log = OpenStudio::StringStreamLogSink.new
    # @msg_log.setLogLevel(OpenStudio::Info)
    @start_time = Time.new

    # Contact info for where to report issues
    contact = "While this Measure aims to be comprehensive and was tested against a suite of models of actual building designs, there are bound to be situations that it will not handle correctly.  It is your responsibility as a modeler to review the results of this Measure and adjust accordingly.  If you find issues (beyond those listed below), please <a href='https://github.com/NREL/openstudio-standards/issues'>report them here</a>.  Please include a detailed description, the proposed model, and references to the pertinent sections of 90.1, ASHRAE interpretations, or LEED interpretations."
    OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.Model', contact)

    # List of unsupported things
    us = []
    us << 'Lighting controls (occ/vac sensors) are assumed to already be present in proposed lighting schedules, and will not be added or removed'
    us << 'Exterior lighting in the baseline model is left as found in proposed'
    us << 'Optimal start of HVAC systems is not supported'
    us << 'Skylights are not added to model, but existing skylights are scaled per Appendix G skylight-to-roof areas'
    us << 'No fan power allowances for MERV filters or ducted supply/return present in proposed model HVAC'
    us << 'Laboratory-specific ventilation is not handled'
    us << 'Kitchen ventilation is not handled; exhaust fans left as found in proposed'
    us << 'Commercial refrigeration equipment is left as found in proposed'
    us << 'Transformers are not added to the baseline model'
    us << 'Zone humidity control present in the proposed model HVAC systems is not added to baseline HVAC'

    # Report out to users
    runner.registerInfo('*** Currently unsupported ***')
    # OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.Model', '*** Currently unsupported ***')
    us.each do |msg|
      runner.registerInfo(msg)
      # OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.Model', msg)
    end

    # List of known issues or limitations
    issues = []
    issues << 'Some control and efficiency determinations do not scale capacities/flow rates down to reflect zone multipliers'
    issues << 'Daylighting control illuminance setpoint does not vary based on space type'
    issues << 'Daylighting area calcs do not include windows in non-vertical walls'
    issues << 'Daylighting area calcs do not include skylights in non-horizontal roofs'

    # Report out to users
    runner.registerInfo('*** Known issues ***')
    # OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.Model', '*** Known issues ***')
    issues.each do |msg|
      runner.registerInfo(msg)
      # OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.Model', msg)
    end

    # Make a directory to save the resulting models for debugging
    build_dir = "#{Dir.pwd}/../../generated_files"
    # !!Validate path
    if !Dir.exist?(build_dir)
      Dir.mkdir(build_dir)
    end

    # Versions of OpenStudio greater than 2.4.0 use a modified version of
    # openstudio-standards with different method calls.

    if OpenStudio::VersionString.new(OpenStudio.openStudioVersion) < OpenStudio::VersionString.new('3.7.0')
      runner.registerError("PRM method can only run on OpenStudio 3.7.0 or higher.")
      #success = model.create_prm_stable_baseline_building(model, building_type_swh, climate_zone, building_type_hvac, building_type_wwr, building_type_swh, build_dir, run_all_orients, unmet_load_hours_check)
    else
      if evaluation_package == 'FALSE'
        runner.registerInfo("Use openstudio standard release version.")
        require 'openstudio-standards'
      else
        runner.registerInfo("Use openstudio standard local evaluation version.")
        if !Dir.exist?(evaluation_package_path)
          runner.registerError("The input evaluation package path #{evaluation_package_path} is not a valid file path! Please provide a valid file path.")
          return False
        else
          full_path = File.join(evaluation_package_path, '/lib/openstudio-standards.rb')
          if !File.exist?(full_path)
            runner.registerError("The evaluation package does not contain openstudio-standards.rb, failed to load the package")
          else
            runner.registerInfo("Importing the openstudio standards evaluation version from #{full_path}")
            require full_path
          end          
        end
      end

      # puts "Before Standard.build"
      std = Standard.build('90.1-PRM-2019')
      unless unmet_load_hours_check
        # In the case we are not running unmet load hours check, the measure needs to run
        # proposed model first.
        runner.registerInfo("Running proposed model...")
        # std.model_run_simulation_and_log_errors(model, run_dir = "#{build_dir}/PROP")
        if std.model_run_simulation_and_log_errors(model, run_dir = "#{build_dir}/PROP")
          runner.registerInfo("Successfully simulate the proposed model")
        else
          runner.registerError("Simulation on proposed model failed. Baseline generation is stopped.")
        end
      end
      model.getElectricLoadCenterTransformers.each(&:remove)


      # if do not use user data
      if user_data == "FALSE"
        runner.registerInfo("The user selects not to use the user data.")
      else
        runner.registerInfo("The user selects to use the user data.")

        # if user data path not valid
        if !Dir.exist?(user_data_path)
          runner.registerError("The input user data path #{user_data_path} is not a valid file path! Please provide a valid file path.")
          return false
          # if the user data path is valid
        else
          runner.registerInfo("Use the user data files in the path #{user_data_path}.")
          json_path = std.convert_userdata_csv_to_json(user_data_path, user_data_path)
          std.load_userdata_to_standards_database(json_path)
        end
      end

      # puts "After Standard.Build"
      runner.registerInfo("Generating Baseline Model...")
      std.model_create_prm_any_baseline_building(model, '', climate_zone, building_type_hvac, building_type_wwr, building_type_swh,
                                                 model_deep_copy=true,
                                                 create_proposed_model=true,
                                                 custom=false,
                                                 sizing_run_dir=build_dir,
                                                 run_all_orients=run_all_orients,
                                                 unmet_load_hours_check=unmet_load_hours_check,
                                                 debug=debug)
    end
    runner.registerInfo("Total Time = #{(Time.new - @start_time).round}sec.")
    log_msgs(true, runner)
    return true
    #return success
  end # end the run method

  # Get all the log messages and put into output
  # for users to see.
  def log_msgs(debug, runner)
    # Log the messages to file for easier review
    log_name = 'create_baseline.log'
    log_file_path = "#{Dir.pwd}/../#{log_name}"
    messages = log_messages_to_file(log_file_path, debug)
    runner.registerFinalCondition("Messages below saved to <a href='file:///#{log_file_path}'>#{log_name}</a>.")
    runner.registerInfo("Total Time = #{(Time.new - @start_time).round}sec.")
  end
end # end the measure

# this allows the measure to be use by the application
CreateBaselineBuilding.new.registerWithApplication
  