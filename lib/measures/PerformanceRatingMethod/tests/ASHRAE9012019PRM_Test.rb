# frozen_string_literal: true
require "openstudio"
require 'openstudio/measure/ShowRunnerOutput'
require 'minitest/autorun'
require_relative '../measure.rb'
require 'fileutils'
require 'openstudio-standards'

FILE_DIR = File.dirname(__FILE__)

class CreateBaselineBuildingTest < Minitest::Test

  def test__demo1_lighting_power_density__correct
    # define the model path
    proposed_model = 'geometry_demo_model.osm'
    demo_path = "#{FILE_DIR}/source/demo1"
    model_path = "#{demo_path}/#{proposed_model}"
    # create an instance of the measure
    measure = CreateBaselineBuilding.new
    # create an instance of a runner
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)
    # load model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    model = translator.loadModel(model_path)
    unless model.empty?
      model = model.get
      model.getElectricLoadCenterTransformers.each(&:remove)
    end

    # set arguments for the measure
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    args_hash = {}
    args_hash["building_type_wwr"] = "Office 5,000 to 50,000 sq ft"
    args_hash["building_type_swh"] = "Office"
    args_hash["building_type_hvac"] = "other nonresidential"
    args_hash["climate_zone"] = "ASHRAE 169-2013-4A"
    args_hash["exempt_from_rotations"] = "TRUE"
    args_hash["exempt_from_unmet_load_hours_check"] = "TRUE"
    arguments.each do |arg|
      temp_arg_var = arg.clone
      # if the argument name is in the arguments hash, set value
      if args_hash[arg.name]
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      # if the argument name is not in the arguments hash, use the original value
      argument_map[arg.name] = temp_arg_var
    end
    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)

    # load the generated baseline model
    model_baseline_path = "#{Dir.pwd}/../../generated_files/final.osm"
    model_baseline = translator.loadModel(model_baseline_path)
    unless model_baseline.empty?
      model_baseline = model_baseline.get
      model_baseline.getElectricLoadCenterTransformers.each(&:remove)
    end
    space_type_object_baseline = model_baseline.getSpaceTypeByName("Office WholeBuilding - Md Office 2")
    unless space_type_object_baseline.empty?
      space_baseline = space_type_object_baseline.get
    end
    lighting_power_density_object_baseline = space_baseline.lightingPowerPerFloorArea
    unless lighting_power_density_object_baseline.empty?
      lighting_power_density_baseline = lighting_power_density_object_baseline.get
    end
    # The expected value should be 11.8 W/m2, However, since the current OSSTD-PRM generates 0 W/m2,
    # I temporarily set the value to 0. Will change it when the issue is fixed.
    # assert_equal(11.8, lighting_power_density_baseline)
    assert_equal(11.8403014583807, lighting_power_density_baseline)
  end

  def test__demo2_use_user_data__correct
    # define the model path
    proposed_model = 'geometry_demo_model.osm'
    demo_path = "#{FILE_DIR}/source/demo2"
    model_path = "#{demo_path}/#{proposed_model}"
    # create an instance of the measure
    measure = CreateBaselineBuilding.new
    # create an instance of a runner
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    model = translator.loadModel(model_path)
    unless model.empty?
      model = model.get
      model.getElectricLoadCenterTransformers.each(&:remove)
    end

    # set arguments for the measure
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    args_hash = {}
    args_hash["building_type_wwr"] = "Retail (stand alone)"
    args_hash["building_type_swh"] = "Retail"
    args_hash["building_type_hvac"] = "retail"
    args_hash["climate_zone"] = "ASHRAE 169-2013-4A"
    # args_hash["exempt_from_rotations"] = "TRUE"
    args_hash["exempt_from_unmet_load_hours_check"] = "TRUE"
    args_hash["user_data"] = "TRUE"
    args_hash["user_data_path"] = "#{demo_path}/user_data"
    arguments.each do |arg|
      temp_arg_var = arg.clone
      # if the argument name is in the arguments hash, set value
      if args_hash[arg.name]
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      # if the argument name is not in the arguments hash, use the original value
      argument_map[arg.name] = temp_arg_var
    end
    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    # get infos
    infos = result.info
    # test user data selection
    user_info_flag = false
    infos.each do |info|
      if info.logMessage == "The user selects to use the user data."
        user_info_flag = true
      end
    end
    assert user_info_flag
    # test user data path
    user_info_path_flag = false
    infos.each do |info|
      if info.logMessage == "Use the user data files in the path #{demo_path}/user_data."
        user_info_path_flag = true
      end
    end
    assert user_info_path_flag
  end

  def test__demo3_HVAC__correct
    # define the model path
    proposed_model = 'hvac_demo_model.osm'
    demo_path = "#{FILE_DIR}/source/demo3"
    model_path = "#{demo_path}/#{proposed_model}"
    # create an instance of the measure
    measure = CreateBaselineBuilding.new
    # create an instance of a runner
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    model = translator.loadModel(model_path)
    unless model.empty?
      model = model.get
      model.getElectricLoadCenterTransformers.each(&:remove)
    end

    # set arguments for the measure
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    args_hash = {}
    args_hash["building_type_wwr"] = "Office 5,000 to 50,000 sq ft"
    args_hash["building_type_swh"] = "Office"
    args_hash["building_type_hvac"] = "other nonresidential"
    args_hash["climate_zone"] = "ASHRAE 169-2013-4A"
    # args_hash["exempt_from_rotations"] = "TRUE"
    args_hash["exempt_from_unmet_load_hours_check"] = "TRUE"
    args_hash["user_data"] = "TRUE"
    args_hash["user_data_path"] = "#{demo_path}/user_data"
    arguments.each do |arg|
      temp_arg_var = arg.clone
      # if the argument name is in the arguments hash, set value
      if args_hash[arg.name]
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      # if the argument name is not in the arguments hash, use the original value
      argument_map[arg.name] = temp_arg_var
    end
    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    # load the generated baseline model
    model_baseline_path = "#{Dir.pwd}/../../generated_files/final.osm"
    model_baseline = translator.loadModel(model_baseline_path)
    unless model_baseline.empty?
      model_baseline = model_baseline.get
      model_baseline.getElectricLoadCenterTransformers.each(&:remove)
    end
    # get the system name of the Core_top ZN
    zone_object = model_baseline.getThermalZoneByName("Core_top ZN")
    unless zone_object.empty?
      zone = zone_object.get
    end
    zone_equip = zone.equipment
    expected_system = "Core_top ZN PSZ-AC Diffuser"
    zone_equip_flag = false
    # test the equipment of Core_top ZN
    zone_equip.each do |equip|
      unless equip.name.empty?
        equip_name = equip.name.get
      end
      if equip_name == expected_system
        zone_equip_flag = true
      end
    end
    assert zone_equip_flag
  end
end
