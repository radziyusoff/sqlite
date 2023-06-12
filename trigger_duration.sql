CREATE TRIGGER trigger_ingestions_start_date UPDATE OF run_status ON ingestions 
BEGIN
  UPDATE ingestions SET start_date = datetime(CURRENT_TIMESTAMP, 'localtime'),end_date = NULL,duration_in_seconds=NULL WHERE source_table_name = old.source_table_name and new.run_status='started';
END;

CREATE TRIGGER trigger_ingestions_end_date UPDATE OF run_status ON ingestions 
BEGIN
  UPDATE ingestions SET end_date = datetime(CURRENT_TIMESTAMP, 'localtime') WHERE source_table_name = old.source_table_name and new.run_status<>'started';
  UPDATE ingestions SET duration_in_seconds = (substr('00'||cast(((JULIANDAY(end_date) - JULIANDAY(start_date)) * 86400/3600)as int), -2, 2)||":"||substr('00'||cast(((JULIANDAY(end_date) - JULIANDAY(start_date)) * 86400/60)as int), -2, 2)||":"||substr('00'||cast(round((JULIANDAY(end_date) - JULIANDAY(start_date)) * 86400)as int), -2, 2))
  WHERE source_table_name = old.source_table_name and new.run_status<>'started';
END;

