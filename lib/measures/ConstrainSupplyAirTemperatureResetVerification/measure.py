import openstudio
import logging
import datetime
import json

logger = logging.getLogger(__name__)


class ConstrainSupplyAirTemperatureResetVerification(openstudio.measure.ModelMeasure):
    def name(self):
        """
        Return the human readable name.
        Measure name should be the title case of the class name.
        """
        return "Supply Air Temperature Reset Verification"

    def description(self):
        """
        Human readable description
        """
        return "Verifies supply air temperature reset for a specified AirLoopHVAC."

    def modeler_description(self):
        """
        Human readable description of the modeling approach
        """
        return "Verifies supply air temperature reset for a specified AirLoopHVAC."

    def arguments(self, model):
        """
        Define arguments
        """
        args = openstudio.measure.OSArgumentVector()

        idf_path = openstudio.measure.OSArgument.makeStringArgument("idf_path", True)
        output_dataset_path = openstudio.measure.OSArgument.makeStringArgument(
            "output_dataset_path", True
        )
        output_dir = openstudio.measure.OSArgument.makeStringArgument(
            "output_dir", True
        )

        air_loop_name = openstudio.measure.OSArgument.makeStringArgument(
            "air_loop_name", True
        )

        design_zone_cooling_air_temp = openstudio.measure.OSArgument.makeDoubleArgument(
            "design_zone_cooling_air_temp", True
        )

        args.append(air_loop_name)
        args.append(design_zone_cooling_air_temp)
        args.append(idf_path)
        args.append(output_dataset_path)
        args.append(output_dir)
        # TODO: If the user doesn't provide a design_zone_cooling_air_temp, we can infer it from other modeling inputs

        return args

    def get_workflow(self, idf_file_path, output_dir):
        workflow = {
            "workflow_name": "Supply Air Temperature Reset Verification",
            "meta": {
                "author": "None",
                "date": datetime.datetime.now().strftime("%m/%d/%Y"),
                "version": "1.0",
                "description": "Supply Air Temperature Reset Verification",
            },
            "imports": ["numpy as np", "pandas as pd", "datetime", "glob"],
            "states": {
                "load_data": {
                    "Type": "MethodCall",
                    "MethodCall": "DataProcessing",
                    "Parameters": {
                        "data_path": idf_file_path,
                        "data_source": "EnergyPlus",
                    },
                    "Payloads": {"data_processing_obj": "$"},
                    "Start": "True",
                    "Next": "load_verification_case",
                }
            },
            "load_verification_case": {
                "Type": "MethodCall",
                "MethodCall": "VerificationCase",
                "Parameters": {"json_case_path": f"{output_dir}verification_case.json"},
                "Payloads": {
                    "verification_case_obj": "$",
                },
                "Next": "validate_case",
            },
            "validate_cases": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Value": "Payloads['verification_case_obj'].validate()",
                        "Equals": "True",
                        "Next": "setup_verification",
                    }
                ],
                "Default": "Report Error in Workflow",
            },
            "configure verification runner": {
                "Type": "MethodCall",
                "MethodCall": "Payloads['verification_obj'].configure",
                "Parameters": {
                    "output_path": f"{output_dir}",
                    "lib_items_path": "./schema/library.json",
                    "plot_option": "+x None",
                    "fig_size": "+x (6, 5)",
                    "num_threads": 1,
                    "preprocessed_data": "Payloads['data_processing_obj']",
                },
                "Payloads": {},
                "Next": "run verification",
            },
            "run verification": {
                "Type": "MethodCall",
                "MethodCall": "Payloads['verification_obj'].run",
                "Parameters": {},
                "Payloads": {"verification_return": "$"},
                "Next": "check results",
            },
            "setup verification": {
                "Type": "MethodCall",
                "MethodCall": "Verification",
                "Parameters": {"verifications": "Payloads['verification_case_obj']"},
                "Payloads": {"verification_obj": "$"},
                "Next": "configure verification runner",
            },
            "check results": {
                "Type": "MethodCall",
                "MethodCall": "glob.glob",
                "Parameters": [f"{output_dir}/*_md.json"],
                "Payloads": {"length_of_mdjson": "len($)"},
                "Next": "check number of result files",
            },
            "check number of result files": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Value": "Payloads['length_of_mdjson']",
                        "Equals": "1",
                        "Next": "reporting_object_instantiation",
                    }
                ],
                "Default": "Report Error in workflow",
            },
            "reporting_object_instantiation": {
                "Type": "MethodCall",
                "MethodCall": "Reporting",
                "Parameters": {
                    "verification_json": f"{output_dir}/*_md.json",
                    "result_md_name": "report_summary.md",
                    "report_format": "markdown",
                },
                "Payloads": {"reporting_obj": "$"},
                "Next": "report_cases",
            },
            "report_cases": {
                "Type": "MethodCall",
                "MethodCall": "Payloads['reporting_obj'].report_multiple_cases",
                "Parameters": {},
                "Payloads": {},
                "Next": "Success",
            },
            "Success": {
                "Type": "MethodCall",
                "MethodCall": "print",
                "Parameters": [
                    "Congratulations! the demo workflow is executed with expected results and no error!"
                ],
                "End": "True",
            },
            "Report Error in workflow": {
                "Type": "MethodCall",
                "MethodCall": "logging.error",
                "Parameters": ["Something is wrong in the workflow execution"],
                "End": "True",
            },
        }

        return workflow

    def get_verification_case(
        self,
        idf_file_path,
        output_dataset_path,
        supply_outlet_node,
        air_loop,
        design_zone_cooling_air_temp,
    ):
        supply_air_temperature_reset_verification_case = {
            "no": 1,
            "run_simulation": False,
            "expected_result": "pass",
            "simulation_IO": {"idf": idf_file_path, "output": output_dataset_path},
            "datapoints_source": {
                "idf_output_variables": {
                    "T_sa_set": {
                        "subject": supply_outlet_node.nameString(),
                        "variable": f"{air_loop.nameString()} Supply Outlet Temperature",
                        "frequency": "detailed",
                    }
                },
                "parameters": {"T_z_coo": design_zone_cooling_air_temp},
            },
            "verification_class": "SupplyAirTempReset",
        }

        return {"cases": [supply_air_temperature_reset_verification_case]}

    def run(
        self,
        model: openstudio.model.Model,
        runner: openstudio.measure.OSRunner,
        user_arguments: openstudio.measure.OSArgumentMap,
    ):
        """
        Define what happens when the measure is run
        """
        super().run(model, runner, user_arguments)

        if not (runner.validateUserArguments(self.arguments(model), user_arguments)):
            return False

        air_loop_name = runner.getStringArgumentValue("air_loop_name", user_arguments)
        design_zone_cooling_air_temp = runner.getDoubleArgumentValue(
            "design_zone_cooling_air_temp", user_arguments
        )
        idf_file_path = runner.getStringArgumentValue("idf_path", user_arguments)
        output_dataset_path = runner.getStringArgumentValue(
            "output_dataset_path", user_arguments
        )
        output_dir = runner.getStringArgumentValue("output_dir", user_arguments)

        runner.registerInitialCondition("Init")

        air_loop = model.getAirLoopHVACByName(air_loop_name)
        if not air_loop.get():
            runner.registerError(
                f"AirLoopHVAC '{air_loop_name}' not found in the model"
            )
            return False

        air_loop = air_loop.get()

        supply_outlet_node = air_loop.supplyOutletNode()

        output_variable = openstudio.model.OutputVariable(
            "System Node Temperature", model
        )
        output_variable.setName(f"{air_loop.name} Supply Outlet Temperature")
        output_variable.setKeyValue(f"{supply_outlet_node.name}")

        output_variables = model.getOutputVariables()

        # raise Exception(len(output_variables))
        # model.outputVariable("System Node Temperature", supply_outlet_node.handle)
        runner.registerInfo("Added OutputVariable for supply outlet node temperature")

        verification_cases = self.get_verification_case(
            idf_file_path,
            output_dataset_path,
            supply_outlet_node,
            air_loop,
            design_zone_cooling_air_temp,
        )
        with open(f"{output_dir}/supply_air_temperature_verification_case.json", "w") as f:
            json.dump(verification_cases, f, indent=2)

        workflow = self.get_workflow(idf_file_path, output_dir)
        with open(f"{output_dir}/constrain_workflow.json", "w") as f:
            json.dump(workflow, f, indent=2)

        runner.registerFinalCondition("Done")
        return True


ConstrainSupplyAirTemperatureResetVerification().registerWithApplication()
