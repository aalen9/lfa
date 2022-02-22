# Docker

This directory, `docker/` contains the instructions for the installation and
usage of __Docker__ image `aalen9/lfa-checker:latest`. 

This image contains compiled __Infer__ with __LFA__, __DFA__, and
__TOPL__ checkers. 


## Pre-requisites

To use this docker image, you will need a working docker
installation. See the instructions for
[Linux](http://docs.docker.com/linux/step_one/) or
[MacOS](http://docs.docker.com/mac/step_one/) as appropriate.

## Installation 
To pull __Docker__ repo use the following command: 
```sh 
docker pull aalen9/lfa-checker:latest
```

## Overview 
The `lfa-checker:latest` image contains (in root directory `/`): 
- `lfa-checker/` comprises of compiled __Infer__ binaries and sources with __TOPL__ and our additional __LFA__ and __DFA__ checkers enabled: 
  - **LFA** sources: (_/lfa-checker/infer/src/checkers/_) LtaChecker.ml, LtaCheckerDomain.ml
  - **DFA** sources: (_/lfa-checker/infer/src/checkers/_) DfaChecker.ml, DfaCheckerDomain.ml 
  - **Infer** binaries: _/lfa-checker/infer/bin/_
- `lfa-experiments/` comprises of: 
  - code contracts in `cr/` for __LFA__ (with suffix _-lfa.json_)and their translations to __DFA__ (with suffix _-dfa.json_) and __TOPL__ (with suffix _.topl_) contracts 
  - Java test clients 
  - `lfa.sh` - main script for performing experiments 
  - `lfa-clean.sh` - script for cleaning results of `lfa.sh`

## Performing experiments 
- Experiments are performed by script `./lfa.sh` in `/lfa-experiments` with the following flags: 
  - `-a` - __LFA vs DFA__: analyze Java test programs using contracts with 5-85 states (LoC ~15k) by __LFA__ and __DFA__ checker and produces execution time and memory usage comparison graphs (`time-dfa.png` and `mem-dfa.png`) in `graphs/` 
  - `-t` - __LFA vs TOPL__: same as above but makes a comparison with __TOPL__ checker
  - `-ak` - __LFA vs DFA__: analyze Java test programs using contracts with 100-4000 states (LoC 500-1k) and produces execution time and memory usage comparison graphs (`kstates-time-dfa.png` and `kstates-mem-dfa.png`) in `graphs/`  
  -  `-tk` - __LFA vs TOPL__: same as above but makes a comparison with __TOPL__ checker


## Using LFA and DFA checkers 
### LFA checker 
- __LFA checker__ is invoked by specifying LFA contract (e.g., `lfa-cr.json`) by an option `--lfa-properties lfa-cr.json`
- to only invoke __LFA checker__ use option `--lfachecker-only`
- the sample command to analyze `Test.java` file with `lfa-cr.json` is as follows: 
  
`/lfa-checker/infer/bin/infer --lfachecker-only --lfa-properties lfa-contract.json -- javac capture 
Test.java`

- __LFA__ contract  (`lfa-cr.json` in the command above) should be formatted following contract's examples given in `/lfa-experiments/cr/` with suffix _-lfa.json_

### DFA checker 
- __DFA checker__ is invoked by specifying DFA contract (e.g., `dfa-cr.json`) by an option `--dfa-properties dfa-cr.json`
- to only invoke __DFA checker__ use option `--dfachecker-only`
- the sample command to analyze `Test.java` file with `dfa-contract.json` is as follows: 

`infer --dfachecker-only --dfa-properties dfa-cr.json -- javac capture 
Test.java`

- __DFA__ contract  (`dfa-cr.json` in the command above) should be formatted following contract's examples given in `/examples/lfa-experiments/cr/` with suffix _-dfa.json_