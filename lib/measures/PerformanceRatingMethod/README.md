

###### (Automatically generated documentation)

# Create ASHRAE 90.1-2019 PRM Model

## Description
Create the <strong>Baseline Building</strong> per ASHRAE Standard 90.1-2019 Performance Rating Method. User manual for this measure please see <a href='https://pnnl.github.io/BEM-for-PRM/'> https://pnnl.github.io/BEM-for-PRM </a>.

## Modeler Description


## Measure Type
ModelMeasure

## Taxonomy


## Arguments


### Default Building Area Type for Window To Wall Ratio:
Select default building type for WWR assignment based on 90.1 Appendix G table G3.1.1-1.
**Name:** building_type_wwr,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["Grocery store", "Healthcare (outpatient)", "Hospital", "Hotel/motel <= 75 rooms", "Hotel/motel > 75 rooms", "Office <= 5,000 sq ft", "Office 5,000 to 50,000 sq ft", "Office > 50,000 sq ft", "Restaurant (quick service)", "Restaurant (full service)", "Retail (stand alone)", "Retail (strip mall)", "School (primary)", "School (secondary and university)", "Warehouse (nonrefrigerated)", "All others"]


### Default Building Area Type for Service Water Heating:
Select default building type for SWH system type assignment based on 90.1 Appendix G table G3.1.1-2.
**Name:** building_type_swh,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["Automotive facility", "Performing arts theater", "Convenience store", "Police station", "Convention center", "Post office", "Courthouse", "Religious facility", "Dining: Bar lounge/leisure", "Retail", "Dining: Cafeteria/fast food", "School/university", "Dining: Family", "Sports arena", "Dormitory", "Town hall", "Exercise center", "Transportation", "Fire station", "Warehouse", "Grocery store", "Workshop", "Gymnasium", "Health-care clinic", "Hospital and outpatient surgery center", "Hotel", "Library", "Manufacturing facility", "Motel", "Motion picture theater", "Multifamily", "Museum", "Office", "Parking garage", "Penitentiary", "All others"]


### Default Building Type for HVAC:
Select default building type for HVAC system type assignment based on 90.1 Appendix G table G3.1.1-3.
**Name:** building_type_hvac,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["retail", "other nonresidential", "public assembly", "residential", "unconditioned", "heated-only storage", "hospital"]


### Climate Zone:

**Name:** climate_zone,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["ASHRAE 169-2013-1A", "ASHRAE 169-2013-1B", "ASHRAE 169-2013-2A", "ASHRAE 169-2013-2B", "ASHRAE 169-2013-3A", "ASHRAE 169-2013-3B", "ASHRAE 169-2013-3C", "ASHRAE 169-2013-4A", "ASHRAE 169-2013-4B", "ASHRAE 169-2013-4C", "ASHRAE 169-2013-5A", "ASHRAE 169-2013-5B", "ASHRAE 169-2013-5C", "ASHRAE 169-2013-6A", "ASHRAE 169-2013-6B", "ASHRAE 169-2013-7A", "ASHRAE 169-2013-7B", "ASHRAE 169-2013-8A", "ASHRAE 169-2013-8B", "ASHRAE 169-2006-1A", "ASHRAE 169-2006-1B", "ASHRAE 169-2006-2A", "ASHRAE 169-2006-2B", "ASHRAE 169-2006-3A", "ASHRAE 169-2006-3B", "ASHRAE 169-2006-3C", "ASHRAE 169-2006-4A", "ASHRAE 169-2006-4B", "ASHRAE 169-2006-4C", "ASHRAE 169-2006-5A", "ASHRAE 169-2006-5B", "ASHRAE 169-2006-5C", "ASHRAE 169-2006-6A", "ASHRAE 169-2006-6B", "ASHRAE 169-2006-7A", "ASHRAE 169-2006-7B", "ASHRAE 169-2006-8A", "ASHRAE 169-2006-8B"]


### Exempt From Rotations:
Select TRUE if the building has rating authority approval that orientation is dictated by site considerations. Note: user data could override this selection.
**Name:** exempt_from_rotations,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["TRUE", "FALSE"]


### Exempt From Unmet Load Hours Check:
Select TRUE if rating authority has approved allowing the models to exceed the specified values in Appendix G.
**Name:** exempt_from_unmet_load_hours_check,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["TRUE", "FALSE"]


### Use User Data
Project user compliance data.
**Name:** user_data,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["TRUE", "FALSE"]


### User Data Path:
Required if select "TRUE" in "Use User Data". Please input a valid folder path which contains the user data files.
**Name:** user_data_path,
**Type:** String,
**Units:** ,
**Required:** false,
**Model Dependent:** false


### Use PRM evaluation package
Set to True the measure will search the local copy of OpenStudio-Standards to perform PRM
**Name:** evaluation_package,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

**Choice Display Names** ["TRUE", "FALSE"]


### Evaluation Package Path:
Required if select "TRUE" in "Use PRM evaluation package". Please input a valid folder path which contains the evaluation package.
**Name:** evaluation_package_path,
**Type:** String,
**Units:** ,
**Required:** false,
**Model Dependent:** false


### Generate logs for debug

**Name:** debug,
**Type:** Boolean,
**Units:** ,
**Required:** true,
**Model Dependent:** false






