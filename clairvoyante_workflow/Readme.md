# Build a new convolution network model for Clairvoyante

There are three subdirectories that can genenete workflow and applets on 
DNAnexus platform for reproduce the Clairvoyante paper:

- For preparing training data:  `cv_prepare_training_data_WDL`
- For training the CNN model using the training data: `cv_training`
- Making variant call with the trained model: `cv_variant_calling`

While it needs DNAnexus platform to deploy these models, the code inside
the description of the workflows and applets is general and may help other 
researcher to reproduce results on any platform.


Reference:

Clairvoyante: a multi-task convolutional deep neural network for variant calling in Single Molecule Sequencing
Ruibang Luo, Fritz J Sedlazeck, Tak-Wah Lam, and Michael Schatz

https://www.biorxiv.org/content/early/2018/04/28/310458


Other introduction for using CNN with alignment tensors for calling genomic variants:

https://towardsdatascience.com/simple-convolution-neural-network-for-genomic-variant-calling-with-tensorflow-c085dbc2026f
https://github.com/cschin/VariantNET


