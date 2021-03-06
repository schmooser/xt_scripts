col action_time   format a19;
col action        format a20;
col namespace     format a10;
col version       format a15;
col bundle_series format a13;
col comments      format a50;

select 
   to_char(h.action_time,'yyyy-mm-dd hh24:mi:ss') as action_time
  ,h.action
  ,h.namespace
  ,h.version
  ,h.id
  ,h.bundle_series
  ,h.comments
from DBA_REGISTRY_HISTORY h
order by h.action_time
;
col action_time   clear;
col action        clear;
col namespace     clear;
col version       clear;
col bundle_series clear;
col comments      clear;
