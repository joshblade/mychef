﻿Invoke-Sqlcmd -serverInstance "HSA-ODS-UTL6" -Database "master" -query "sELECT DB_id('bpmh_ods') AS ID"