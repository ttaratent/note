参考引用：[B树详解](https://www.cnblogs.com/lwhkdash/p/5313877.html)    
[经典数据结构B树与B+树](https://www.cnblogs.com/vincently/p/4526560.html)    
[B树百度百科](https://baike.baidu.com/item/B%E6%A0%91/5411672)    
B树以及其变形结构，常用于数据库系统的存储，B树是一种多叉平衡查找树，在于读写方面性能更好一点。    
B树允许每个节点有M-1个子节点（M为B树的阶数）
其中[经典数据结构B树与B+树](https://www.cnblogs.com/vincently/p/4526560.html)说：
* 根节点至少有两个子节点
* 每个节点有M-1个Key，并且以升序排列
* 位于M-1和M key的子节点的值位于M-1和M key对应的Value之间
* 其他节点至少有M/2个子节点

其中[B树百度百科](https://baike.baidu.com/item/B%E6%A0%91/5411672)中的定义：（┌m/2┐为对m/2进行向上取整）
* 根节点至少有两个子女
* 每个非根节点所包含的关键字个数j满足：┌m/2┐-1 <= j <= m-1;
* 除根节点以外的所有节点（不包括叶子节点）的度数正好是关键字总数加1，故内部子树个数k满足：┌m/2┐ <= k <=m
* 所有的叶子节点都位于同一层
在B树中，每个节点中关键字从小到大排列，并且当该节点的孩子是非叶子节点时，该k-1个关键字正好是k个孩子包含的关键字的值域的分划。    
因为叶子节点不包含关键字，所以可以把叶子节点看成在树里实际上并不存在外部节点，指向这些外部节点的指针为空，叶子节点的数目正好等于树中所包含的关键字总个数加1。    
B树中的一个包含n个关键字，n+1个指针的节点的一般形式为：(n,P0,K1,P1,K2,P2,...,Kn,Pn)    
其中，Ki为关键字，K1<K2<...<Kn，Pi是指向包括Ki到Ki+1之间的关键字的子树的指针。

B树本身每个节点是由Key和Value组成的。

![B树的构建](../images/btreebuild.gif)

B树的添加与删除：[B树和B+树的插入、删除图文详解](http://www.cnblogs.com/nullzx/p/8729425.html)

B树的删除，当删除叶子节点Key时，直接删除，且若节点为空则删除该节点，若删除非叶子节点Key时，使用其后继Key替换该Key后再进行删除。

B树的查找，多路进行查找，直到匹配或者无叶子节点为止

B树的一些实现：
* [B树详细图解与Java完整实现](https://blog.csdn.net/jimo_lonely/article/details/82716142)
* [B树(Java)实现](https://blog.csdn.net/kalikrick/article/details/27980007)
