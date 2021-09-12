#  trepka\_etal\_natcomm\_2021
## Getting started
*trepka\_etal\_natcomm\_2021* contains the data, code, and output files necessary to generate the figures for the accompanying paper. To generate all figures, clone the repository and run **trepka_etal_natcomm_2021.m**. 

## Data format
Data from each superblock for monkeys and session for mice is formatted as a MATLAB structure named **stats**. The monkey data file is located at *datasets/preprocessed/all_stats_costa* and the mouse data file is located at *datasets/preprocessed/all_stats_cohen*. 

The **stats** structure for both mice and monkeys has the following fields: 
- **r**: an array of length `n_trials`. `stats.r[i] == -1` if the mouse (monkey) choose left (circle) in trial `i`.  `stats.r[i] == 1` otherwise.
- **c**: an array of length `n_trials`. `stats.c[i] == 1` if the animal received a reward in trial `i`.  `stats.c[i] == 1` otherwise.
- **hr_side**: an array of length `n_trials`. `stats.hr_side[i] == -1` if the left (circle) has a higher reward probability than the alternative for the block containing trial `i`.  `stats.hr_side[i] == 1` otherwise.
- **reward_prob**: an array of length `n_trials x 2`. `stats.reward_prob[i,:] == [l,r]` where `l` is the reward probability associated with the left side (circle stimulus) and `r` is the reward probability associated with the right side (square stimulus) for the block containing trial `i`
- **animal_ids**: the identifier for the animal that the data for this session/superblock is from
- **block_addresses**: The `kth` block in the current superblock or session starts at `stats.block_addresses[k]` 
- **block_indices**: similar to block addresses but with indices for each block instead of just start and end trials
- **probXY**: `probXY[k] == 1` if the `kth` block in the current superblock or session has reward schedule `XY`.  `probXY[k] == 0` otherwise.


## Directory organization
├───datasets - *contains data from mice and monkey experiments*
├───figures - *folders for figure output*
├───fit functions - *functions for model fitting*
│   ├───helpers - *fitting and simulation functions*
│   ├───models - *model functions* 
├───helper functions - *functions written for this project and from MATLAB file exchange* 
├───metric functions - *functions to calculate entropy- and behavioral- metrics* 
├───output - *saved intermediate output that can be used to recreate paper figures*
├───plot functions - *functions for plotting each figure in the paper* 

## Using entropy metrics for your research
Checkout the **DartmouthCCNL/EntropyMetrics** repository for a demo notebook that explains how to calculate and use the entropy metric functions.  

