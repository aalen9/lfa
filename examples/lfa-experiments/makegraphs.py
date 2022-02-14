topl=False 
comp=True 


import getopt, sys
 
argumentList = sys.argv[1:]
 
# Options
options = "tf:"
 
long_options=["topl", "noncomp"]


 
try:
    arguments, values = getopt.getopt(argumentList, options, long_options)
     
    for currentArgument, currentValue in arguments:
 
        if currentArgument in ("-t", "--topl"): 
            topl=True 
        elif currentArgument in ("-f", "--noncomp"): 
            comp=False 
             
except getopt.error as err:
    print (str(err))


def parsePair(str): 
    # get (states, time)
    str2=str.split("(")[1]
    str3=str2.split(")")[0] 
    # remove whitespaces
    str4 = str3.replace(" ", "") 
    str5=str4.split(",")
    first=str5[0]
    first=float(first)
    second=str5[1]
    second=float(second) 
    return (first, second) 


# reszip([[(0,1),(1,1)],[(0,1.5),(1,1.5)]])
# result: {0: [1, 1.5], 1: [1, 1.5]}
def reszip(list_of_list_of_pairs): 
    num_lists = len(list_of_list_of_pairs)
    len1 = len(list_of_list_of_pairs[0])

    out_dict = {}


    for list1 in list_of_list_of_pairs: 
        for el in list1: 
            key=el[0] 
            value1=el[1] 
            if key in out_dict: 
                out_dict[key].append(value1) 
            else: 
                out_dict[key]=[value1] 
    return out_dict 

def result(fp1, fp2): 
    f1 = open(fp1, "r") 
    f2 = open(fp2, "r") 

    # get tuples 
    lines1 = f1.readlines() 
    lines2 = f2.readlines() 

    # data 
    data1 = list(map(parsePair, lines1))
    data2 = list(map(parsePair, lines2))

    datapairs = zip(data1, data2) 
    def average(pair): 
        x = pair[0] 
        y = pair[1] 
        if (x[0] == y[0]): 
            return (x[0], (x[1]+y[1])/2.0) 
        else: 
            return (x[0], -10000)
    res = list(map(average, datapairs)) 
    return res 

# input file paths
def resaverage(fps): 
    data = [] 
    for fp in fps: 
        fi = open(fp, "r") 

        lines1 = fi.readlines() 
        data1 = list(map(parsePair, lines1)) 

        data.append(data1) 
    
    data_dict = reszip(data) 
    data_pairs = data_dict.items() 
    def average(pair): 
        x = pair[0]
        ys = pair[1] 
        return (x, sum(ys)/len(ys))
    res = list(map(average, data_pairs))
    return res 

# locs=[300]
# basics=[1200]


locs=[16500]
basics=[14000]
# foos=[8,20]
# foos=[8,12,16,20]
foos=[8, 20] 

# locs=[3500]
# basics=[3000]
# foos=[8,10,16,20]

# locs=[225,300,550,800,1050]
# basics=[40,60,120,240,480] 
# foos=[4,6,8,10]


def get_fps(foo, checker, prefix=""): 
    # locs=[550,800,1050] 
    # basics=[120,240,480] 
    # locs=[300]
    # basics=[1200]
    fps=[] 
    for i in range(len(locs)):
        loc=locs[i] 
        basic=basics[i] 
        fp = prefix+"loc-"+str(loc)+"-basic-"+str(basic)+"-foos-"+str(foo)+"-"+checker+".txt"
        fps.append(fp) 
    return fps 


def gen_graph_line(foo, checker, prefix=""): 
    fps = get_fps(foo, checker, prefix) 
    res = resaverage(fps)
    return res 


def get_flat_fps(locs=[], checker="dfa", prefix=""): 
    fps=[] 
    for i in range(len(locs)):
        loc=locs[i] 
        fp = prefix+"loc-"+str(loc)+"-"+checker+".txt"
        fps.append(fp) 
    return fps 

def gen_graph_line_flat(locs, checker, prefix=""): 
    fps = get_flat_fps(locs, checker, prefix) 
    res = resaverage(fps)
    return res 

def get_i_fps(fps, indices): 
    fps1=[] 
    for i in indices: 
        fp = fps[i] 
        fps1.append(fp) 
    return fps1 

# plot graphs 
import matplotlib.pyplot as plt

def plot_graph_checker(checker, color, prefix=""):
    markers=['o','^','D', 's'] 
    for foo, marker1 in zip(foos, markers): 
        res = gen_graph_line(foo, checker, prefix) 
        res1 = zip(*res) 
        res1 = list(res1) 
        x = res1[0]
        x = list(x) 
        y = res1[1] 
        y = list(y) 
        label=checker.upper()+": "+str(foo) 
        plt.plot(x, y, color, fillstyle='none', marker=marker1, label=label) 


def plot_graph_checker_flat(checker, color, prefix=""): 
    markers=['o','^','D', 's'] 
    locs=[[225],[300,550],[550,800],[800,1050]] 
    ranges=["0-250","250-500","500-750","750-1000"]
    for i in range(len(locs)):
        marker1=markers[i]
        loc=locs[i]
        range1=ranges[i]
        res = gen_graph_line_flat(loc, checker, prefix) 
        res1 = zip(*res) 
        res1 = list(res1) 
        x = res1[0]
        x = list(x) 
        y = res1[1] 
        y = list(y) 
        label=checker.upper()+": "+range1
        # label=checker.upper()+": "+range1+" "+"LoC"
        plt.plot(x, y, color, fillstyle='none', marker=marker1, label=label) 


def plot_graph(checker, comp=True): 
    for checker, color in zip(["lfa", checker], ["-b", "-r"]): 
        if (comp): 
            plot_graph_checker(checker, color) 
        else: 
            plot_graph_checker_flat(checker, color) 

    plt.axhline(y=1.0, color='r', linestyle='--')
    plt.xlabel('states')
    plt.ylabel('time [in s]')
    plt.title("LFA vs " + checker.upper())

    plt.legend(loc="upper left")
    filename="" 
    if (comp): 
        filename="comp-"+"time-"+checker+".png" 
    else: 
        filename="flat-"+"time-"+checker+".png" 
    filename="graphs/"+filename
    plt.savefig(filename, dpi=1200)
    plt.clf() 
    return filename 

def plot_graph_mem(checker, comp=True): 
    for checker, color in zip(["lfa", checker], ["-b", "-r"]): 
        if (comp): 
            plot_graph_checker(checker, color, prefix="mem-") 
        else: 
            plot_graph_checker_flat(checker, color, prefix="mem-") 
    plt.xlabel('states')
    plt.ylabel('memory [in mb]')
    plt.title("LFA vs " + checker.upper())

    plt.legend(loc="upper left")
    filename=""
    if (comp): 
        filename="comp-"+"mem-"+checker+".png" 
    else: 
        filename="flat-"+"mem-"+checker+".png" 
    filename="graphs/"+filename
    plt.savefig(filename, dpi=1200)
    plt.clf() 
    return filename 

import sys 

def main(): 
    if (topl): 
        graph1=plot_graph("topl", comp)
        graph2=plot_graph_mem("topl", comp) 
        sys.stdout.write(graph1+"\n")
        sys.stdout.write(graph2+"\n")
    else: 
        graph1 = plot_graph("dfa", comp)
        graph2 = plot_graph_mem("dfa", comp)
        sys.stdout.write(graph1+"\n")
        sys.stdout.write(graph2+"\n")



main() 
