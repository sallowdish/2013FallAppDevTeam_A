from PIL import Image
import sys
import os

os.chdir=str(sys.argv[1]);
print os.getcwd()
filelist=sys.argv[2:];

for filename in filelist:
	filename=str(filename)
	print filename
	img = Image.open(filename)
	img = img.convert("RGBA")
	datas = img.getdata()
	newData = []
	for item in datas:
	    if item[0] > 240 and item[1] >240  and item[2] >240:
	        newData.append((255, 255, 255, 0))
	    else:
	        newData.append(item)
	img.putdata(newData)
	filename=filename.split(".png")[0]
	img.save(filename+"_done.png", "PNG")