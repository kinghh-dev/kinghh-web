package cn.kinghh.blog.mapper;

import cn.kinghh.blog.entity.Category;
import cn.kinghh.blog.vo.CategoryVO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface CategoryMapper extends BaseMapper<Category> {
  @Select("""
      select c.id, c.name, c.slug, c.description, count(a.id) as article_count
      from category c
      left join article a on a.category_id = c.id and a.deleted = 0 and a.status = 'PUBLISHED'
      where c.deleted = 0 and c.status = 'NORMAL'
      group by c.id, c.name, c.slug, c.description, c.sort_order
      order by c.sort_order asc, c.id asc
      """)
  List<CategoryVO> selectPublicCategories();
}
