## Overview

The "Create Typical Building" OpenStudio measures empowers users to effortlessly generate OpenStudio and EnergyPlus models by making a few select choices. Users can input preferences such as the building energy code year (e.g., ASHRAE 90.1-2013), climate zone, and desired heating, ventilation, and air conditioning (HVAC) system. This OpenStudio Measure analyzes and generates a standard building model using either the current geometry or a pre-established geometry file. It considers the selected building energy standard, the HVAC system, and the specific climate zone to create a standardized building model within OpenStudio.

While similar to the articulation gem's [Create Typical Building From Model](https://github.com/NREL/openstudio-model-articulation-gem/tree/develop/lib/measures/create_typical_building_from_model), this measure has additional functionality for starting with predefined geometry files, increased flexibility in allowing for custom mapping of HVAC systems to zones,  and utilizes the [OpenStudio Standards gem](https://github.com/NREL/openstudio-standards).

 Please note that choosing any option other than "Existing Geometry" will replace the current OSM file. Selecting "JSON-specified" under "HVAC Type" allows users to map HVAC Systems to specific zones in the OSM model. An example file can be found [here](https://github.com/pnnl/openstudio-building-energy-standard-measures-gem/blob/master/lib/measures/CreateTypicalBuilding/tests/source/hvac_mapping_path/hvac_zone_mapping_psz_ac_ptac.json)


## Table of Contents

- [Overview](#overview)
- [Measure Philosophy](#measure-philosophy)
   * [Pre-requisites](#pre-requisites)
- [Input Parameters](#input-parameters)
   * [Exposed Parameters](#exposed-parameters)
      + [**HVAC Type**: ](#hvac-type)
      + [**Add Constructions:** ](#add-constructions)
      + [**Wall Construction:** ](#wall-construction)
      + [**Add Space Type Loads:** ](#add-space-type-loads)
      + [**Add Daylighting:** ](#add-daylighting)
   * [Inferred Values](#inferred-values)
      + [**Internal Mass:** ](#internal-mass)
      + [**Exterior Lights:** ](#exterior-lights)
      + [**Service Hot Water:** ](#service-hot-water)
      + [**Elevators:** ](#elevators)
      + [**Thermostats:** ](#thermostats)
      + [**Refrigeration:** ](#refrigeration)
      + [**Heating Fuel:** ](#heating-fuel)
      + [**Daylight Savings Time:** ](#daylight-savings-time)
      + [**Unmet Hour Tolerance:** ](#unmet-hour-tolerance)
      + [**Remove Objects:** ](#remove-objects)


## Measure Philosophy

The intent behind the **Create Typical Building** measure is to never add anything that is not strictly specified by the user. This guiding principal motivated overwriting many of the default values in the [create_typical_building_from_model](https://github.com/NREL/openstudio-standards/blob/master/lib/openstudio-standards/create_typical/create_typical.rb#L54) function. A few things should be understood as pre-requisites for this function:

### Pre-requisites

 - Space Types must exist in the OpenStudio model and utilize the [standardSpaceType](https://s3.amazonaws.com/openstudio-sdk-documentation/cpp/OpenStudio-3.7.0-doc/model/html/classopenstudio_1_1model_1_1_space_type.html#aa99ce07877d6b7af86b1ad86a8d2a50a) and [standardBuildingType](https://s3.amazonaws.com/openstudio-sdk-documentation/cpp/OpenStudio-2.8.0-doc/model/html/classopenstudio_1_1model_1_1_building.html#a478edd27f9553ec8768406c6af5d1282) fields. A full list of building and space types can be found in the *Lookups* tab [here](https://docs.google.com/spreadsheets/d/1k4aRy1CuNXQaeqKPZYxK0R3GB8X1XhP3P9ztaCBTn5M/edit?gid=1330294062#gid=1330294062). Examples of valid options for building type include: 
    - Courthouse
    - FullServiceRestaurant
    - HighriseApartment
    - Hospital
    - LargeHotel
    - LargeOffice
    - Library
    - MediumOffice
    - MidriseApartment
    - Office
    - Outpatient
    - Police station
    - Post office
    - PrimarySchool
    - QuickServiceRestaurant
    - Religious
    - Retail
    - SecondarySchool
    - SmallHotel
    - SmallOffice
    - StripMall
    - SuperMarket
    - Warehouse
 - Geometry must be either defined in the OSM or ingested from a set of standardized OSM geometry models in measure's *Geometry* dropdown.
 - If users want to ingest the climate zone from the OpenStudio model, the OSM must have weather information

## Input Parameters
As of 6/26/2024, this OpenStudio measure utilizes the [create_typical_building_from_model](https://github.com/NREL/openstudio-standards/blob/master/lib/openstudio-standards/create_typical/create_typical.rb#L54) and uses the following input parameters.  First, we'll cover options which of the *create_typical_building_from_model* parameters are exposed to the user.

### Exposed Parameters

 #### **Building Energy Code:** 
 This sets the building energy code based on ASHRAE 90.1 Standards. This parameter is used a great deal to set default values across other parameters. At present, the building energy code affects the outcomes of the following building parameters:  
 
 - [Add Constructions](#add-constructions)
 - [Wall Construction](#wall-construction)
 - [Add Space Type Loads](#add-space-type-loads)
 - [Add Daylighting](#add-daylighting)
 - [Internal Mass](#internal-mass)
 - [Thermostats](#thermostats)

*Characteristics*:
 
 - create_typical_building_from_model parameter: **template**
 - Default: n/a-- must be selected
 - Options:
      - 'DOE Ref 1980-2004'
      - 'DOE Ref Pre-1980'                          
      - '90.1-2004'
      - '90.1-2007'
      - '90.1-2010'
      - '90.1-2013' 
      - '90.1-2016' 
      - '90.1-2019'


 #### **Climate Zone:** 
The ASHRAE climate zone from which to base inference. NOTE-- 'Lookup From Model' searches the OSM for a weather location and draws the climate zone from it. If the 'Lookup From Model' option is selected, the OSM must have a weather location. 

- create_typical_building_from_model parameter: **climate_zone**
- Default: 'Lookup From Model',
- Options:
    - 'Lookup From Model'
    - 'ASHRAE 169-2013-1A'
    - 'ASHRAE 169-2013-2A'
    - 'ASHRAE 169-2013-2B'
    - 'ASHRAE 169-2013-3B'
    - 'ASHRAE 169-2013-3C'
    - 'ASHRAE 169-2013-4A'
    - 'ASHRAE 169-2013-4C'
    - 'ASHRAE 169-2013-5A'
    - 'ASHRAE 169-2013-5B'
    - 'ASHRAE 169-2013-6B'
    - 'ASHRAE 169-2013-7'
    - 'ASHRAE 169-2013-8'
    - 'ASHRAE 169-2013-3A'
    - 'ASHRAE 169-2013-4B'
    - 'ASHRAE 169-2013-6A'

#### **HVAC Type**: 
The HVAC system applied to the building model. NOTE-- the 'JSON specified' option allows users to define their own mapping of HVAC types to thermal zones, allowing for more options when setting their building's HVAC configuration. An example JSON file showing the format can be found [here](https://github.com/pnnl/openstudio-building-energy-standard-measures-gem/blob/master/lib/measures/CreateTypicalBuilding/tests/source/hvac_mapping_path/hvac_zone_mapping_psz_ac_ptac.json). The path for the parameter is defined in the 'HVAC Zone Mapping JSON Path' parameter.

- create_typical_building_from_model parameter: **hvac_system_type**
- Default: 'Existing HVAC'
- Options:
  - 'Existing HVAC',
  - 'JSON specified',
  - 'Baseboard central air source heat pump',
  - 'Baseboard district hot water',
  - 'Baseboard electric',
  - 'Baseboard gas boiler',
  - 'Direct evap coolers with baseboard central air source heat pump',
  - 'Direct evap coolers with baseboard district hot water',
  - 'Direct evap coolers with baseboard electric',
  - 'Direct evap coolers with baseboard gas boiler',
  - 'Direct evap coolers with forced air furnace',
  - 'Direct evap coolers with gas unit heaters',
  - 'Direct evap coolers with no heat',
  - 'DOAS with fan coil air-cooled chiller with baseboard electric',
  - 'DOAS with fan coil air-cooled chiller with boiler',
  - 'DOAS with fan coil air-cooled chiller with central air source heat pump',
  - 'DOAS with fan coil air-cooled chiller with district hot water',
  - 'DOAS with fan coil air-cooled chiller with gas unit heaters',
  - 'DOAS with fan coil air-cooled chiller with no heat',
  - 'DOAS with fan coil chiller with baseboard electric',
  - 'DOAS with fan coil chiller with boiler',
  - 'DOAS with fan coil chiller with central air source heat pump',
  - 'DOAS with fan coil chiller with district hot water',
  - 'DOAS with fan coil chiller with gas unit heaters',
  - 'DOAS with fan coil chiller with no heat',
  - 'DOAS with fan coil district chilled water with baseboard electric',
  - 'DOAS with fan coil district chilled water with boiler',
  - 'DOAS with fan coil district chilled water with central air source heat pump',
  - 'DOAS with fan coil district chilled water with district hot water',
  - 'DOAS with fan coil district chilled water with gas unit heaters',
  - 'DOAS with fan coil district chilled water with no heat',
  - 'DOAS with VRF',
  - 'DOAS with water source heat pumps cooling tower with boiler',
  - 'DOAS with water source heat pumps district chilled water with district hot water',
  - 'DOAS with water source heat pumps fluid cooler with boiler',
  - 'DOAS with water source heat pumps with ground source heat pump',
  - 'Fan coil air-cooled chiller with boiler',
  - 'Fan coil air-cooled chiller with baseboard electric',
  - 'Fan coil air-cooled chiller with central air source heat pump',
  - 'Fan coil air-cooled chiller with district hot water',
  - 'Fan coil air-cooled chiller with gas unit heaters',
  - 'Fan coil air-cooled chiller with no heat',
  - 'Fan coil chiller with baseboard electric',
  - 'Fan coil chiller with boiler',
  - 'Fan coil chiller with central air source heat pump',
  - 'Fan coil chiller with district hot water',
  - 'Fan coil chiller with gas unit heaters',
  - 'Fan coil chiller with no heat',
  - 'Fan coil district chilled water with baseboard electric',
  - 'Fan coil district chilled water with boiler',
  - 'Fan coil district chilled water with central air source heat pump',
  - 'Fan coil district chilled water with district hot water',
  - 'Fan coil district chilled water with gas unit heaters',
  - 'Fan coil district chilled water with no heat',
  - 'Forced air furnace',
  - 'Gas unit heaters',
  - 'Packaged VAV Air Loop with Boiler', 
  - 'PSZ-AC district chilled water with baseboard district hot water',
  - 'PSZ-AC district chilled water with baseboard electric',
  - 'PSZ-AC district chilled water with baseboard gas boiler',
  - 'PSZ-AC district chilled water with central air source heat pump',
  - 'PSZ-AC district chilled water with district hot water',
  - 'PSZ-AC district chilled water with electric coil',
  - 'PSZ-AC district chilled water with gas boiler',
  - 'PSZ-AC district chilled water with gas coil',
  - 'PSZ-AC district chilled water with gas unit heaters',
  - 'PSZ-AC district chilled water with no heat',
  - 'PSZ-AC with baseboard district hot water',
  - 'PSZ-AC with baseboard electric',
  - 'PSZ-AC with baseboard gas boiler',
  - 'PSZ-AC with central air source heat pump',
  - 'PSZ-AC with district hot water',
  - 'PSZ-AC with electric coil',
  - 'PSZ-AC with gas boiler',
  - 'PSZ-AC with gas coil',
  - 'PSZ-AC with gas unit heaters',
  - 'PSZ-AC with no heat',
  - 'PSZ-HP',
  - 'PTAC with baseboard district hot water',
  - 'PTAC with baseboard electric',
  - 'PTAC with baseboard gas boiler',
  - 'PTAC with central air source heat pump',
  - 'PTAC with district hot water',
  - 'PTAC with electric coil',
  - 'PTAC with gas boiler',
  - 'PTAC with gas coil',
  - 'PTAC with gas unit heaters',
  - 'PTAC with no heat',
  - 'PTHP',
  - 'PVAV with central air source heat pump reheat',
  - 'PVAV with district hot water reheat',
  - 'PVAV with gas boiler reheat',
  - 'PVAV with gas heat with electric reheat',
  - 'PVAV with PFP boxes',
  - 'Residential AC with baseboard central air source heat pump',
  - 'Residential AC with baseboard district hot water',
  - 'Residential AC with baseboard electric',
  - 'Residential AC with baseboard gas boiler',
  - 'Residential AC with no heat',
  - 'Residential AC with residential forced air furnace',
  - 'Residential forced air furnace',
  - 'Residential heat pump',
  - 'Residential heat pump with no cooling',
  - 'VAV air-cooled chiller with central air source heat pump reheat',
  - 'VAV air-cooled chiller with district hot water reheat',
  - 'VAV air-cooled chiller with gas boiler reheat',
  - 'VAV air-cooled chiller with gas coil reheat',
  - 'VAV air-cooled chiller with no reheat with baseboard electric',
  - 'VAV air-cooled chiller with no reheat with gas unit heaters',
  - 'VAV air-cooled chiller with no reheat with zone heat pump',
  - 'VAV air-cooled chiller with PFP boxes',
  - 'VAV chiller with central air source heat pump reheat',
  - 'VAV chiller with district hot water reheat',
  - 'VAV chiller with gas boiler reheat',
  - 'VAV chiller with gas coil reheat',
  - 'VAV chiller with no reheat with baseboard electric',
  - 'VAV chiller with no reheat with gas unit heaters',
  - 'VAV chiller with no reheat with zone heat pump',
  - 'VAV chiller with PFP boxes',
  - 'VAV district chilled water with central air source heat pump reheat',
  - 'VAV district chilled water with district hot water reheat',
  - 'VAV district chilled water with gas boiler reheat',
  - 'VAV district chilled water with gas coil reheat',
  - 'VAV district chilled water with no reheat with baseboard electric',
  - 'VAV district chilled water with no reheat with gas unit heaters',
  - 'VAV district chilled water with no reheat with zone heat pump',
  - 'VAV district chilled water with PFP boxes',
  - 'VRF',
  - 'Water source heat pumps cooling tower with boiler',
  - 'Water source heat pumps district chilled water with district hot water',
  - 'Water source heat pumps fluid cooler with boiler',
  - 'Water source heat pumps with ground source heat pump',
  - 'Window AC with baseboard central air source heat pump',
  - 'Window AC with baseboard district hot water',
  - 'Window AC with baseboard electric',
  - 'Window AC with baseboard gas boiler',
  - 'Window AC with forced air furnace',
  - 'Window AC with no heat',
  - 'Window AC with unit heaters'
      
#### **Add Constructions:** 
Defines whether or not to set construction type based on building energy code, climate zone, and standard space type.
- create_typical_building_from_model parameter: **add_constructions**
- Default: 'true',
- Options:
     - true/false
	     
#### **Wall Construction:** 
Determines the wall construction applied across the model. Can be inferred from building energy code, climate zone, and standard space type.
 - create_typical_building_from_model parameter: **wall_construction_type**
 - Default: 'Inferred',
 - Options:
    -   'Mass'
	-  	 'Metal Building'
	-   'SteelFramed"
	-   'WoodFramed'
	-   'Inferred'

#### **Add Space Type Loads:** 
Sets the People, Lights, Electric Equipment, and Infiltration for the building based on building energy code, standards space type, and standards building type.
 - create_typical_building_from_model parameter: **add_space_type_loads**
 - Default: 'true',
 - Options:
      - true/false

#### **Add Daylighting:** 
Adds daylighting in building based on the building energy code.
- create_typical_building_from_model parameter: **add_daylighting_controls**
- Default: 'false',
- Options:
     - true/false



### Inferred Values

The  [create_typical_building_from_model](https://github.com/NREL/openstudio-standards/blob/master/lib/openstudio-standards/create_typical/create_typical.rb#L54) function infers a great deal of parameters for users. This OpenStudio measure departs from its default values for a handful of parameters to better align with the philosophy of not adding anything not specified by the user as mentioned above. Below are the relevant parameters that present inferred values that are outside of the control of the user. 

#### **Internal Mass:** 
Adds internal mass objects and constructions to spaces based on space type. Details surrounding these interior furnishes can be found [here](https://github.com/NREL/openstudio-standards/blob/335d1bf81441c5e54e3234fd2fbd6daaa514aa4c/lib/openstudio-standards/prototypes/common/objects/Prototype.Model.rb#L553-L569):
 - create_typical_building_from_model parameter: **add_internal_mass**
 - Default: 'true'

#### **Exterior Lights:** 
This OpenStudio measure does not add exterior lights as of now:
 - create_typical_building_from_model parameter: **add_exterior_lights**
 - Default: 'false'

#### **Service Hot Water:** 
This OpenStudio measure does not add service hot water as of now, but is likely a future specification. Developers made the decision to pull this often critical piece of energy use due to the complexity of *create_typical_building_from_model*'s inference. It was decided that too much was inferred via this measure and that the team would like to expand on the customizability first:
 - create_typical_building_from_model parameter: **add_swh**
 - Default: 'false'

#### **Elevators:** 
This OpenStudio measure does not add elevators:
 - create_typical_building_from_model parameter: **add_elevators**
 - Default: 'false'

#### **Thermostats:** 
This OpenStudio measure adds thermostat objects with a dual setpoint with heating and cooling setpoint schedules based on building energy code, standards space type, and standards building type:
 - create_typical_building_from_model parameter: **add_thermostat**
 - Default: 'true'

#### **Refrigeration:** 
This OpenStudio measure does not add refrigeration as of now:
 - create_typical_building_from_model parameter: **add_refrigeration**
 - Default: 'false'

#### **Heating Fuel:** 
HVAC system types default to utilizing natural gas in this measure.
 - create_typical_building_from_model parameter: **heating_fuel**
 - Default: 'NaturalGas'

#### **Daylight Savings Time:** 
This measure assumes DST is applied to the building.
 - create_typical_building_from_model parameter: **enable_dst**
 - Default: 'true'

#### **Unmet Hour Tolerance:** 
This sets the thermostat setpoint tolerance for unmet hours in degrees Rankine and defaults to 1.
 - create_typical_building_from_model parameter: **unmet_hours_tolerance_r**
 - Default: '1.0'

#### **Remove Objects:** 
This parameter strips the existing model of objects that are being specified in the model. For instance, if an HVAC system is being applied, existing HVAC components will be removed. 
 - create_typical_building_from_model parameter: **remove_objects**
 - Default: 'true'
