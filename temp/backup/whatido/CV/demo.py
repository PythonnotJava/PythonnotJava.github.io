# 中文文档：https://docs.ultralytics.com/zh

from ultralytics import YOLO

# 加载预训练的 YOLO 模型
model = YOLO('yolov8n.pt')

# 自定义训练配置数据集路径和类别
model.train(data='data.yaml', epochs=100, workers=0, device='cpu')


# 进行测试
results = model.predict(source=r'C:\Users\25654\Desktop\whatido\CV\test', save=True)

# 输出结果
for result in results:
    print(result)