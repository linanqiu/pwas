import csv
import logging, os, sys
import pickle
from parse.parse_raw import parse_row

logger = logging.getLogger('root')

program = os.path.basename(sys.argv[0])
logger = logging.getLogger(program)
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')
logging.root.setLevel(level=logging.INFO)
logger.info("running %s" % ' '.join(sys.argv))

# with open('csv_data/patients.csv', 'w') as f_out:
#     count = 0
#
#     writer = csv.DictWriter(f_out, fieldnames=['PID', 'ICD', 'SEX', 'AGE'])
#     writer.writeheader()
#     with open('csv_data/opd3.csv', 'r') as f:
#         reader = csv.DictReader(f)
#         for row in reader:
#             count += 1
#             if count % 100000 == 0:
#                 logger.info('processing line %d' % count)
#             outputs = parse_row(row)
#             for output in outputs:
#                 writer.writerow(output)
#
# with open('csv_data/patient_counts.csv', 'w') as f_out:
#     count = 0
#
#     writer = csv.DictWriter(f_out, fieldnames=['AGE', 'N'])
#     writer.writeheader()
#
#     # key = age, value = set of patient IDS
#     age_patients = {}
#     with open('csv_data/patients.csv', 'r') as f:
#         reader = csv.DictReader(f)
#         for line in reader:
#             count += 1
#             if count % 100000 == 0:
#                 logger.info('counting line %d' % count)
#             age = line['AGE']
#             pid = line['PID']
#             if age not in age_patients:
#                 age_patients[age] = set()
#             age_patients[age].add(pid)
#
#     patient_counts = [{'AGE': age, 'N': len(pids)} for age, pids in age_patients.items()]
#     pickle.dump(patient_counts, open('patient_counts.pkl', 'wb'))
#     for patient_count in sorted(patient_counts, key=lambda k: k['AGE']):
#         writer.writerow(patient_count)

with open('csv_data/icds.csv', 'w') as f_out:
    count = 0

    writer = csv.DictWriter(f_out, fieldnames=['ICD', 'N'])
    writer.writeheader()

    icd_patients = {}
    with open('csv_data/patients.csv', 'r') as f:
        reader = csv.DictReader(f)
        for line in reader:
            count += 1
            if count % 100000 == 0:
                logger.info('icd counting line %d' % count)
            icd = line['ICD']
            pid = line['PID']
            if icd not in icd_patients:
                icd_patients[icd] = set()
            icd_patients[icd].add(pid)

    patient_counts = [{'ICD': icd, 'N': len(pids)} for icd, pids in icd_patients.items()]
    for patient_count in sorted(patient_counts, key=lambda k: k['AGE']):
        writer.writerow(patient_count)
