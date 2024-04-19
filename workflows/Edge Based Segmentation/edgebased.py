import skimage as ski
from skimage.exposure import histogram
import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
import sys

output_location = sys.argv[1]

coins = ski.data.coins()
hist, hist_centers = ski.exposure.histogram(coins)

edges = ski.feature.canny(coins / 255.)

fill_coins = sp.ndimage.binary_fill_holes(edges)

label_objects, nb_labels = sp.ndimage.label(fill_coins)
sizes = np.bincount(label_objects.ravel())
mask_sizes = sizes > 20
mask_sizes[0] = 0
coins_cleaned = mask_sizes[label_objects]


plt.imshow(coins_cleaned, cmap="gray")
plt.axis('off')
plt.savefig(output_location)
plt.close()
