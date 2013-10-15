col username    format  a20
col inst        format  999
col serial      format  a7
col event       format  a30
col wait_class  format  a15
col osuser      format  a12
col program     format  a15
col terminal    format  a20
col module      format  a20
col os_pid      format  a7
col ora_pid     format  a10
col pe_object   format  a35
col po_object   format  a35
col sql_exec_start  format a14 heading sql_started
with u_info as (
   select
      s.USERNAME                                   as username
     ,s.inst_id                                    as inst
     ,s.sid                                        as sid
     ,trim(s.serial#                             ) as serial
     ,s.serial#                                    as serial#
     ,s.osuser                                     as osuser
     ,s.event                                      as event
     ,s.wait_class                                 as wait_class
     ,s.TERMINAL                                   as terminal
     ,s.program                                    as program
     ,s.module                                     as module
     ,p.spid                                       as spid
     ,p.spid                                       as os_pid
     ,p.pid                                        as pid
     ,p.pid                                        as ora_pid
     ,s.sql_id                                     as sql_id
&_IF_ORA11_OR_HIGHER     ,to_char(s.sql_exec_start,'dd/mm hh24:mi:ss')   as sql_exec_start
     ,nvl2( pe.owner
           ,pe.owner
            ||'.'||pe.OBJECT_NAME
            ||nvl2(pe.PROCEDURE_NAME,'.'||pe.PROCEDURE_NAME,'')
           ,''
          )                                        as pe_object
     ,nvl2( po.owner
           ,po.owner
            ||'.'||po.OBJECT_NAME
            ||nvl2(po.PROCEDURE_NAME,'.'||po.PROCEDURE_NAME,'')
           ,null
          )                                        as po_object
   from gv$session  s
       ,gv$process  p
       ,dba_procedures pe
       ,dba_procedures po
   where 
        s.paddr = p.addr
    and s.inst_id = p.inst_id
    and pe.OBJECT_ID    (+)    = s.PLSQL_ENTRY_OBJECT_ID
    and pe.SUBPROGRAM_ID(+)    = s.PLSQL_ENTRY_SUBPROGRAM_ID
    and po.OBJECT_ID    (+)    = s.PLSQL_OBJECT_ID
    and po.SUBPROGRAM_ID(+)    = s.PLSQL_SUBPROGRAM_ID
    and (s.sid = &1 or upper(s.osuser) like upper('%&1%') or s.username like upper('%&1%'))
)
select 
    username
    ,inst
    ,sid
    ,serial
    ,osuser
    ,event
    ,wait_class
--    ,terminal
    ,program
    ,module
    ,os_pid
    ,ora_pid||'' as ora_pid
    ,sql_id
&_IF_ORA11_OR_HIGHER    ,sql_exec_start
    ,pe_object
    ,po_object
from u_info
/