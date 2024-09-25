# 方法一：看代码
```python
from ultralytics import YOLO
import ultralytics.engine.results

# 加载 YOLOPose 模型
model = YOLO('yolov8n-pose.pt')

# 进行推理
results : ultralytics.engine.results.Results = model('a.jpg')[0]  # 传入你的图片路径
results.save('result.png')

```

# 方法二：终端命令行一键生成
yolo pose predict model=yolov8n-pose.pt source=a.jpg

> 注：你可以直接双击我给你的run.bat自动化（前提是切换到完整的ultralytics环境）
