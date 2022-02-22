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

### Docker image
We also provide __Docker__ image with _compiled_ __Infer__  with 
__LFA__, **DFA**, and __TOPL__ checkers. See README in `/docker` for 
 installation and usage instructions. 


## Running Experiments
- **Prerequisites**: python 3, matplotlib, [gnu-time](https://www.gnu.org/software/time/), and [bc](https://www.gnu.org/software/bc/manual/html_mono/bc.html) 
- __Note__: Update `TIMECMD` to point to `gnu-time` in `/examples/lfa-experiments/lfa.sh` 
  
- Experiments are performed by script `./lfa.sh` in `/examples/lfa-experiments` with the following flags: 
  - `-a` - __LFA vs DFA__: analyze Java test programs using contracts with 5-85 states (LoC ~15k) by __LFA__ and __DFA__ checker and produces execution time and memory usage comparison graphs (`time-dfa.png` and `mem-dfa.png`) in `/graphs` 
  - `-t` - __LFA vs TOPL__: same as above but makes a comparison to __TOPL__ checker
  - `-ak` - __LFA vs DFA__: analyze Java test programs using contracts with 100-4000 states (LoC 500-1k) and produces execution time and memory usage comparison graphs (`kstates-time-dfa.png` and `kstates-mem-dfa.png`) in `/graphs`  
  -  `-tk` - __LFA vs TOPL__: same as above but makes a comparison with __TOPL__ checker
  
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




