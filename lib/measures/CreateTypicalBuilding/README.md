

###### (Automatically generated documentation)

# Create Typical Building

## Description
The "Create Typical Building" OpenStudio measures empowers users to effortlessly generate OpenStudio and EnergyPlus models by making a few select choices. Users can input preferences such as the building energy code year (e.g., ASHRAE 90.1-2013), climate zone, and desired heating, ventilation, and air conditioning (HVAC) system.

## Modeler Description
This OpenStudio Measure analyzes and generates a standard building model using either the current geometry or a pre-established geometry file. It considers the selected building energy standard, the HVAC system, and the specific climate zone to create a standardized building model within OpenStudio. Please note that choosing any option other than "Existing Geometry" will replace the current OSM file. Selecting "JSON-specified" under "HVAC Type" allows users to map CBECS HVAC Systems to specific zones in the OSM model. An example file can be found at under this measure's tests at .\tests\source\hvac_mapping_path\hvac_zone_mapping.json

## Measure Type
ModelMeasure

## Taxonomy


## Arguments


### Geometry

**Name:** geometry,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["Existing Geometry", "College", "Courthouse", "Full Service Restaurant", "Highrise Apartment", "Hospital", "Laboratory", "Large Hotel", "Large Office", "Medium Office", "Midrise Apartment", "Outpatient Medical Office", "Primary School", "Quick Service Restaurant", "Retail Stripmall", "Secondary School", "Small Hotel", "Small Office"]


### Climate Zone

**Name:** climate_zone,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["Lookup From Model", "ASHRAE 169-2013-1A", "ASHRAE 169-2013-2A", "ASHRAE 169-2013-2B", "ASHRAE 169-2013-3A", "ASHRAE 169-2013-3B", "ASHRAE 169-2013-3C", "ASHRAE 169-2013-4A", "ASHRAE 169-2013-4B", "ASHRAE 169-2013-4C", "ASHRAE 169-2013-5A", "ASHRAE 169-2013-5B", "ASHRAE 169-2013-6A", "ASHRAE 169-2013-6B", "ASHRAE 169-2013-7", "ASHRAE 169-2013-8"]


### Building Energy Code

**Name:** template,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["DOE Ref 1980-2004", "DOE Ref Pre-1980", "90.1-2004", "90.1-2007", "90.1-2010", "90.1-2013", "90.1-2016", "90.1-2019"]


### HVAC Type

