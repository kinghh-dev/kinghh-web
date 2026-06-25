package cn.kinghh.blog.mapper;

import cn.kinghh.blog.entity.Tag;
import cn.kinghh.blog.vo.TagVO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface TagMapper extends BaseMapper<Tag> {
  @Select("""
      select t.id, t.name, t.slug, count(a.id) as article_count
      from tag t
      left join article_tag at on at.tag_id = t.id
      left join article a on a.id = at.article_id and a.deleted = 0 and a.status = 'PUBLISHED'
      where t.deleted = 0 and t.status = 'NORMAL'
      group by t.id, t.name, t.slug
      order by article_count desc, t.id asc
      """)
  List<TagVO> selectPublicTags();
}
