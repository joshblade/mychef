# ls_windows_ad
The Lunatic Scripter Windows Active Directory Cookboook
=======================================================

Requirements
------------
#### Platforms
Server Recipe
* Windows Server 2012 (R1, R2)

Client Recipe
* Windows Server 2012 (R1, R2)
* Windows 8, 8.1, 10

#### Chef
- Chef 12+

#### Cookbooks
* windows - (windows_feature to install windows features with PowerShell)

Attributes
----------
* 'node['ls_windows_ad']['domain_name']' - used to configure the name of the domain to be created
* 'node['ls_windows_ad']['domain_netbios_name']' - used to configure short name of the domain
* 'node['ls_windows_ad'][safe_mode_admin_pswd]' - used to set admin safe mode password (note: strongly recommend using chef-vault to secure this attribute)
* 'node['ls_windows_ad']['version']' - used to set the domain functional level default is Windows 2012 R2
* 'node['ls_windows_ad']['admin_username']' - used to check is the domain is already built or to add a replica domain controller to the domain
* 'node['ls_windows_ad']['admin_pswd']' - password of the domain admin account that is used to check the domain (note: strongly recommend using chef-vault to secure this attribute)
* 'node['ls_windows_ad']['role']' - role of the domain controller with primary or replica defualt is primary

Usage
-----

### default
Installs Windows Active directory on Windows Server 2012 R2

### server
Installs Windows ADDS and creates a domain or adds a server to an existing domain

### client
Adds a computer to a Windows Active Directory domain 


Resources/Providers
-----------------
### ls_windows_ad_server
Installs core AD and DNS Features. Creates a Forest, child domain, or adds a replica server to an existing domain.

#### Actions
- 'install' - Installs AD and DNS and performs the necessary post feature install domain commands.

#### Properties
- 'domain_name' - Name of the domain being created or joined
- 'restart' - Boolean whether the install should be allowed to restart after complete
- 'safe_mode_pass' - Safe Mode Password for the Domain
- 'type' - Type of Domain Controller being created. Valid options are forest, domain, and replica
- 'domain_user' - User name of a domain user who can join a replica domain controller to the domain
- 'domain_pass' - Password of the Domain user to join a replica domain controller to the domain

#### Examples
Create the foo.local forest

```
ls_windows_ad_server 'foo.local' do
  domain_name 'foo.local'
  safe_mode_pass 'super_secret_password123'
  type 'forest'
end
```

Create a replica Domain Controller

```
ls_windows_ad_server 'foo.local' do
  domain_name 'foo.local
  safe_mode_pass 'super_secret_password123'
  domain_user 'foo.local\username'
  domain_pass 'user_password123'
  type 'replica'
end
```

### ls_windows_ad_svcacct
Creates a service account in Windows Active directory

#### Actions
- ':create' - Create a service account

#### Attribute Parameters
- 'svcacct' - The name of the Service account
- 'domain_name' - The name of the domain the service account will be created in
- 'ou' - Organization Unit the service account will be created in
- 'pswd' - Password of the service account

#### Examples

Create as service account for SQL

```ruby
ls_windows_ad_svcacct do
  action :create
  svcacct 'sql_svc'
  domain_name 'thewall.local'
  pswd 'super_secret_password123'
  ou 'OU=Service Accounts,DC=thewall,DC=local'
end
```

### ls_windows_ad_ou
Creates an Organizational Unit in Active Directory

#### Actions
- ':create' - Create a Organization Unit in Active Directory

#### Attribute Parameters
- 'name' - Name of the Organizational unit
- 'path' - Location the Organizational unit will be created
- 'protect' - Whether the Orgainzational unit should be protected from accidental deletion, Default characteristic is true

#### Examples
Create OU for Service Accounts

```ruby
ls_windows_ad_ou do
  action :create
  name 'Service Accounts'
  path 'DC=thewall,DC=local'
end
```

### ls_windows_groups
Creates a group in Active Directory

#### Actions
- ':create' - Create a group in Active Directory

#### Attribute Parameters
- 'name' - The name of the group to be created
- 'category' - Type of group to be create, ie. Security or Distribution
- 'scope' - Scope of the group, ie. Local, Global, or Universal
- 'ou' - Organizational Unit the group will be created in

#### Examples
Create a global security group for SQL Admins

```ruby
ls_windows_ad_groups do
  action :create
  name 'SQL Admins'
  category 'Security'
  scope 'Global'
  ou 'OU=Groups,DC=thewall,DC=local'
end
```

### ls_windows_group_member
Add or remove a user or computer to a Active Directory group

#### Actions
- 'add' - Add a user to a group
- 'remove' - Remove a user from a group

#### Attribute Parameters
- 'user_name' - UPN of the user to be added to the group
- 'computer_name' - Computer name to be added to the group
- 'group_name' - Name of the group user or computer is to be added to

#### Examples
Add SQL Service Account to SQL Admins Group
```ruby
ls_windows_ad_group_member do
  action :add
  user_name 'sql_svc'
  group_name 'SQL Admins'
end
```

License & Author
----------------
- Author:: John Snow (thelunaticscripter@outlook.com)

```text
Copyright 2016, TheLunaticScripter.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License
