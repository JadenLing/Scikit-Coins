import time
import sys, argparse
import os

from aicsimageio import AICSImage
import skimage
from stardist.models import StarDist2D
from skimage.color import label2rgb

def main(argv):
    parser = argparse.ArgumentParser(description="Count cells in DAB image")
    parser.add_argument("Input File Path", help = 'image to process')
    parser.add_argument("-o", "--Output", help="Define output directory")
    parser.add_argument("-t","--tile",help="Do single tile",type=int)
    parser.add_argument('--debug','-d',action='store_true')

    args = parser.parse_args()

    input_args = vars(args)

    test_image_fpath = input_args["Input File Path"]
    parent,fname = os.path.split(test_image_fpath)

    debug_mode = input_args["debug"]
    outpath = input_args["Output"]
    tile = input_args["tile"]

    if tile:
        assert tile >= 0 and tile < 9, "Tile should be between 0,8"
    else:
        print ("Will perform analysis on all 9 tiles")

    if outpath != None :
        print ( "Output dir is %s " % outpath)
        assert os.path.isdir(outpath), "Output not a directory"
    else:
        outpath,child = os.path.split(test_image_fpath)
        print ("Output dir not defined, defaulting to %s " % outpath)
        if os.path.isdir(outpath):
            print ("And is a directory")
        else:
            print ("Is not a directory")

    if(debug_mode):
        print("fpath = %s " % test_image_fpath)

    start = time.time()
    full_image = AICSImage(test_image_fpath)
    full_image = full_image.get_image_dask_data("YXS", T=0, C=0, Z=0)
    YSize, XSize, CSize = full_image.shape
    splitInto = 8 #this was previously 3,then 4, then 5 but had memory issues
    xTileSize = int(XSize / splitInto)
    yTileSize = int(YSize / splitInto)

    if tile:
        #IF tile is defined, just do one tile
        tileNum = tile
        x = int(tile/splitInto)
        y = int(tile%splitInto)
        print("Tile = %i" % tile)
        print("x = %i" % x)
        print("y = %i" % y)

        roi_y0 = y * yTileSize
        roi_x0 = x * xTileSize
        roi_y1 = roi_y0 + yTileSize
        roi_x1 = roi_x0 + xTileSize
        im = full_image[roi_y0:roi_y1, roi_x0:roi_x1]

        totalCells, posCells = processImage(im)


        output_fpath = os.path.join(outpath,fname+"_tile"+str(tileNum)+".txt")
        with open(output_fpath,'w') as f:
            f.write("%s, %i, %i, %i" % (test_image_fpath,tileNum,totalCells,posCells))

        print("Results in %s " % output_fpath)

    else:
        #If tile is not defined do every tile (can take upwards of an hour)
        tileNum = 0

        for x in range(0, splitInto):
            for y in range(0, splitInto):
                output_fpath = os.path.join(outpath, fname + "_tile" + str(tileNum) + ".txt")

                if os.path.exists(output_fpath):
                    print("Tile_%i has been done, skipping" % tileNum)

                else:
                    roi_y0 = y * yTileSize
                    roi_x0 = x * xTileSize
                    roi_y1 = roi_y0 + yTileSize
                    roi_x1 = roi_x0 + xTileSize
                    im = full_image[roi_y0:roi_y1, roi_x0:roi_x1]

                    totalCells, posCells = processImage(im)

                    with open(output_fpath, 'w') as f:
                        f.write("%s, %i, %i, %i" % (test_image_fpath, tileNum, totalCells, posCells))
                    print("Results in %s " % output_fpath)

                tileNum += 1

    end = time.time()
    print(end - start)



def processImage(im):
    # create psuedo fluoro
    # im2 = skimage.color.rgb2gray(im)
    im2 = skimage.util.invert(im)

    # define model
    model = StarDist2D.from_pretrained('2D_versatile_fluo')

    # predict on big region
    try:
        labels, _ = model.predict_instances_big(im2, axes='YX', block_size=2048, min_overlap=128, context=128,
                                            show_progress=True)

        # colour deconvolve
        im3 = skimage.color.rgb2hed(im)
        dab = im3[:, :, 2]
        blue = im3[:, :, 0]

        # measure intensities on colours
        res = skimage.measure.regionprops(labels, intensity_image=dab)
        blueres = skimage.measure.regionprops(labels, intensity_image=blue)

        # filter for blue signal
        x = [d for d, b in zip(res, blueres) if d.area > 200 and b.intensity_mean > 0.020]
        totalCells = len(x)

        p = [d for d, b in zip(res, blueres) if d.area > 200 and d.intensity_mean > 0.02 and b.intensity_mean > 0.020]
        posCells = len(p)
    except:
        #if stardist fails
        print("STARDIST FAILURE CHECK THIS FILE")
        totalCells = 0
        posCells = 0

    return totalCells, posCells

if __name__ == "__main__":
    main(sys.argv[1:])





