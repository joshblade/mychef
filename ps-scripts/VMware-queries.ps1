$m = get-vm | where {$_.MemoryGB -le 2.00} | select 'Name', 'NumCpu', 'MemoryGB' | export-csv y:\rburke\2gbvm.csv
$m | gm
