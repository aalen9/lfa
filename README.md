# LFA Checker 

__LFA checker__ is a typestate analysis tool implemented in [**Infer**](https://fbinfer.com). 
__LFA checker__ provides _lightweight_ typestate annotations and it is 
based on strict sub-class of DFA, which we call _BFA_. It supports 
Java and C++ programs analysis. 

This repository contains __Infer__ sources with __TOPL__ and our additional 
checkers enabled: 
- **LFA checker** is a lightweight typestate analysis based on the strict sub-class of __DFA__, which we call __BFA__. The sources are in in `/lfa-checker/infer/src/checkers/`: `LfaChecker.ml` and `LfaCheckerDomain.ml` . 
- **DFA checker** is a basic typestate analysis based on __DFA__. The sources are in `/infer/src/checkers/`:`DfaChecker.ml` and `DfaCheckerDomain.ml` . 


## Installation 
To install follow [__Infer__ instructions](https://github.com/facebook/infer/blob/main/INSTALL.md#install-infer-from-source) using sources from this 
repository. This will compile and setup __Infer__ with __LFA__, **DFA**, and __TOPL__ checkers enabled. 


## Using LFA and DFA checkers 
### LFA checker 
- __LFA checker__ is invoked by specifying LFA contract (e.g., `lfa-cr.json`) by an option `--lfa-properties lfa-cr.json`
- to only invoke __LFA checker__ use option `--lfachecker-only`
- the sample command to analyze `Test.java` file with `lfa-cr.json` is as follows: 
  
`infer --lfachecker-only --lfa-properties lfa-contract.json -- javac capture 
Test.java`

- __LFA__ contract  (`lfa-cr.json` in the command above) should be formatted following contract's examples given in `/examples/lfa-experiments/cr/` with suffix _-lfa.json_

### DFA checker 
- __DFA checker__ is invoked by specifying DFA contract (e.g., `dfa-cr.json`) by an option `--dfa-properties dfa-cr.json`
- to only invoke __DFA checker__ use option `--dfachecker-only`
- the sample command to analyze `Test.java` file with `dfa-contract.json` is as follows: 

`infer --dfachecker-only --dfa-properties dfa-cr.json -- javac capture 
Test.java`

- __DFA__ contract  (`dfa-cr.json` in the command above) should be formatted following contract's examples given in `/examples/lfa-experiments/cr/` with suffix _-dfa.json_

## Running Experiments
- **Prerequisites**: [gnu-time](https://www.gnu.org/software/time/) and [bc](https://www.gnu.org/software/bc/manual/html_mono/bc.html) 
- __Note__: Update `TIMECMD` to point to `gnu-time` in `lfa.sh` 
  

- __LFA__ vs __DFA__: Run `./lfa.sh -a` in `/examples/lfa-experiments` . This command performs experiments on Java test programs in the folder and produces execution time and memory comparison graphs (`comp-time-dfa.png` and `comp-mem-dfa.png`) in `/graphs`.

- __LFA__ vs __TOPL__: Similar as above with the following command: `./lfa.sh -t`. 
