import cv2
import glob
import os

size = 512

# Add yours
DATASET_PATH = "/Users/lbasek/Desktop/NOS/T3i_Aligned/"

batch_list = os.listdir(DATASET_PATH)
batch_list = [item for item in batch_list if "Batch" in item]

# create dataset directory
os.makedirs("dataset", exist_ok=True)
batch = 1

for i in sorted(batch_list):
    if os.path.isdir(DATASET_PATH + i):
        tmp_dir = "dataset/batch" + str(batch)
        os.makedirs(tmp_dir, exist_ok=True)
        batch = batch + 1
        for filename in glob.glob(DATASET_PATH + i + '/*.bmp'):
            if "Mask" not in filename:
                image_name = filename.split("/")[-1]
                img = cv2.imread(filename)
                height, width = img.shape[:2]
                cropped = img[int(height / 2):int(height / 2) + size, int(width / 2):int(width / 2) + size]
                if "Reference" in image_name:
                    cv2.imwrite(os.path.join(tmp_dir, "reference.bmp"), cropped)
                elif "Noisy" in image_name and not os.path.isfile(DATASET_PATH + i + '/noisy.bmp'):
                    cv2.imwrite(os.path.join(tmp_dir, "noisy.bmp"), cropped)
                elif "full" in image_name:
                    cv2.imwrite(os.path.join(tmp_dir, "clean.bmp"), cropped)
