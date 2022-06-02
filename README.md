# _Rien de Nouveau chez Rimbaud_

According to [Eddie Breuil, _Du nouveau chez Rimbaud_ 2014](https://www.honorechampion.com/fr/champion/9075-book-08532889-9782745328892.html), [A. Rimbaud](https://en.wikipedia.org/wiki/Arthur_Rimbaud) is only the copist of the [_Illuminations_](https://en.wikipedia.org/wiki/Illuminations_(poetry_collection)): the author is [Germain Nouveau](https://en.wikipedia.org/wiki/Germain_Nouveau).

The experiment we have conducted shows that this hypothesis is wrong, and that Rimbaud is the author of the _Illuminations_.

## 1. Data

Transcriptions come from _Wikisource_ and the _Gutenberg project_.

The corpora are in the `train` and `unseen` repository.
1. `train` contains the `unbalanced` (data gathered for the first experience, not all the authors have the same amount of words), `balanced` (all the authors have the same amount of words) and `max` (whenever possible, we have doubled the amount of words, but not for Rimbaud, whose corpus is too small) corpora.
2. `unseen` contains the out-of-domain data (`attributed_poems`) and the _Illuminations_ (`debated_poems`)

## 2. How to

### 2.1. Install SuperStyle

You need to install [SuperStyle](https://github.com/SupervisedStylometry/SuperStyl).

With Python 3.8 (defaul installation)

```console
source install/310.sh
```

With Python 3.10 (it happens if you have a mac):

```console
source install/310.sh
```

Or manually:

```console
git clone https://github.com/SupervisedStylometry/SuperStyl.git
cd SuperStyl
virtualenv -p python3.8 env
source env/bin/activate
pip install -r requirements.txt
# And get the model for language prediction
mkdir superstyl/preproc/models
wget https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin -P ./superstyl/preproc/models/
```

### 2.2. Run the analysis

**STEP 1**: Benchmark for the best configuration, for instance
```console
source 1a_balanced_benchmark_cross.sh
```
You have several scripts performing different tests. The name of the script helps you understand which test does what.

1. `balanced`, `max`, and `unbalanced` refer to the different corpora
2. `cross` and `test` refer to the test method: cross-validation or an out-of-domain test set. `global perform both` but results might be hard to read


**STEP 2**: produce the coefficients for the best configuration. They will be stored in the `SuperStyl` repository.

```console
source 2_best_config.sh
```

**STEP 3**: test on unseen data, _i.e._ the _Illuminations_:

```console
source 3_test_unseen.sh
```

**STEP 4**: perform a rolling analysis on the  _Illuminations_. The final graph is stored in the `SuperStyl` repository.

```console
source 4_rolling.sh
```

## 3. Cite

Simon Gabay, _rien de Nouveau chez Rimbaud_, 2022, Github, https://github.com/gabays/Rimbaud

## 4. Licence

CC-BY, except data from _Wikisource_ (BY-SA, cf. [here](https://foundation.wikimedia.org/wiki/Terms_of_Use/en).). For the _Gutenberg project_, see [here](https://www.gutenberg.org/policy/license.html).

## 5. Acknowledgments

Thank you to JB Camps (ENC|PSL), L. Jenny (UniGE), L. Gonon (Uni Rouen-Normandie).
