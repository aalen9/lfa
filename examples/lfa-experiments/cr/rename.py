import os 


def ren_lfa(file): 
    file_split = file.split("-") 
    def f(x): 
        if (x=="lta"): 
            return "lfa"
        elif (x=="lta.json"): 
            return "lfa.json"
        else: 
            return x 
    res = map(lambda x : f(x), file_split) 
    return "-".join(list(res))  

def rename_lfa1(): 
    files = os.listdir() 
    for file in files: 
        new_name=ren_lfa(file) 
        os.rename(file, new_name)