#!/bin/bash 

# UPATE THESE COMMAND ALIASES IF NEEDED 
TIMECMD=gtime #gtime stands for gnu-time 
INFERCMD=infer 

TOPL=false  
GEN=false 
ANALYZE=false 
COUNT=false 
KSTATES=false 
# CLEAN=false 

while test $# -gt 0; do
  case "$1" in
    -g|--gen)
      GEN=true 
      break
      ;;
    -a|--analyze) 
        ANALYZE=true 
        break;;
    -t|--topl) 
        TOPL=true 
        ANALYZE=true 
        break;;
    -c|--count) 
        COUNT=true 
        break;;
    -ak|--analyzekstates) 
        KSTATES=true
        ANALYZE=true
        break;;
    -gk|--genkstates) 
        KSTATES=true
        ANALYZE=false
        GEN=true
        break;;
    -tk|--toplkstates) 
        KSTATES=true 
        TOPL=true 
        ANALYZE=true 
        break;;
    # -c|--clean) 
    #     CLEAN=true 
    #     break;;
    *)
      break
      ;;
  esac
done

if $COUNT; then 
    cmd="dune exec -- ./lfa.exe  -count"
    eval $cmd 
    exit 1 
fi 




NUM_BASIC_METHODS=4


# states 
if $KSTATES;then 
    NUM_STATES=8
    STATESSEQ=(100 522 1044 1628 2322 2644 3138 3638 4000)
    METHODSSEQ=(14 14 14 14 14 16 18 18 18)
else 
    NUM_STATES=6
    STATESSEQ=(5 9 14 18 30 41 85)
    METHODSSEQ=(3 5 5 7 7 7 10) 
fi 

# locs 
if $KSTATES;then 
    NUM_LOC=2
    LOCSEQ=(550 800 1050) 
    BASICSEQ=(120 240 480)
    # NUMBASICFUN=20 
    NUM_FOOS=3 
    FOOSSEQ=(4 6 8 10) 
else 
    NUM_LOC=0 
    LOCSEQ=(16500)
    BASICSEQ=(14000)
    NUMBASICFUN=(600)

    NUM_FOOS=1
    FOOSSEQ=(8 20) 
fi 


if $ANALYZE; then 
 # CLEAN 
    rm *-dfa.txt
    rm *-lfa.txt 
    rm *-topl.txt 
fi 

