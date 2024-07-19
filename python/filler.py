import reader

def writer(file_lines: list, params: dict, changes: list) -> list:
    modified_lines = []
    for line in file_lines:
        key = line.split("=")[0].strip()
        if str(key) in changes:
            new_values = ', '.join(params[key])
            new_line = f"{key} = {new_values}\n"
            modified_lines.append(new_line)
        else:
            modified_lines.append(line)
    return modified_lines

input_file = "input.txt"
reading_file = "reading.txt"
output_file = "output.txt"
changes = ["parent_id", "j_parent_start"]

# Read the input file and process the content
with open(input_file, "r") as file_in:
    values_in = reader.reader_func(file_in)

# Read the existing output file lines
with open(reading_file, "r") as file_out:
    file_lines = file_out.readlines()

# Update the lines based on the parameters and changes list
updated_lines = writer(file_lines, values_in, changes)

# Write the updated lines back to the output file
file_out = open(output_file, 'w')
file_out.writelines(updated_lines)
file_out.close()
