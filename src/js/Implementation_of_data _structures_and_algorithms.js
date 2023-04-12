// 博客列表数据
    const blogList = [
      {
        title: '串结构',
        content: 'C++面向对象实现串，使用顺序存储的存储结构（附源代码）',
        icon: 'https://tse3-mm.cn.bing.net/th/id/OIP-C.31vNg59mc0tJYE07qp_8ygHaCX?w=314&h=111&c=7&r=0&o=5&dpr=1.4&pid=1.7',
        link: '../../h5/sjjg/C++面向对象实现串，使用顺序存储的存储结构（附源代码）.html'
      },
      {
        title: '邻接表图',
        content: '基于C++实现邻接表来表示图结构',
        icon: 'https://ts1.cn.mm.bing.net/th/id/R-C.8120cd354de7f107e88f25d41be15540?rik=82jalkofwWVAIQ&riu=http%3a%2f%2fimage.mamicode.com%2finfo%2f201901%2f20190128195839913108.png&ehk=tYOlVwqstfAfIQ3lIg2VNrq1Ct%2fPCfGOHdRH2PCX81A%3d&risl=&pid=ImgRaw&r=0',
         link: '../../h5/sjjg/C++实现邻接表来表示图结构（附源代码）.html'
      },
      {
        title: '可视化二叉树',
        content: 'C++顺序存储实现二叉树并可视化（附源代码）',
        icon: 'https://pic3.zhimg.com/v2-400b251b664b915d44eca03351b1177a_r.jpg',
         link: '../../h5/sjjg/C++顺序存储实现二叉树并可视化（附源代码）.html'
      },
      {
        title: '顺序栈',
        content: '基于C++的顺序栈的实现（附源代码）',
        icon: 'https://www.maxing128.com/wp-content/uploads/2017/10/SqStackPush.png',
         link: '../../h5/sjjg/C++顺序栈的实现.html'
      },
      {
        title: '邻接矩阵-图',
        content: '基于C++实现邻接矩阵表示的图结构（附源代码）',
        icon: 'https://sslprod.oss-cn-shanghai.aliyuncs.com/stable/slides/kaqmsk/kaqmsk_1440-28.jpg',
         link: '../../h5/sjjg/基于C++实现邻接矩阵表示的图结构（附源代码）.html'
      },
      {
        title: '矩阵与行列式',
        content: 'C++面向对象实现矩阵（包含行列式）的一些操作（附源代码）',
        icon: 'https://picb.zhimg.com/v2-5eca2d0aef85eb65be9180515e7cdddd_r.jpg',
         link: '../../h5/sjjg/C++面向对象实现矩阵（包含行列式）的一些操作（附源代码）.html'
      },
      {
        title: '多项式',
        content: '基于C++顺序存储实现多项式操作',
        icon: 'https://pic3.zhimg.com/v2-499e0b5a82d3e59ee0c9e949f15c8ea6_r.jpg',
         link: '../../h5/sjjg/C++面向对象+顺序表实现多项式的一些基本操作（附源代码）.html'
      },
      {
        title: '带头结点的单链表',
        content: 'C++面向对象技术实现带头结点的单链表',
        icon: 'https://ts1.cn.mm.bing.net/th/id/R-C.ba9cee382124e480954a107f58a914af?rik=fBHuGF6gPq0gpw&riu=http%3a%2f%2fbbs.yanzhishi.cn%2fimage%2fshow%2fattachments-2020-06-R4dmYSKD5edf4d0085a27.png&ehk=wvVRU90U3a4PIjy6LfqyxK7PbvEfFxwa49BJuzl8zAA%3d&risl=&pid=ImgRaw&r=0',
         link: '../../h5/sjjg/C++面向对象技术实现带头结点的单链表.html'
      },
      {
        title: '链栈',
        content: '基于C++链栈的实现（附源代码）',
        icon: 'https://www.yht7.com/upload/image/2021/05/20/2021520101811926.png',
        link: '../../h5/sjjg/C++链栈的实现（附源代码）.html'
      },
      {
        title: '顺序存储-队列',
        content: '基于C++面向对象技术实现顺序队列',
        icon: 'https://pic4.zhimg.com/80/v2-cf1c5c40578f002a8480b3475ce36a63_qhd.jpg',
        link: '../../h5/sjjg/基于C++面向对象技术实现顺序队列（附源代码）.html'
      },
      {
        title: '顺序存储-线性表',
        content: 'C++实现顺序线性表（附源代码）',
        icon: 'https://pic4.zhimg.com/v2-ef9c513a7a4f197144321a9c79697dbb_b.png',
        link: '../../h5/sjjg/C++实现顺序线性表（附源代码）.html'
      },
      {
        title: '链式存储-二叉树',
        content: 'C++链式存储实现二叉树（附源代码）',
        icon: 'https://tse2-mm.cn.bing.net/th/id/OIP-C.4wnL0Y7nHnbT0i9PrwNvQQHaEl?pid=ImgDet&rs=1',
        link: '../../h5/sjjg/C++链式存储实现二叉树（附源代码）.html'
      },
      {
        title: '十字链表表示有向图',
        content: 'C++实现十字链表来表示有向图（附源代码）',
        icon: 'https://www.jxtxzzw.com/wp-content/uploads/2018/01/20170222122117558-1920x1314.jpg',
        link: '../../h5/sjjg/C++实现十字链表来表示有向图（附源代码）.html'
      },
      {
        title: '深度搜索算法',
        content: '使用C++，基于邻接矩阵实现深度优先算法（附源代码）',
        icon: 'https://imgconvert.csdnimg.cn/aHR0cHM6Ly91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW8vdXBsb2FkX2ltYWdlcy85NDA2Mjk5LWQ4Y2E5ODQ2MjMzNGRhOWIucG5n?x-oss-process=image/format,png',
        link: '../../h5/sjjg/使用C++，基于邻接矩阵实现深度优先算法（附源代码）.html'
      },
      {
        title: 'Prim算法',
        content: '基于C++无向网邻接表实现Prim算法(附源代码)',
        icon: 'https://pic4.zhimg.com/80/v2-b589c7cd61067b56b2ee886329916207_720w.webp',
        link: '../../h5/sjjg/基于C++无向网邻接表实现Prim算法(附源代码).html'
      },
      {
        title: '二维数组',
        content: '基于C语言动态的创建二维数组，可以自动扩容并且获取每行长度',
        icon: 'https://imgconvert.csdnimg.cn/aHR0cDovL2ltZy5ibG9nLmNzZG4ubmV0LzIwMTcxMDI1MTk1OTA0MjQ0?x-oss-process=image/format,png',
        link: '../../h5/sjjg/基于C语言动态的创建二维数组，可以自动扩容并且获取每行长度.html'
      }
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
