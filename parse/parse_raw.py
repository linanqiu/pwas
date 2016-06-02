__author__ = 'linanqiu'


def parse_row(row):
    age = int(int(float(row['VSDAY'])) / 10000 - int(float(row['BIR'])) / 100)
    if age > 100 or age < 0:
        return []
    sex = int(float(row['SEX']))
    outputs = []
    if len(row['ICD1']) > 0:
        outputs.append({'PID': row['PID'], 'ICD': int(float(row['ICD1'])), 'SEX': sex, 'AGE': age})
    if len(row['ICD2']) > 0:
        outputs.append({'PID': row['PID'], 'ICD': int(float(row['ICD2'])), 'SEX': sex, 'AGE': age})
    if len(row['ICD3']) > 0:
        outputs.append({'PID': row['PID'], 'ICD': int(float(row['ICD3'])), 'SEX': sex, 'AGE': age})
    return outputs
