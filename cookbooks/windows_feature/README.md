[![GitHub](http://img.shields.io/badge/github-ebsco/windows_feature-blue.svg)](https://github.com/ebsco/windows_feature)

[![Cookbook Version](https://badge.fury.io/gh/ebsco%2Fwindows_feature.svg)](https://github.com/ebsco/windows_feature/releases)
[![License](http://img.shields.io/badge/license-Apache2-yellowgreen.svg)](https://github.com/ebsco/windows_feature/blob/master/LICENSE.txt)

# Windows_Feature Cookbook

Provides an LWRP that facilitates access to the mixlibrary-core gem windows feature support.

## Supported Platforms

Windows Server 2008r2

## Attributes

None

## Usage

### default
* Include the windows_feature cookbook default recipe in another recipe to provide access to windows_feature LWRP that makes use of the mixlibrary-core windows feature support.
* Add windows_feature_manage_feature resource calls to your recipe to use the LWRP.
    * [LWRP Usage Sample](https://github.com/ebsco/windows_feature/blob/master/sample_recipes/sample.rb)

## License and Authors

Author:: Mark Lynch (git_id: gitmlynch)

Copyright 2015 EBSCO Information Services. License:: Apache License, Version 2.0
