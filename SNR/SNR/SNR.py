import cv2
import matplotlib.pyplot as plt
import numpy as np
import math
import random
import os

BATCH_PATH = "..\\..\\dataset T3i_Aligned\\T3i_Aligned\\Batch_"

BATCH_NUMBER = "001"
REFERENCE_IMAGE_NAME = "IMG_7796Reference.bmp"
CLEAN_IMAGE_NAME = "IMG_7799full.bmp"
NOISY_IMAGE_NAME = "IMG_7798Noisy.bmp"

def CalculatePSNR(image1, image2):

	height, width, channels = image1.shape
	print(image1.shape)

	image1_f = np.float32(image1)
	image2_f = np.float32(image2)

	b1, g1, r1 = cv2.split(image1_f)
	b2, g2, r2 = cv2.split(image2_f)

	mse_b = abs(b1 - b2) ** 2
	mse_g = abs(g1 - g2) ** 2
	mse_r = abs(r1 - r2) ** 2	

	mse_b = sum(sum(mse_b)) / (height * width)
	mse_g = sum(sum(mse_g)) / (height * width)
	mse_r = sum(sum(mse_r)) / (height * width)

	mse = (mse_b + mse_g + mse_r) / 3;
	
	psnr = 10.0 * math.log10(255.0 * 255.0 / mse)
	print(psnr)
	
	'''	
	#cv2.imshow("Image 1", image1)
	#cv2.waitKey(0)
	'''

def CalculatePSNR(refImage, noisyImage, cleanImage):

	height, width, channels = refImage.shape
	
	refChannels = cv2.split(refImage)
	noisyChannels = cv2.split(noisyImage)
	cleanChannels = cv2.split(cleanImage)

	channelSum = 0.0
	for channel in range(0, 3):
		
		refTemp = np.float32(refChannels[channel])
		noisyTemp = np.float32(noisyChannels[channel])
		cleanTemp = np.float32(cleanChannels[channel])
		
		avg = (refTemp + cleanTemp) / 2
		noisy = noisyTemp - avg
		full = refTemp - cleanTemp

		varRef = np.var(full) / 4
		varNoisy = max(np.var(noisy) - varRef, 0)

		channelSum += varNoisy

	result = math.sqrt(channelSum / 3)
	result = 20 * math.log10(255 / result)

	return round(result, 3)

def Plot(psnrValue):

	# samo za test
	graphData = []
	for x in range(0, 256):
		graphData.append(random.uniform(-20, 20))
	
	plotTitle = "PSNR: " + str(psnrValue)
	plt.figure(num = NOISY_IMAGE_NAME + " graph")
	plt.subplots_adjust(hspace = 0.3)
	plt.subplot(311)
	plt.title(plotTitle)
	plt.plot(graphData, "r.")
	plt.plot([0, 255], [20, 20], "k--")
	plt.plot([0, 255], [-20, -20], "k--")

	plt.subplot(312)
	plt.plot(graphData, "g.")

	plt.subplot(313)
	plt.plot(graphData, "b.")

	plt.savefig('testplot.png')
	plt.show()

# main

path1 = os.path.join((BATCH_PATH + BATCH_NUMBER + "\\"), REFERENCE_IMAGE_NAME)
path2 = os.path.join((BATCH_PATH + BATCH_NUMBER + "\\"), NOISY_IMAGE_NAME)
path3 = os.path.join((BATCH_PATH + BATCH_NUMBER + "\\"), CLEAN_IMAGE_NAME)

image1 = cv2.imread(path1)
image2 = cv2.imread(path2)
image3 = cv2.imread(path3)
print(path1 + "\n" + path2 + "\n" + path3)

#CalculatePSNR(image2, image1)
psnr = CalculatePSNR(image1, image2, image3)
print(psnr)

Plot(psnr)
