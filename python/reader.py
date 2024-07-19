def reader_aux(file):
    data = {}
    for line in file:
        if len(line.split("=")) == 1:
            continue
        values = line.split("=")
        key = values[0].strip()
        data[key] = [x.strip() for x in values[1].split(",")]  # Convert the generator expression to a list
    return data

def clean_dict_values(data):
    for key in data:
        cleaned_list = []
        for item in data[key]:
            cleaned_item = item.replace("'", "").replace('"', '').strip() # Remove quotes and strip whitespace
            if cleaned_item:            
                cleaned_list.append(cleaned_item) # Append only non-empty items
        data[key] = cleaned_list
    return data


def reader_func(file):
    data = reader_aux(file)
    return clean_dict_values(data)

