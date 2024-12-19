#!/usr/bin/env python3
import os
import exifread
from PIL import Image
import matplotlib.pyplot as plt
import sys
import numpy as np

Image.MAX_IMAGE_PIXELS = None  
def get_focal_length_and_pixels(image_path):
    try:
        with open(image_path, 'rb') as f:
            tags = exifread.process_file(f)
            
        focal_length = None
        if 'EXIF FocalLength' in tags:
            focal_length = tags['EXIF FocalLength']
            
        img = Image.open(image_path)
        width, height = img.size
        total_pixels = width * height
        
        if focal_length:
            focal_length = float(focal_length.values[0])  # EXIF返回的是一个比例
            coefficient = total_pixels / 45441024
            result = int( focal_length/coefficient)
            return result
        else:
            return None
    except Exception as e:
        print(f"can not process {image_path}: {e}")
        return None
    
def traverse_directory(directory):
    focal_lengths = []
    
    for root, dirs, files in os.walk(directory):
        print(f"processing directory: {root}")
        print(f"file: {files}")
        
        for file in files:
            # 检查是否是 .jpg 或 .jpeg 文件
            if file.lower().endswith(('.jpg', '.jpeg')):
                image_path = os.path.join(root, file)
                print(f"processing: {image_path}")
                result = get_focal_length_and_pixels(image_path)
                if result is not None:
                    focal_lengths.append(result)
                    
    return focal_lengths

import numpy as np
import matplotlib.pyplot as plt

def plot_histogram(focal_lengths):
    min_val = min(focal_lengths)
    max_val = max(focal_lengths)
    

    plt.hist(focal_lengths, bins=30, edgecolor='black') 
    plt.title('Histogram')
    plt.xlabel('Adjusted Focal Length')
    plt.ylabel('Frequency')
    
    custom_ticks = [10, 16, 24, 35, 50, 85, 105, 120, 200]
    plt.xticks(custom_ticks)  # 设置刻度为自定义的值
    plt.show()
    
    
def main():
    if len(sys.argv) != 2:
        print("Provide a valid directory")
        sys.exit(1)
        
    directory = sys.argv[1]
    focal_lengths = traverse_directory(directory)
    
    if focal_lengths:
        plot_histogram(focal_lengths)
    else:
        print("No .jpg found")
        
if __name__ == '__main__':
    main()
    