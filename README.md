# LFA Checker 

__LFA checker__ is a typestate analysis tool implemented in **Infer**. 
__LFA checker__ provides _lightweight_ typestate annotations and it is 
based on strict sub-class of DFA, which we call _BFA_. It supports 
Java and C++ programs analysis. 

This repository contains __Infer__ sources with __TOPL__ and our additional 
checkers enabled: 
- **LFA checker** is a lightweight typestate analysis based on the strict sub-class of __DFA__, which we call __BFA__. Its sources are `LfaChecker.ml` and `LfaCheckerDomain.ml` in `/lfa-checker/infer/src/checkers/`. 
- **DFA checker** is a basic typestate analysis based on __DFA__. Its sources are `DfaChecker.ml` and `DfaCheckerDomain.ml` in (`/infer/src/checkers/`). 


## Installation 
To compile from sources and install follow [__Infer__ instructions](https://github.com/facebook/infer/blob/main/INSTALL.md#install-infer-from-source). This will compile and setup __Infer__ with __LFA__, **DFA**, and __TOPL__ checkers enabled. 


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