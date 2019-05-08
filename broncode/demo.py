import gspread
import sys
from oauth2client.service_account import ServiceAccountCredentials
# Check if a string is provided when calling the function.
# Sentences should be provided between quotes!
if len(sys.argv) > 1:
  req = str(sys.argv[1])
else:
  req =""

def next_available_row(worksheet):
    str_list = filter(None, worksheet.col_values(1))
    return str(len(str_list)+1)

def is_empty_string(string):
    if len(string) == 0:
        return True
    else:
        return False

def get_values(worksheet):
    cell_range = 'A1:A'+ next_available_row(worksheet)
    all_cells = worksheet.range(cell_range)
    return all_cells

def handle(req):   
    # Initialize variables for Google API
    scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
    credentials = ServiceAccountCredentials.from_json_keyfile_name('credentials-serverless.json', scope)
    client = gspread.authorize(credentials)
    worksheet = client.open("executietijd-demofunctie").sheet1
    next_row = next_available_row(worksheet)

    # GET: return all values from column A
    # POST: Write string to Google spreadsheets in column A
    if is_empty_string(req):
        string_list = []
        for cell in get_values(worksheet):
            string_list.append(cell.value)
        print str(string_list)
    else:
        worksheet.update_acell("A{}".format(next_row), req)
        print "This function wrote '",req,"' to Google Spreadsheets!"

if __name__ == "__main__":
    handle(req)