**Name:** hvac_type,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["Existing HVAC", "Inferred", "JSON specified", "Baseboard central air source heat pump", "Baseboard district hot water", "Baseboard electric", "Baseboard gas boiler", "Direct evap coolers with baseboard central air source heat pump", "Direct evap coolers with baseboard district hot water", "Direct evap coolers with baseboard electric", "Direct evap coolers with baseboard gas boiler", "Direct evap coolers with forced air furnace", "Direct evap coolers with gas unit heaters", "Direct evap coolers with no heat", "DOAS with fan coil air-cooled chiller with baseboard electric", "DOAS with fan coil air-cooled chiller with boiler", "DOAS with fan coil air-cooled chiller with central air source heat pump", "DOAS with fan coil air-cooled chiller with district hot water", "DOAS with fan coil air-cooled chiller with gas unit heaters", "DOAS with fan coil air-cooled chiller with no heat", "DOAS with fan coil chiller with baseboard electric", "DOAS with fan coil chiller with boiler", "DOAS with fan coil chiller with central air source heat pump", "DOAS with fan coil chiller with district hot water", "DOAS with fan coil chiller with gas unit heaters", "DOAS with fan coil chiller with no heat", "DOAS with fan coil district chilled water with baseboard electric", "DOAS with fan coil district chilled water with boiler", "DOAS with fan coil district chilled water with central air source heat pump", "DOAS with fan coil district chilled water with district hot water", "DOAS with fan coil district chilled water with gas unit heaters", "DOAS with fan coil district chilled water with no heat", "DOAS with VRF", "DOAS with water source heat pumps cooling tower with boiler", "DOAS with water source heat pumps district chilled water with district hot water", "DOAS with water source heat pumps fluid cooler with boiler", "DOAS with water source heat pumps with ground source heat pump", "Fan coil air-cooled chiller with boiler", "Fan coil air-cooled chiller with baseboard electric", "Fan coil air-cooled chiller with central air source heat pump", "Fan coil air-cooled chiller with district hot water", "Fan coil air-cooled chiller with gas unit heaters", "Fan coil air-cooled chiller with no heat", "Fan coil chiller with baseboard electric", "Fan coil chiller with boiler", "Fan coil chiller with central air source heat pump", "Fan coil chiller with district hot water", "Fan coil chiller with gas unit heaters", "Fan coil chiller with no heat", "Fan coil district chilled water with baseboard electric", "Fan coil district chilled water with boiler", "Fan coil district chilled water with central air source heat pump", "Fan coil district chilled water with district hot water", "Fan coil district chilled water with gas unit heaters", "Fan coil district chilled water with no heat", "Forced air furnace", "Gas unit heaters", "Packaged VAV Air Loop with Boiler", "PSZ-AC district chilled water with baseboard district hot water", "PSZ-AC district chilled water with baseboard electric", "PSZ-AC district chilled water with baseboard gas boiler", "PSZ-AC district chilled water with central air source heat pump", "PSZ-AC district chilled water with district hot water", "PSZ-AC district chilled water with electric coil", "PSZ-AC district chilled water with gas boiler", "PSZ-AC district chilled water with gas coil", "PSZ-AC district chilled water with gas unit heaters", "PSZ-AC district chilled water with no heat", "PSZ-AC with baseboard district hot water", "PSZ-AC with baseboard electric", "PSZ-AC with baseboard gas boiler", "PSZ-AC with central air source heat pump", "PSZ-AC with district hot water", "PSZ-AC with electric coil", "PSZ-AC with gas boiler", "PSZ-AC with gas coil", "PSZ-AC with gas unit heaters", "PSZ-AC with no heat", "PSZ-HP", "PTAC with baseboard district hot water", "PTAC with baseboard electric", "PTAC with baseboard gas boiler", "PTAC with central air source heat pump", "PTAC with district hot water", "PTAC with electric coil", "PTAC with gas boiler", "PTAC with gas coil", "PTAC with gas unit heaters", "PTAC with no heat", "PTHP", "PVAV with central air source heat pump reheat", "PVAV with district hot water reheat", "PVAV with gas boiler reheat", "PVAV with gas heat with electric reheat", "PVAV with PFP boxes", "Residential AC with baseboard central air source heat pump", "Residential AC with baseboard district hot water", "Residential AC with baseboard electric", "Residential AC with baseboard gas boiler", "Residential AC with no heat", "Residential AC with residential forced air furnace", "Residential forced air furnace", "Residential heat pump", "Residential heat pump with no cooling", "VAV air-cooled chiller with central air source heat pump reheat", "VAV air-cooled chiller with district hot water reheat", "VAV air-cooled chiller with gas boiler reheat", "VAV air-cooled chiller with gas coil reheat", "VAV air-cooled chiller with no reheat with baseboard electric", "VAV air-cooled chiller with no reheat with gas unit heaters", "VAV air-cooled chiller with no reheat with zone heat pump", "VAV air-cooled chiller with PFP boxes", "VAV chiller with central air source heat pump reheat", "VAV chiller with district hot water reheat", "VAV chiller with gas boiler reheat", "VAV chiller with gas coil reheat", "VAV chiller with no reheat with baseboard electric", "VAV chiller with no reheat with gas unit heaters", "VAV chiller with no reheat with zone heat pump", "VAV chiller with PFP boxes", "VAV district chilled water with central air source heat pump reheat", "VAV district chilled water with district hot water reheat", "VAV district chilled water with gas boiler reheat", "VAV district chilled water with gas coil reheat", "VAV district chilled water with no reheat with baseboard electric", "VAV district chilled water with no reheat with gas unit heaters", "VAV district chilled water with no reheat with zone heat pump", "VAV district chilled water with PFP boxes", "VRF", "Water source heat pumps cooling tower with boiler", "Water source heat pumps district chilled water with district hot water", "Water source heat pumps fluid cooler with boiler", "Water source heat pumps with ground source heat pump", "Window AC with baseboard central air source heat pump", "Window AC with baseboard district hot water", "Window AC with baseboard electric", "Window AC with baseboard gas boiler", "Window AC with forced air furnace", "Window AC with no heat", "Window AC with unit heaters"]


### HVAC Zone Mapping JSON Path:
Required if "JSON specified" is selected for "HVAC Type". Please enter a valid absolute path to a HVAC-to-Zone mapping JSON.
**Name:** user_hvac_json_path,
**Type:** String,
**Units:** ,
**Required:** false,
**Model Dependent:** false


### Add Constructions

**Name:** add_constructions,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["TRUE", "FALSE"]


### Wall Construction

**Name:** wall_construction,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["Inferred", "Mass", "Metal Building", "SteelFramed", "WoodFramed"]


### Add Space Type Loads
Utlilize Space Type objects StandardSpaceType to inform modeling for equipment and lighting.
**Name:** add_space_type_loads,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["TRUE", "FALSE"]


### Add Daylighting

**Name:** add_daylighting,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["TRUE", "FALSE"]


### Add Service Hot Water

**Name:** add_shw,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["TRUE", "FALSE"]






