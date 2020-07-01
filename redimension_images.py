import os
import cv2 as cv
import numpy as np

RATIO = (16, 9)

DIR = "/home/abeauvisage/Pictures/reddit"
filename = "/home/abeauvisage/Pictures/frisbee_0.jpg"

def get_new_size(img_size):
    dh = (img_size[0] - img_size[1] * RATIO[1]/RATIO[0])/2.0
    if img_size[1] > img_size[0]:
        if dh > 0 and dh/img_size[0] < 0.1:
            return(int(img_size[1] * RATIO[1]/RATIO[0]), img_size[1],
                   int((img_size[0] - img_size[1] * RATIO[1]/RATIO[0])/2.0), 0)
        else:
            return(img_size[0], int(img_size[0]*RATIO[0]/RATIO[1]),
                   0, int((img_size[0]*RATIO[0]/RATIO[1] - img_size[1])/2.0))
    else:
        return (img_size[0], int(img_size[0] * RATIO[0]/RATIO[1]),
                0, int((img_size[0] * RATIO[0]/RATIO[1] - img_size[1])/2.0))

def get_target_size(img_size, new_size):
    zoom_size = np.array(new_size) * (new_size[1]/img_size[1])
    return zoom_size

images = [f for f in os.listdir(DIR) if f.endswith("png") or f.endswith("jpeg")]
for filename in images:
    filename = os.path.join(DIR, filename)
    img = cv.imread(filename)
    img_h, img_w, dh, dw = get_new_size(img.shape)
    print(img_h, img_w, dh, dw)
    if dh > 0 and dh/img_h < 0.1:
        new_img = img[dh:dh+img_h, dw:dw+img_w]
        #  print(new_img.shape[1], new_img.shape[0])
        cv.imwrite(filename, new_img)
    if dw > 0:
        #  print(img.shape, (img_h, img_w))
        ratio = img_w/img.shape[1]
        #  print("ratio {}".format(ratio))
        new_img = cv.resize(img, (int(img.shape[1] * ratio), 
                                  int(img.shape[0] * ratio)))
        #  print(new_img.shape)
        ksize_h = int(new_img.shape[0]/10)
        if ksize_h % 2 != 1:
            ksize_h += 1
        ksize_w = int(new_img.shape[1]/10)
        if ksize_w % 2 != 1:
            ksize_w += 1
        new_img = cv.GaussianBlur(new_img, (ksize_h, ksize_w),
                                  int(new_img.shape[0]/100.0),
                                  int(new_img.shape[1]/100.0))

        dh  = int((new_img.shape[0]-img.shape[0])/2.0)
        dw  = int((new_img.shape[1]-img.shape[1])/2.0)
        new_img[dh:dh+img.shape[0],dw:dw+img.shape[1]] = img
        new_img = new_img[dh:dh+img.shape[0], :]

        #  cv.namedWindow(filename, 0)
        #  cv.imshow(filename, new_img)
        #  print(img.shape[0]/img.shape[1])
        #  print(filename)
        #  cv.waitKey()

        cv.imwrite(filename, new_img)
