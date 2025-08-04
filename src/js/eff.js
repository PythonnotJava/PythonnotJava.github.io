// 博客列表数据
const blogList = [
    {
        title: '高效的Python1',
        content: 'dataclass装饰器、contextmanager上下文管理器、type动态类创建',
        icon: "https://www.devacademy.es/wp-content/uploads/2018/10/python-logo-1024x1024.png",
        link: '../../h5/effpy/EfficientPython1.html'
    },
    {
        title: '高效的Python2',
        content: '更注重于安全性、可维护性等特性的内置类型',
        icon: "https://www.devacademy.es/wp-content/uploads/2018/10/python-logo-1024x1024.png",
        link: '../../h5/effpy/EfficientPython2.html'
    },
    {
        title: '高效的Python3',
        content: '尤其针对3.12版本做出的更新进行学习',
        icon: "https://www.devacademy.es/wp-content/uploads/2018/10/python-logo-1024x1024.png",
        link: '../../h5/effpy/EfficientPython3.html'
    },
    {
        title: '高效的Python4',
        content: 'Python中的高效迭代器学习',
        icon: "https://www.devacademy.es/wp-content/uploads/2018/10/python-logo-1024x1024.png",
        link: '../../h5/effpy/EfficientPython4.html'
    },
    {
        title: '高效的Python3',
        content: '使用标准库进行并发、并行编程',
        icon: "https://www.devacademy.es/wp-content/uploads/2018/10/python-logo-1024x1024.png",
        link: '../../h5/effpy/EfficientPython5.html'
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