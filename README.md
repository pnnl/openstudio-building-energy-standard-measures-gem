# Openstudio Building Energy Standard Measures Gem

The OpenStudio Building Energy Standard Measures Rep is a comprehensive collection of innovative OpenStudio measures designed to facilitate energy code analysis. OpenStudio is a cutting-edge platform brings together physics-based building energy modeling (BEM), BEM process automation, and large-scale computing capabilities. The platform empowers a wide array of applications for building energy analysis. An OpenStudio measure comprises a set of programmatic instructions, typically in Ruby scripts, engineered to automate energy model queries and transformations. The measures in this repository expand and customize the OpenStudio framework to support diverse energy code related workflows. These workflows encompass, but are not limited to, exploratory design analysis on typical buildings, data acquisition for energy code compliance, and the streamlined automation of energy code modeling.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openstudio-building-energy-standard-measures'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install 'openstudio-building-energy-standard-measures'

## Usage

1. [OSSTD-PRM](./lib/measures/PerformanceRatingMethod/README.md): Performance Rating Method Measure
2. [Copper](./lib/measures/GenerateIPLVChillerElectricEIRPerformanceCurves/README.md): Copper Measure



## TODO

- [] Add new measure to generate user data csv files to support OSSTD-PRM.
- [] Add new measure to support workflows for retrieving building standard database.

# Releasing

* Update change log
* Update version in `/lib/openstudio/openstudio-building-energy-standard-measures/version.rb`
* Merge down to master
* Release via github
* run `rake release` from master
ECHO is on.
