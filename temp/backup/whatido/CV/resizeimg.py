from PIL import Image
import os

def resize_images(input_folder : str, output_folder : str, size : list):
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    for filename in os.listdir(input_folder):
        if filename.endswith(('.png', '.jpg', '.jpeg')):
            img_path = os.path.join(input_folder, filename)
            with Image.open(img_path) as img:
                img = img.resize(size)
                img.save(os.path.join(output_folder, filename))

input_folder = 'test'  # 输入文件夹路径
output_folder = 'test'  # 输出文件夹路径
size = (320, 320)  # 新大小

resize_images(input_folder, output_folder, size)
