// 博客列表数据
    const blogList = [
      {
        title: 'PyQt5（1）',
        content: 'PyQt5系列入门教程',
        icon: 'https://i0.wp.com/clay-atlas.com/wp-content/uploads/2019/08/Python_PyQt5.png?resize=982%2C1024&ssl=1',
        link: '../../h5/qt/blogPyQt5.html'
      },
      {
        title: 'PyQt5（2）',
        content: 'PyQt5系列进阶教程',
        icon: 'https://i0.wp.com/clay-atlas.com/wp-content/uploads/2019/08/Python_PyQt5.png?resize=982%2C1024&ssl=1',
        link: '../../h5/qt/blogPyQt5Depth.html'
      },
      {
        title: 'DCQT',
        content: '对PyQt5的封装，便于我自己的需求',
        icon: 'https://i0.wp.com/clay-atlas.com/wp-content/uploads/2019/08/Python_PyQt5.png?resize=982%2C1024&ssl=1',
        link: '../../h5/qt/DCQT.html'
      }
    ];

    const blogListContainer = document.getElementById('blogListContainer');

    // 初始化博客列表
    function initBlogList() {
  blogListContainer.innerHTML = '';
  blogList.forEach(blog => {
    const blogCard = document.createElement('div');
    blogCard.className = 'blog-card';
    // 添加链接
    const link = document.createElement('a');
    link.href = blog.link;
    // 创建博客图标元素
    const icon = document.createElement('img');
    icon.className = 'blog-icon';
    icon.src = blog.icon;
    // 创建博客内容元素
    const content = document.createElement('div');
    content.className = 'blog-content';
    // 创建博客标题元素
    const title = document.createElement('div');
    title.className = 'blog-title';
    title.textContent = blog.title;
    // 创建博客描述元素
    const description = document.createElement('div');
    description.className = 'blog-description';
    description.textContent = blog.content;
    // 将元素添加到DOM中
    content.appendChild(title);
    content.appendChild(description);
    link.appendChild(icon);
    link.appendChild(content);
    blogCard.appendChild(link);
    blogListContainer.appendChild(blogCard);
  });
}
// 搜索功能
function searchBlog() {
  const keyword = document.getElementById('searchInput').value;
  const blogCards = document.getElementsByClassName('blog-card');
  Array.from(blogCards).forEach(blogCard => {
    const title = blogCard.querySelector('.blog-title').textContent; // 获取标题文本内容
    const description = blogCard.querySelector('.blog-description').textContent; // 获取描述文本内容
    if (title.includes(keyword) || description.includes(keyword)) {
      blogCard.style.display = 'flex';
      // 关键字高亮显示
      const regex = new RegExp(`(${keyword})(?![^<]*>|[^<>]*<\/a>)`, 'gi');
      blogCard.innerHTML = blogCard.innerHTML.replace(regex, '<span class="highlight">$1</span>');
      // console.log(blogCard.innerHTML);
    } else {
      blogCard.style.display = 'none';
    }
  });
}


    // 返回按钮功能
    function returnToAllBlogs() {
      const blogCards = document.getElementsByClassName('blog-card');
      Array.from(blogCards).forEach(blogCard => {
        blogCard.style.display = 'flex';
        blogCard.innerHTML = blogCard.innerHTML.replace('<span class="highlight">', '').replace('</span>', '');
      });
    }

    // 添加搜索按钮点击事件
    document.getElementById('searchButton').addEventListener('click', searchBlog);

    // 添加回车键事件，触发搜索功能
    document.getElementById('searchInput').addEventListener('keydown', (event) => {
      if (event.key === 'Enter') {
        searchBlog();
      }
    });

    // 添加返回按钮点击事件
    document.getElementById('returnButton').addEventListener('click', returnToAllBlogs);

    // 初始化博客列表
    initBlogList();