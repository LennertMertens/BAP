import time
import gspread
import oauth2client
from oauth2client.service_account import ServiceAccountCredentials

def next_available_row(worksheet):
    str_list = filter(None, worksheet.col_values(3))
    return str(len(str_list)+1)

def main():   
    # Initialize variables for Google API
    scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
    credentials = ServiceAccountCredentials.from_json_keyfile_name('/app/credentials.json', scope)
    client = gspread.authorize(credentials)
    worksheet = client.open("executietijd-demofunctie").sheet1
    next_row = next_available_row(worksheet)

    # Start timer 
    start = time.time()

    # Print statement
    print "Hello everyone, this is a serverless demo function running on Fission!"

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
    worksheet.update_acell("C{}".format(next_row), execution_time)
    return "End of function, see results at https://docs.google.com/spreadsheets/d/1-YC3T1XabN_8dUlJOk16zFW0IT2vnctvXloo5Jitl5k/edit#gid=0"

