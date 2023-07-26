<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>博客列表</title>
  <style>
    /* 搜索框样式 */
    .search-container {
      margin-bottom: 20px;
      text-align: center;
    }

    .search-input {
      width: 400px;
      padding: 5px;
      margin-right: 10px;

    }
  /* 返回按钮样式 */
    .return-button {
      padding: 5px;

    }
    .search-button {
      padding: 5px;
    }

    /* 外部容器样式 */
    .blog-list-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      align-items: flex-start;
    }

    /* 博客卡片样式 */
    .blog-card {
      width: calc(50% - 20px);
      margin: 10px;
      padding: 20px;
      background-color: #f0f0f0;
      /*box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);*/
      display: flex;
      align-items: center;
      border-radius: 10px;
box-shadow: 0 0 5px 5px #fff;
      transition: transform .3s;
    }

    /* 左侧图标样式 */
    .blog-icon {
      float: left;
      margin-bottom: 20px;
      width: 120px;
        border-radius: 15px;
      height: 120px;
    }

    /* 右侧内容样式 */
    .blog-content {
      flex-grow: 1;
      float: left;
      padding-left: 10px;
      color: darkblue;
    }

    /* 标题样式 */
    .blog-title {
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 10px;
    }

    /* 内容样式 */
    .blog-description {
      font-size: 14px;
      color: #777;
    }

    /* 关键字高亮样式 */
    .highlight {
      background-color: yellow;
      font-weight: bold;
    }
    body {
      background-color: tan;
    }
  </style>
</head>
<body>
  <div class="search-container">
    <input type="text" class="search-input" id="searchInput" placeholder="输入关键字搜索博客">
    <button class="search-button" id="searchButton">搜索</button>
    <button class="return-button" id="returnButton">返回</button>
  </div>
  <div class="blog-list-container" id="blogListContainer"></div>
<script src="../../js/Implementation_of_data%20_structures_and_algorithms.js">
</script>
</body>
</html>
