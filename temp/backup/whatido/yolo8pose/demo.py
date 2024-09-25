from ultralytics import YOLO
import ultralytics.engine.results

# 加载 YOLOPose 模型
model = YOLO('yolov8n-pose')  # 那个yolov8n-pose.pt是本地版本，其实库里面内置了

# 进行推理
results : ultralytics.engine.results.Results = model('a.jpg')[0]  # 传入你的图片路径
results.save('result.png')
