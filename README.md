# groupTest

Note:

last and best version of this is

``` 
 	createUsers.sh
  
  general_settings.conf
  
  (Omar 202002) 
  ``` 


Look at older versions at your own peril!



automatic setup of users (rather than groups) for courses etc

sebastian 201808

some changes by philippe's TAs in course OS, 201809

it s absurdly self-explanatory:

settings are done in ... settings.conf

createGroups creates Groups

deleteGroups ... well, you guess :) ... it deletes all groups according to settings.


A feature worth noting:
with the groups already existing,
you can re-run createGroups - it will not dlete any existing files,
just update ssh keys to what is found on github.
so you could actually cron this to keep keys updated.
