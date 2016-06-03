\copy patient_counts FROM 'csv_data/patient_counts.csv' CSV HEADER;
\copy patients (PID, ICD, SEX, AGE) FROM 'csv_data/patients.csv' CSV HEADER;
\copy icds FROM 'csv_data/icds.csv' CSV HEADER;
