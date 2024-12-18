# insert your copyright here

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'minitest/autorun'
require_relative '../measure.rb'
require 'fileutils'

class CreateTypicalBuildingTest < Minitest::Test

  def test_climate_zone_failure_lookup
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Retail Stripmall'
    args_hash['climate_zone'] = 'Lookup From Model'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'PSZ-AC with gas coil'
    args_hash['user_hvac_mapping'] = 'FALSE'
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'


    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message reads invalid JSON
    assert(result.errors[0].logMessage.include? "Error when looking up climate zone from model")
  end


  def test_invalid_user_hvac_mapping_json_parser_error
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping_invalid_json.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message reads invalid JSON
    assert(result.errors[0].logMessage.include? "JSON parser failed to read file")

  end

  def test_invalid_user_hvac_mapping_json
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping_broken.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message reads invalid JSON
    assert(result.errors[0].logMessage.include? "Ensure JSON follows the format specified under")

  end

  def test_missing_zones_user_hvac_mapping_json
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAERetailStripmall.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message communicates the zones that don't exist in the OSM
    assert(result.errors[0].logMessage.include? "The following zones don't exist in ")

  end

  def test_no_zones_user_hvac_mapping_json
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAERetailStripmall.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping_no_zones.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message communicates that no zones exist in the OSM
    assert(result.errors[0].logMessage.include? "No zones specified under")

  end

  def test_duplicate_zones_user_hvac_mapping_json
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAERetailStripmall.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping_duplicate_zones.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message communicates that duplicate zones exist in the OSM
    assert(result.errors[0].logMessage.include? "Duplicate zones found")

  end

end
