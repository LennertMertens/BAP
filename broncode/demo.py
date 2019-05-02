import time
import gspread
from oauth2client.service_account import ServiceAccountCredentials

# Function to get the first empty row in Gooogle Spreadsheet
def next_available_row(worksheet):
    str_list = filter(None, worksheet.col_values(1))  # fastest
    return str(len(str_list)+1)

# Initialize variables for Google API
scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('credentials.json', scope)
client = gspread.authorize(credentials)
worksheet = client.open("executietijd-openfaas").sheet1
next_row = next_available_row(worksheet)

# Start timer 
start = time.time()

# Print message visible by users
print("Hello everyone, this is a serverless demo function!")

# Start loop function to measure execution time
a = range(1000000)
b = []
for i in a:
    b.append(i*2)

# Stop timer
end = time.time()

# Calculate the execution time of the function in seconds
execution_time= end - start

# Write the execution time to Google spreadsheet
worksheet.update_acell("A{}".format(next_row), execution_time)