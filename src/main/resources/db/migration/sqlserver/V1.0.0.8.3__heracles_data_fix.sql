ALTER TABLE ${ohdsiSchema}.HERACLES_VISUALIZATION_DATA DROP COLUMN data;
ALTER TABLE ${ohdsiSchema}.HERACLES_VISUALIZATION_DATA ADD data [varchar(max)];
