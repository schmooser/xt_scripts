prompt Disabling pl/sql trace(10938)
set termout off;
col sid     new_value _sid    noprint
col serial  new_value _serial noprint
select '' sid, '' serial from dual where 1=0;
set termout on;

accept _sid    prompt "Enter sid[&_sid]      : "
accept _serial prompt "Enter serial[&_serial]: "

prompt Disabling pl/sql tracing...
set serverout on;
begin
    dbms_system.set_ev(&_sid, &_serial, 10938, 0, '');
    dbms_output.put_line('PL/SQL tracing successfully disabled.');
end;
/
set serverout off;
col sid     clear;
col serial  clear;