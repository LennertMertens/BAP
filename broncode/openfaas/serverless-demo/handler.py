import gspread
import sys
from oauth2client.service_account import ServiceAccountCredentials

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

def handle(request):   
    # Initialize variables for Google API
    data = request
    scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
    credentials = ServiceAccountCredentials.from_json_keyfile_name('/var/openfaas/secrets/secret-api-credentials', scope)
    client = gspread.authorize(credentials)
    worksheet = client.open("executietijd-demofunctie").sheet1
    next_row = next_available_row(worksheet)

     # Print message visible by users
    if is_empty_string(data):
        string_list = []
        for cell in get_values(worksheet):
            string_list.append(cell.value)
        return str(string_list)
    else:
        worksheet.update_acell("A{}".format(next_row), data)
        string_output = "This function wrote " + data + " to Google Spreadsheets!"
        return string_output