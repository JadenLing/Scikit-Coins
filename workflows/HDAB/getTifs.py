import os,sys
import argparse

def main(argv):
    parser = argparse.ArgumentParser(description="Find tifs for batch process")
    parser.add_argument("Base File Path", help='Base directory to traverse')
    parser.add_argument("-o", "--Output", help="Output filename")
    args = parser.parse_args()
    input_args = vars(args)
    base_path = input_args["Base File Path"]
    output_filename = input_args["Output"]
    flist = []
    for root, dirs, files in os.walk(base_path):
        for name in files:
            if name.endswith('tif'):
                flist.append(os.path.join(root, name))


    if output_filename:
        pass
    else:
        output_filename = 'images.list'
    with open(output_filename, 'w+') as f:
        for l in flist:
            print(l, file=f)

    print ('%i files listed in %s' % (len(flist),output_filename))


if __name__ == "__main__":
    main(sys.argv[1:])




