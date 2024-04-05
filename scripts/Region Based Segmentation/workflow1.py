import skimage as ski
from skimage.exposure import histogram
import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
coins = ski.data.coins()
hist, hist_centers = ski.exposure.histogram(coins)


markers = np.zeros_like(coins)
markers[coins < 30] = 1
markers[coins > 150] = 2
elevation_map = ski.filters.sobel(coins)

segmentation = ski.segmentation.watershed(elevation_map, markers)

segmentation = sp.ndimage.binary_fill_holes(segmentation - 1)

plt.imshow(segmentation, cmap='gray')
plt.axis('off')
plt.title("Segmentation")
plt.savefig("region_based.png")
plt.close()
