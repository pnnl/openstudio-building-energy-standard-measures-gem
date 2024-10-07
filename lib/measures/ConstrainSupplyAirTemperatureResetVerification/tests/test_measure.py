import pytest
import openstudio
from measure import ConstrainSupplyAirTemperatureResetVerification


class TestConstrainSupplyAirTemperatureResetVerification:
    def test_number_of_arguments_and_argument_names(self):
        """
        Test that the arguments are what we expect
        """
        # create an instance of the measure
        measure = ConstrainSupplyAirTemperatureResetVerification()

        # make an empty model
        model = openstudio.model.Model()

        # Create dummy air loop object
        air_loop = openstudio.model.AirLoopHVAC(model)
        air_loop.setName("Test Air Loop")

        # get arguments and test that they are what we are expecting
        arguments = measure.arguments(model)
        assert arguments.size() == 4
        assert arguments[0].name() == "air_loop_name"
        assert arguments[1].name() == "design_zone_cooling_air_temp"
        assert arguments[2].name() == "output_dataset_path"
        assert arguments[3].name() == "output_dir"

    def test_good_argument_values(self):
        """
        Test running the measure with appropriate arguments, and that the
        measure runs fine and with expected results
        """

        measure = ConstrainSupplyAirTemperatureResetVerification()

        osw = openstudio.openstudioutilitiesfiletypes.WorkflowJSON()
        runner = openstudio.measure.OSRunner(osw)

        # make an empty model
        model = openstudio.model.Model()

        # Create dummy air loop object
        air_loop = openstudio.model.AirLoopHVAC(model)
        air_loop.setName("Test Air Loop")

        # get arguments and test that they are what we are expecting
        arguments = measure.arguments(model)
        argument_map = openstudio.measure.convertOSArgumentVectorToMap(arguments)

        args_dict = {
            "air_loop_name": "Test Air Loop",
            "design_zone_cooling_air_temp": 24,
            "output_dataset_path": "./tests/input/test.csv",
            "output_dir": "./tests/output"
        }

        for arg in arguments:
            temp_arg_var = arg.clone()
            if arg.name() in args_dict:
                temp_arg_var.setValue(args_dict[arg.name()])
                assert temp_arg_var.setValue(args_dict[arg.name()])
                argument_map[arg.name()] = temp_arg_var

        measure.run(model, runner, argument_map)
        result = runner.result()
        assert result.value().valueName() == "Success"

        output_var_found = False
        expected_var_name = "Test Air Loop Supply Outlet Temperature"
        
        for output_variable in model.getOutputVariables():
            if output_variable.name().get() == expected_var_name and output_variable.keyValue() == "Node 2":
                output_var_found = True
                break

        assert output_var_found, f"Expected OutputVariable '{expected_var_name}' not found in the model"


if __name__ == "__main__":
    pytest.main()