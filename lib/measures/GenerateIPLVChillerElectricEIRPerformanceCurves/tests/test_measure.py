import pytest
import openstudio
import pathlib
import sys
from measure import GenerateIPLVChillerElectricEIRPerformanceCurves


class TestGenerateIPLVChillerElectricEIRPerformanceCurves:
    def test_number_of_arguments_and_argument_names(self):
        """
        Test that the arguments are what we expect
        """
        # create an instance of the measure
        measure = GenerateIPLVChillerElectricEIRPerformanceCurves()

        # make an empty model
        model = openstudio.model.Model()

        # get arguments and test that they are expecting a failure
        # because the model doesn't have a chiller
        arguments = measure.arguments(model)
        assert not (bool(arguments))

        # Create dummy chiller object
        chiller = openstudio.model.ChillerElectricEIR(model)
        chiller.setName("Test Chiller")

        # get arguments and test that they are what we are expecting
        arguments = measure.arguments(model)
        assert arguments.size() == 9
        assert arguments[0].name() == "chiller_name"
        assert arguments[1].name() == "chiller_compressor_type"
        assert arguments[2].name() == "chiller_speed_control"
        assert arguments[3].name() == "chiller_condenser_type"
        assert arguments[4].name() == "chiller_capacity_unit"
        assert arguments[5].name() == "chiller_capacity"
        assert arguments[6].name() == "chiller_efficiency_unit"
        assert arguments[7].name() == "chiller_full_load_efficiency"
        assert arguments[8].name() == "chiller_part_load_efficiency"

    def test_good_argument_values(self):
        """
        Test running the measure with appropriate arguments, and that the
        measure runs fine and with expected results
        """

        measure = GenerateIPLVChillerElectricEIRPerformanceCurves()

        osw = openstudio.openstudioutilitiesfiletypes.WorkflowJSON()
        runner = openstudio.measure.OSRunner(osw)

        model = openstudio.model.exampleModel()

        # Create dummy chiller object
        chiller = openstudio.model.ChillerElectricEIR(model)
        chiller.setName("Test Chiller")

        arguments = measure.arguments(model)
        argument_map = openstudio.measure.convertOSArgumentVectorToMap(arguments)

        args_dict = {}
        args_dict["chiller_name"] = "Test Chiller"
        args_dict["chiller_compressor_type"] = "centrifugal"
        args_dict["chiller_speed_control"] = "constant"
        args_dict["chiller_condenser_type"] = "water"
        args_dict["chiller_capacity_unit"] = "ton"
        args_dict["chiller_capacity"] = 150
        args_dict["chiller_efficiency_unit"] = "kW/ton"
        args_dict["chiller_full_load_efficiency"] = 0.6
        args_dict["chiller_part_load_efficiency"] = 0.5

        for arg in arguments:
            temp_arg_var = arg.clone()
            if arg.name() in args_dict:
                temp_arg_var.setValue(args_dict[arg.name()])
                # if arg.name() != "chiller_name":
                assert temp_arg_var.setValue(args_dict[arg.name()])
                argument_map[arg.name()] = temp_arg_var

        # Run measure
        measure.run(model, runner, argument_map)
        result = runner.result()
        assert result.value().valueName() == "Success"

        # Check that the curve has been assigned
        for chiller in model.getChillerElectricEIRs():
            if chiller.nameString() == "Test Chiller":
                assert (
                    chiller.electricInputToCoolingOutputRatioFunctionOfTemperature().nameString()
                    == "Test Chiller 0.6kW/ton FL 0.5kW/ton IPLV eir-f-t"
                )
                assert (
                    chiller.coolingCapacityFunctionOfTemperature().nameString()
                    == "Test Chiller 0.6kW/ton FL 0.5kW/ton IPLV cap-f-t"
                )
                assert (
                    chiller.electricInputToCoolingOutputRatioFunctionOfPLR().nameString()
                    == "Test Chiller 0.6kW/ton FL 0.5kW/ton IPLV eir-f-plr"
                )

        # Save model
        output_file_path = str(
            pathlib.Path(__file__).parent.absolute() / "output" / "test_output.osm"
        )
        model.save(output_file_path, True)


if __name__ == "__main__":
    pytest.main()
