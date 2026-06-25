package cn.kinghh.blog.mapper;

import cn.kinghh.blog.vo.ArchiveVO;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface ArchiveMapper {
  @Select("""
      select year(published_at) as year, month(published_at) as month, count(*) as article_count
      from article
      where deleted = 0 and status = 'PUBLISHED' and published_at is not null
      group by year(published_at), month(published_at)
      order by year desc, month desc
      """)
  List<ArchiveVO> selectArchives();
}
