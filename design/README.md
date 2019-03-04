# Word stimuli for fLOC

144 words and pseudowords for the fLoc task.

Words were selected from the Educator's Word Frequency Guide (EWFG) using  `select_words.R` to have the following characteristics:

- 3-6 letters
- Frequent in grade 1 texts (> 10 occurences per million)
- Occurs as a noun (based on ELP)
- Monomorphemic (based on ELP)
- Monosyllablic (based on ELP)
- High imageability (>300 from MRC)

Words were randomly assigned to 12 blocks of 12 stimuli, attempting to minimize between block variability in number of letters, orthographic neighborhood, phonological neighborhood, concreteness, imageability, and number of phonemes.

For each word, a corresponding pseudoword was selected from the ARC nonword database having the same number of letters, phonemes, and a Levenshtein distance of 1.