for i in $(seq 0 $NUM_STATES)
do 
    states=${STATESSEQ[i]}
    methods=${METHODSSEQ[i]} 

    for j in $(seq 0 $NUM_LOC)
        do 
        # GENERATE FILE  
        loc=${LOCSEQ[j]}
        basic=${BASICSEQ[j]}

        NUM_BASIC_METHODS=${NUMBASICFUN[j]}

        for k in $(seq 0 $NUM_FOOS) 
        do 
        foos=${FOOSSEQ[k]}    
        if $COMP; then 
            cmd_client="dune exec -- ./lfa.exe  -comp -rangebasic $basic -numcomp $foos -rangenum  $loc -methods  $methods  -states $states -numbasicfun $NUM_BASIC_METHODS >> temp.txt"
        else 
            cmd_client="dune exec -- ./lfa.exe  -rangenum  $loc -methods  $methods  -states $states"
        fi 

        # echo "cmd_client is $cmd_client"

        if $GEN; then 
            echo "cmd_client is $cmd_client"
            filepath=$((eval $cmd_client) 2>&1) 
        else 
            if $COMP; then 
                filepath="foo-$methods-$states-lfa-foos-$foos-num-$loc-count-$basic.java"
            else 
                filepath="flat-foo-$methods-$states-lfa-num-$loc.java"
            fi
        fi 
        
        echo "FILE PATH IS: $filepath"

        if $ANALYZE; then 
           
           

            # CAPTURE
            cmd="$INFERCMD capture -- javac $filepath"
            res=$(eval $cmd)
        # fi 

            if $COMP; then 
            # GET OUTPUT PATH 
                LFA_PATH="loc-$loc-basic-$basic-foos-$foos-lfa.txt"
                DFA_PATH="loc-$loc-basic-$basic-foos-$foos-dfa.txt"
                MEM_LFA_PATH="mem-loc-$loc-basic-$basic-foos-$foos-lfa.txt"
                MEM_DFA_PATH="mem-loc-$loc-basic-$basic-foos-$foos-dfa.txt"
                TOPL_PATH="loc-$loc-basic-$basic-foos-$foos-topl.txt"
                MEM_TOPL_PATH="mem-loc-$loc-basic-$basic-foos-$foos-topl.txt"
            else 
                LFA_PATH="loc-$loc-lfa.txt"
                DFA_PATH="loc-$loc-dfa.txt"
                MEM_LFA_PATH="mem-loc-$loc-lfa.txt"
                MEM_DFA_PATH="mem-loc-$loc-dfa.txt"
                TOPL_PATH="loc-$loc-topl.txt"
                MEM_TOPL_PATH="mem-loc-$loc-topl.txt"
            fi 

            # TEST TIME 
            cmd_lfa="$TIMECMD --format='%e %M' -- $INFERCMD --lfachecker-only --lfa-no-error-reporting --lfa-properties cr/foo-$methods-$states-lfa.json > temp.txt"
            cmd_dfa="$TIMECMD --format='%e %M' -- $INFERCMD --dfachecker-only --dfa-no-error-reporting  --dfa-properties cr/foo-$methods-$states-dfa.json > temp.txt"
            cmd_topl="$TIMECMD --format='%e %M' -- $INFERCMD --topl-only --topl-properties cr/foo-$methods-$states.topl > temp.txt"


            #  repeat n times and get average
	    if $TOPL; then 
		  REPEATS=1
	    else
		  REPEATS=3
	    fi   
            #REPEATS=2
            TIME_LFA=0 
            MEMORY_LFA=0
            TIME_DFA=0 
            MEMORY_DFA=0
            TIME_TOPL=0
            MEMORY_TOPL=0 
            for i in $(seq 1 $REPEATS)
            do 
                # run all three and print times to check 
                OUTPUT_LFA=$((eval $cmd_lfa) 2>&1)
                OUTPUT_DFA=$((eval $cmd_dfa) 2>&1) 


                if $TOPL; then 
                    OUTPUT_TOPL=$((eval $cmd_topl) 2>&1) 
                fi 

                USER_TIME_LFA=$(echo $OUTPUT_LFA | cut -d ' ' -f 13)
                MEM_LFA=$(echo $OUTPUT_LFA | cut -d ' ' -f 14)

                # echo "Mem LTA is: $MEM_LTA"

                # USER_TIME_DFA=$(echo $OUTPUT_DFA | cut -d ' ' -f 13)
                # MEM_DFA=$(echo $OUTPUT_DFA | cut -d ' ' -f 14)

                if $TOPL; then 
                    USER_TIME_TOPL=$(echo $OUTPUT_TOPL | cut -d ' ' -f 13)
                    MEM_TOPL=$(echo $OUTPUT_TOPL | cut -d ' ' -f 14)
                else 
                    USER_TIME_DFA=$(echo $OUTPUT_DFA | cut -d ' ' -f 13)
                    MEM_DFA=$(echo $OUTPUT_DFA | cut -d ' ' -f 14)
                fi 
                # USER_TIME_TOPL=$(echo $OUTPUT_TOPL | cut -d ' ' -f 13)
                # MEM_TOPL=$(echo $OUTPUT_TOPL | cut -d ' ' -f 14)

                # echo "Mem DFA is: $MEM_DFA"

                TIME_LFA=$((bc<<<"scale=3;$TIME_LFA+$USER_TIME_LFA") 2>&1)
                MEMORY_LFA=$((bc<<<"scale=3;$MEMORY_LFA+$MEM_LFA") 2>&1)

                # TIME_DFA=$((bc<<<"scale=3;$TIME_DFA+$USER_TIME_DFA") 2>&1)
                # MEMORY_DFA=$((bc<<<"scale=3;$MEMORY_DFA+$MEM_DFA") 2>&1)

                if $TOPL; then 
                    TIME_TOPL=$((bc<<<"scale=3;$TIME_TOPL+$USER_TIME_TOPL") 2>&1)
                    MEMORY_TOPL=$((bc<<<"scale=3;$MEMORY_TOPL+$MEM_TOPL") 2>&1)
                else 
                    TIME_DFA=$((bc<<<"scale=3;$TIME_DFA+$USER_TIME_DFA") 2>&1)
                    MEMORY_DFA=$((bc<<<"scale=3;$MEMORY_DFA+$MEM_DFA") 2>&1)
                fi
            done 

            MEAN_TIME_LFA=$((bc<<<"scale=3;$TIME_LFA/$REPEATS") 2>&1)

            echo "Mean time LFA: $MEAN_TIME_LFA s"

            MEAN_MEMORY_LFA=$((bc<<<"scale=2;$MEMORY_LFA/$REPEATS") 2>&1)
            MEAN_MEMORY_LFA=$((bc<<<"scale=2;$MEAN_MEMORY_LFA/1024") 2>&1)

            echo "Mean memory LFA: $MEAN_MEMORY_LFA mb"

            # MEAN_TIME_DFA=$((bc<<<"scale=3;$TIME_DFA/$REPEATS") 2>&1)

            # echo "Mean time DFA: $MEAN_TIME_DFA s"

            # MEAN_MEMORY_DFA=$((bc<<<"scale=2;$MEMORY_DFA/$REPEATS") 2>&1)
            # MEAN_MEMORY_DFA=$((bc<<<"scale=2;$MEAN_MEMORY_DFA/1024") 2>&1)       


            # echo "Mean memory DFA: $MEAN_MEMORY_DFA mb"

            if $TOPL; then 
                MEAN_TIME_TOPL=$((bc<<<"scale=3;$TIME_TOPL/$REPEATS") 2>&1)
                echo "Mean time TOPL: $MEAN_TIME_TOPL s"

                MEAN_MEMORY_TOPL=$((bc<<<"scale=2;$MEMORY_TOPL/$REPEATS") 2>&1)
                MEAN_MEMORY_TOPL=$((bc<<<"scale=2;$MEAN_MEMORY_TOPL/1024") 2>&1)
                echo "Mean memory TOPL: $MEAN_MEMORY_TOPL mb"
            else 
                MEAN_TIME_DFA=$((bc<<<"scale=3;$TIME_DFA/$REPEATS") 2>&1)

                echo "Mean time DFA: $MEAN_TIME_DFA s"

                MEAN_MEMORY_DFA=$((bc<<<"scale=2;$MEMORY_DFA/$REPEATS") 2>&1)
                MEAN_MEMORY_DFA=$((bc<<<"scale=2;$MEAN_MEMORY_DFA/1024") 2>&1)       


                echo "Mean memory DFA: $MEAN_MEMORY_DFA mb"
            fi 

            echo -e "\n"

            # APPEND TO FILE 
            echo "($states, $MEAN_TIME_LFA)" >> ${LFA_PATH}
            # echo "($states, $MEAN_TIME_DFA)" >> ${DFA_PATH}
            echo "($states, $MEAN_MEMORY_LFA)" >> ${MEM_LFA_PATH}
            # echo "($states, $MEAN_MEMORY_DFA)" >> ${MEM_DFA_PATH}

            if $TOPL; then 
                echo "($states, $MEAN_TIME_TOPL)" >> ${TOPL_PATH}
                echo "($states, $MEAN_MEMORY_TOPL)" >> ${MEM_TOPL_PATH}
            else 
                echo "($states, $MEAN_TIME_DFA)" >> ${DFA_PATH}
                echo "($states, $MEAN_MEMORY_DFA)" >> ${MEM_DFA_PATH}
            fi 

        fi 

        # echo $filepath
        done 
    done 
done 

mkdir -p graphs 

# make graphs 
if $ANALYZE; then 
    if $KSTATES; then 
        if $TOPL; then 
            GRAPHS="python3 makegraphs.py --kstates --topl"
        else 
            GRAPHS="python3 makegraphs.py -kstates"
        fi 
    else 
        if $TOPL; then 
            GRAPHS="python3 makegraphs.py --topl" 
        else 
            GRAPHS="python3 makegraphs.py" 
        fi 
    fi 
    res=$(eval $GRAPHS)
    echo "Output:"
    echo $res 
fi 
