// 博客列表数据
    const blogList = [
      {
        title: 'Gurobi单变量非线性优化问题',
        content: 'Gurobi单变量非线性优化问题的几种改进快速计算的方法',
        icon: 'https://www.go-soft.cn/static/upload/image/20230310/1678433049669047.jpg',
        link: '../../h5/other/Gurobi单变量非线性优化问题.html'
      },
      {
        title: 'Matplotlib',
        content: 'Matplotlib超详细的入门教程，几乎涵盖所有基础内容',
        icon: 'https://files.realpython.com/media/python-plotting-matplotlib.7b528c0f5f0b.jpg',
        link: '../../h5/other/blogMatplotlib.html'
      },
      {
        title: 'Dart快速入门',
        content: '从基本数据类型到面向对象快速入门Dart编程',
        icon: 'https://img.quanxiaoha.com/quanxiaoha/164839133079354',
        link: '../../h5/other/Dart语言快速入门.html'
      },
      {
        title: 'Dart快速入门（2）',
        content: '从基本数据类型到面向对象快速入门Dart编程（2）',
        icon: 'https://img.quanxiaoha.com/quanxiaoha/164839133079354',
        link: '../../h5/other/Dart快速入门（2）.html'
      },
      {
        title: 'Dart高级教程',
        content: '快速入门一些Dart的高级语法以及语法糖（附源代码下载链接）',
        icon: 'https://img.quanxiaoha.com/quanxiaoha/164839133079354',
        link: '../../h5/other/Dart高级教程.html'
      },
      {
        title: 'Dart同步操作文件',
        content: 'Dart同步操作文件的一些方法的学习',
        icon: 'https://img.quanxiaoha.com/quanxiaoha/164839133079354',
        link: '../../h5/other/Dart同步操作文件.html'
      },
      {
        title: '自定义Flutter的构建',
        content: '自定义Flutter模板',
        icon: 'https://img.quanxiaoha.com/quanxiaoha/164839133079354',
        link: '../../h5/other/自定义Flutter的构建.html'
      },
      {
        title: 'C#入门笔记',
        content: 'C#入门笔记，基于.net 8.0',
        icon: 'https://th.bing.com/th?id=OSK.GhOfIXkD4m2VC8BFLppZ1d0-SeI8Fj5pLmObRQzFIyY&w=102&h=102&c=7&o=6&dpr=1.3&pid=SANGAM',
        link: '../../h5/other/C-sharp入门笔记.html'
      },
    ];

    const blogListContainer= document.getElementById('blogListContainer');

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
