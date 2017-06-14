﻿#
# Module manifest for module 'NTFSPermission'
#
# Generated by: Alisdair Craik
#
# Generated on: 30/09/2013
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = '1bec717b-b2a1-4220-b0a6-5cff834f0f76'

# Author of this module
Author = 'Alisdair Craik'

# Company or vendor of this module
CompanyName = 'Vexasoft'

# Copyright statement for this module
Copyright = '(c) 2013 Vexasoft Ltd. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This module is used to add or remove NTFS access rules on the target computer.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '4.0'

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = '3.0'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('NTFSPermission.psm1')

# Functions to export from this module
FunctionsToExport = @("Get-TargetResource", "Set-TargetResource", "Test-TargetResource")

# Cmdlets to export from this module
CmdletsToExport = '*'

# HelpInfo URI of this module
# HelpInfoURI = ''

}