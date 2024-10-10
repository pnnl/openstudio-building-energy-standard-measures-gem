
# start the measure
class CreateTypicalBuilding < OpenStudio::Measure::ModelMeasure

  require "openstudio-standards"
  require_relative "./resources/create_typical_resources.rb"

  # human readable name
  def name
    # Measure name should be the title case of the class name.
    return 'Create Typical Building'
  end

  # human readable description
  def description
    return 'The "Create Typical Building" OpenStudio measures empowers users to effortlessly generate ' \
            'OpenStudio and EnergyPlus models by making a few select choices. Users can input preferences ' \
            'such as the building energy code year (e.g., ASHRAE 90.1-2013), climate zone, and desired heating, '\
            'ventilation, and air conditioning (HVAC) system. Detailed documentation can be found at'\
            "<a href='https://github.com/pnnl/openstudio-building-energy-standard-measures-gem/tree/master/lib/measure_docs/CreateTypicalBuilding.md'> "\
            "https://github.com/pnnl/openstudio-building-energy-standard-measures-gem/tree/master/lib/measure_docs/CreateTypicalBuilding.md.</a>"
  end

  # human readable description of modeling approach
  def modeler_description
    return 'This OpenStudio Measure analyzes and generates a standard building model using either the '\
           'current geometry or a pre-established geometry file. It considers the selected building energy '\
           'standard, the HVAC system, and the specific climate zone to create a standardized building model '\
           'within OpenStudio. Please note that choosing any option other than "Existing Geometry" will ' \
           'replace the current OSM file. Selecting "JSON-specified" under "HVAC Type" allows users to map '\
           'HVAC Systems to specific zones in the OSM model. An example file can be found at under this '\
           'measure\'s tests at .\tests\source\hvac_mapping_path\hvac_zone_mapping.json'
  end

  # define the arguments that the user will input
  def arguments(model)

    args = OpenStudio::Measure::OSArgumentVector.new

    #--------- Assign enumerations for inputs from constants
    geom_types = OpenStudio::StringVector.new
    geom_list = CreateTypicalBldgConstants::GEOMETRY_SELECTIONS
    geom_list.each do |geom_selection|
      geom_types << geom_selection
    end

    climate_zones = OpenStudio::StringVector.new
    cz_list = CreateTypicalBldgConstants::CLIMATE_ZONES
    cz_list.each do |climate_zone|
      climate_zones << climate_zone
    end

    templates = OpenStudio::StringVector.new
    code_list = CreateTypicalBldgConstants::STANDARD_ENERGY_CODES
    code_list.each do |building_code|
      templates << building_code
    end

    hvac_types = OpenStudio::StringVector.new
    hvac_list = CreateTypicalBldgConstants::HVAC_TYPES
    hvac_list.each do |hvac_type|
      hvac_types << hvac_type
    end

    wall_constructions = OpenStudio::StringVector.new
    wall_type_list = CreateTypicalBldgConstants::WALL_CONSTRUCTIONS
    wall_type_list.each do |wall_construction|
      wall_constructions << wall_construction
    end

    true_false_os_vector = OpenStudio::StringVector.new
    true_false_os_vector << 'TRUE'
    true_false_os_vector << 'FALSE'

    #END--------- Assign enumerations for inputs

    # Add input elements
    geometry_file_choice = OpenStudio::Measure::OSArgument::makeChoiceArgument('geometry', geom_types, true)
    geometry_file_choice.setDisplayName('Geometry')
    geometry_file_choice.setDefaultValue('Existing Geometry')
    args << geometry_file_choice

    climate_zone_choice = OpenStudio::Measure::OSArgument::makeChoiceArgument('climate_zone', climate_zones, true)
    climate_zone_choice.setDisplayName('Climate Zone')
    climate_zone_choice.setDefaultValue('Lookup From Model')
    args << climate_zone_choice

    template_choice = OpenStudio::Measure::OSArgument::makeChoiceArgument('template', templates, true)
    template_choice.setDisplayName('Building Energy Code')
    template_choice.setDefaultValue('90.1-2004')
    args << template_choice

    hvac_type_choice = OpenStudio::Measure::OSArgument::makeChoiceArgument('hvac_type', hvac_types, true)
    hvac_type_choice.setDisplayName('HVAC Type')
    hvac_type_choice.setDefaultValue('Existing HVAC')
    args << hvac_type_choice

    # Path to HVAC-to-Zone mapping
    hvac_json_path = OpenStudio::Measure::OSArgument::makeStringArgument('user_hvac_json_path', false)
    hvac_json_path.setDisplayName('HVAC Zone Mapping JSON Path:')
    hvac_json_path.setDescription('Required if "JSON specified" is selected for "HVAC Type". Please'\
                                  ' enter a valid absolute path to a HVAC-to-Zone mapping JSON.')
    hvac_json_path.setDefaultValue('path/to/my/hvac_mapping.json')
    args << hvac_json_path

    add_constructions_choice = OpenStudio::Measure::OSArgument::makeChoiceArgument('add_constructions', true_false_os_vector, true)
    add_constructions_choice.setDisplayName('Add Constructions')
    add_constructions_choice.setDefaultValue('TRUE')
    args << add_constructions_choice

    wall_constructions_choice = OpenStudio::Measure::OSArgument::makeChoiceArgument('wall_construction', wall_constructions, true)
    wall_constructions_choice.setDisplayName('Wall Construction')
    wall_constructions_choice.setDefaultValue('Inferred')
    args << wall_constructions_choice

    add_space_types_choice = OpenStudio::Measure::OSArgument::makeChoiceArgument('add_space_type_loads', true_false_os_vector, true)
    add_space_types_choice.setDisplayName('Add Space Type Loads')
    add_space_types_choice.setDescription('Utlilize Space Type objects StandardSpaceType to inform modeling'\
                                          ' for equipment and lighting.')
    add_space_types_choice.setDefaultValue('TRUE')
    args << add_space_types_choice

    add_daylighting_choice = OpenStudio::Measure::OSArgument::makeChoiceArgument('add_daylighting', true_false_os_vector, true)
    add_daylighting_choice.setDisplayName('Add Daylighting')
    add_daylighting_choice.setDefaultValue('FALSE')
    args << add_daylighting_choice


    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)  # Do **NOT** remove this line

    runner.registerInfo('Starting create typical')

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    # assign the user inputs to variables
    geometry = runner.getStringArgumentValue('geometry', user_arguments)
    climate_zone = runner.getStringArgumentValue('climate_zone', user_arguments)
    template = runner.getStringArgumentValue('template', user_arguments)
    hvac_type = runner.getStringArgumentValue('hvac_type', user_arguments)
    user_hvac_json_path = runner.getStringArgumentValue('user_hvac_json_path', user_arguments)
    add_constructions = runner.getStringArgumentValue('add_constructions', user_arguments)
    wall_construction = runner.getStringArgumentValue('wall_construction', user_arguments)
    add_space_type_loads = runner.getStringArgumentValue('add_space_type_loads', user_arguments)
    add_daylighting = runner.getStringArgumentValue('add_daylighting', user_arguments)

    # Convert strings to booleans
    add_constructions = add_constructions == 'TRUE'
    add_space_type_loads = add_space_type_loads == 'TRUE'
    add_daylighting = add_daylighting == 'TRUE'
	
    # Convert CZ7 and CZ8 to values that OSSTD will understand (dropdown and OSSTD are different)
    climate_zone = 'ASHRAE 169-2013-7A' if climate_zone == 'ASHRAE 169-2013-7'
    climate_zone = 'ASHRAE 169-2013-8A' if climate_zone == 'ASHRAE 169-2013-8'

    # Load geometry file, if specified. NOTE, this will overwrite the existing OS model object
    if geometry != 'Existing Geometry'

      geometry_file = CreateTypicalBldgConstants::GEOMETRY_FILES_HASH[geometry]

      standard = Standard.new()
      #TODO This seems like a very sketchy way to call the private method load_geometry_osm
      new_model = standard.send(:load_geometry_osm,"geometry/#{geometry_file}")

      # Overwrite model with new geometry file
      model = overwrite_existing_model(model, new_model)
      runner.registerInfo("Model geometry overwritten with #{geometry_file}.")
    end

    runner.registerInfo('Model loaded, attempting Create Typical Building from model with parameters:')
    runner.registerInfo("Geometry Selection: #{geometry}")
    runner.registerInfo("Building Code: #{template}")
    runner.registerInfo("Climate Zone: #{climate_zone}")
    runner.registerInfo("HVAC System Type: #{hvac_type}")
    runner.registerInfo("Add Constructions?: #{add_constructions}")
    runner.registerInfo("Wall Construction: #{wall_construction}")
    runner.registerInfo("Add Space Type Loads?: #{add_space_type_loads}")
    runner.registerInfo("Add Daylighting?: #{add_daylighting}")

    # Toggle whether or not to add hvac
    add_hvac = hvac_type != 'Existing HVAC'

    # If using an HVAC-to-Zone mapping defined in a user's JSON
    if hvac_type == 'JSON specified'

      # Process JSON file and check for errors
      hvac_mapping_hash = process_hvac_to_zone_mapping_json(model, user_hvac_json_path, runner)

      # An empty hvac mapping indicates an error, return false
      return false if hvac_mapping_hash.empty?
    end

    @create = OpenstudioStandards::CreateTypical
    runner.registerInfo('Begin typical model generation...')

    # If "Lookup From Model" is used, check that a climate zone was found in model. If not, return Error
    if climate_zone == 'Lookup From Model'
      if OpenstudioStandards::VERSION.to_f < 0.6
        climate_zone = standard.model_standards_climate_zone(model)
      else
        climate_zone = OpenstudioStandards::Weather.model_get_climate_zone(model)
      end

      if climate_zone == '' or climate_zone.nil?
        error_message = 'Error when looking up climate zone from model. Ensure the model has a valid ClimateZone'\
        " or ClimateZones objects with climate zone information present. \n**NOTE**: Geometry files typically do not"\
        ' have this information'
        runner.registerError(error_message)
        return false
      end

    end

    # Fire off CreateTypical method
    @create.create_typical_building_from_model(model, template, climate_zone: climate_zone, add_hvac: add_hvac,
                                               add_constructions: add_constructions,
                                               wall_construction_type: wall_construction,
                                               add_space_type_loads: add_space_type_loads,
                                               add_daylighting_controls: add_daylighting,
                                               hvac_system_type: hvac_type,
                                               add_elevators: false,
                                               add_exterior_lights: false,
                                               add_exhaust: false,
                                               add_refrigeration: false,
                                               user_hvac_mapping: hvac_mapping_hash)

    # If no weather file assigned, assign it based on the climate zone
    if model.weatherFile.empty?

      # Assign design days and weather file to model
      runner.registerInfo("No weather file assigned to this model. Assigning default for climate zone: '#{climate_zone}'")
      standard = Standard.new()

      climate_zone = standard.model_get_building_properties(model)['climate_zone'] if climate_zone == 'Lookup From Model'
      OpenstudioStandards::Weather.model_set_building_location(model, climate_zone: climate_zone)

      # Get weather file name for reporting purposes
      location_name = model.weatherFile.get.site.get.name.to_s
      runner.registerInfo("Weather file and design days for #{climate_zone} assigned to '#{location_name}'")

    end

    # report final condition of model
    runner.registerFinalCondition('Typical building generation complete.')

    return true
  end

  def overwrite_existing_model(existing_model, new_model)

    # Overwrite model properly, per https://unmethours.com/question/32510/overwriting-a-osm-file-with-a-measure/
    handles = OpenStudio::UUIDVector.new
    existing_model.objects.each do |obj|
      handles << obj.handle
    end
    existing_model.removeObjects(handles)

    # Update references to new model
    existing_model.addObjects(new_model.toIdfFile.objects )

    return existing_model
  end

  # Checks a user's system to zone mapping for errors. Returns HVAC to zone mapping hash if defined correctly,
  # else returns empty hash
  def process_hvac_to_zone_mapping_json(model, user_hvac_json_path, runner)

    # if user data path not valid
    unless File.exists?(user_hvac_json_path)
      runner.registerError("The input user data path #{user_hvac_json_path} is not a valid file path! Please provide a valid file path.")
      return {}
    end

    runner.registerInfo("Reading in HVAC mapping information from #{user_hvac_json_path}.")

    # Read in user HVAC mapping JSON
    file = File.read(user_hvac_json_path)

    # Try to parse JSON
    begin
      hvac_mapping_hash = JSON.parse(file)
    rescue JSON::ParserError
      runner.registerError("Error in ''#{user_hvac_json_path}''. JSON parser failed to read file. Ensure "\
                           " #{user_hvac_json_path} is a valid JSON file")
      return {}
    end

    # Try to extract and aggregate thermal_zones from JSON
    begin
      zone_names_json = hvac_mapping_hash['systems'].flat_map { |system| system['thermal_zones'] }
    rescue NoMethodError
      runner.registerError("Error in ''#{user_hvac_json_path}''. Ensure JSON follows the format specified under"\
                           " 'systems'.[].'thermal_zones'")
      return {}
    end

    if zone_names_json.empty?
      runner.registerError("Error in the #{user_hvac_json_path}. No zones specified under 'systems'.[].'thermal_zones'")
      return {}
    end

    # Check for duplicate zones. First create a hash of every zones count
    count_occurrences = zone_names_json.each_with_object(Hash.new(0)) { |zone, counts| counts[zone] += 1 }

    # Select and return elements that have a count greater than 1 (i.e., duplicates)
    duplicates = count_occurrences.select { |zone, count| count > 1 }.keys

    unless duplicates.empty?
      runner.registerError("Error in the #{user_hvac_json_path}. Duplicate zones found: #{duplicates.join(', ')}")
      return {}
    end

    # Check the zones in the hash against those in the OS model
    zone_names_os_model = []
    model.getThermalZones.each do |zone|
      zone_names_os_model << zone.name.to_s
    end

    # Check for zones in JSON that don't exist in OS model using array subtraction
    nonexistant_zones = zone_names_json - zone_names_os_model

    unless nonexistant_zones.empty?
      runner.registerError("Error in the #{user_hvac_json_path}. The following zones don't exist in building "\
                           "'#{model.building.get.name.to_s}': #{nonexistant_zones.join(', ')}. NOTE, zone names are "\
                           'case sensitive.')
      return {}
    end

    runner.registerInfo("No issues found in: #{user_hvac_json_path}.")
    return hvac_mapping_hash

  end


end

# register the measure to be used by the application
CreateTypicalBuilding.new.registerWithApplication
