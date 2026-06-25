package cn.kinghh.blog.mapper;

import cn.kinghh.blog.entity.Article;
import cn.kinghh.blog.vo.ArticleCardVO;
import cn.kinghh.blog.vo.ArticleDetailVO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ArticleMapper extends BaseMapper<Article> {
  @Select("""
      <script>
      select a.id, a.title, a.summary, a.cover, a.author_id, u.nickname as author_name, u.avatar as author_avatar,
             a.category_id, c.name as category_name, a.view_count, a.like_count, a.comment_count, a.favorite_count,
             a.is_top, a.is_recommend, a.published_at, a.updated_at
      from article a
      join user u on u.id = a.author_id and u.deleted = 0
      left join category c on c.id = a.category_id and c.deleted = 0
      <if test="tagId != null">
        join article_tag at_filter on at_filter.article_id = a.id and at_filter.tag_id = #{tagId}
      </if>
      where a.deleted = 0 and a.status = 'PUBLISHED'
      <if test="categoryId != null">and a.category_id = #{categoryId}</if>
      <if test="keyword != null and keyword != ''">
        and (a.title like concat('%', #{keyword}, '%') or a.summary like concat('%', #{keyword}, '%') or a.content like concat('%', #{keyword}, '%'))
      </if>
      order by a.is_top desc,
      <choose>
        <when test="sort == 'hot'">a.view_count desc, a.published_at desc</when>
        <otherwise>a.published_at desc, a.id desc</otherwise>
      </choose>
      limit #{offset}, #{size}
      </script>
      """)
  List<ArticleCardVO> selectPublicCards(@Param("offset") long offset, @Param("size") long size,
      @Param("categoryId") Long categoryId, @Param("tagId") Long tagId, @Param("keyword") String keyword,
      @Param("sort") String sort);

  @Select("""
      <script>
      select count(distinct a.id)
      from article a
      <if test="tagId != null">
        join article_tag at_filter on at_filter.article_id = a.id and at_filter.tag_id = #{tagId}
      </if>
      where a.deleted = 0 and a.status = 'PUBLISHED'
      <if test="categoryId != null">and a.category_id = #{categoryId}</if>
      <if test="keyword != null and keyword != ''">
        and (a.title like concat('%', #{keyword}, '%') or a.summary like concat('%', #{keyword}, '%') or a.content like concat('%', #{keyword}, '%'))
      </if>
      </script>
      """)
  long countPublicArticles(@Param("categoryId") Long categoryId, @Param("tagId") Long tagId, @Param("keyword") String keyword);

  @Select("""
      select a.id, a.title, a.summary, a.content, a.cover, a.author_id, u.nickname as author_name, u.avatar as author_avatar,
             a.category_id, c.name as category_name, a.view_count, a.like_count, a.comment_count, a.favorite_count,
             a.is_top, a.is_recommend, a.published_at, a.updated_at
      from article a
      join user u on u.id = a.author_id and u.deleted = 0
      left join category c on c.id = a.category_id and c.deleted = 0
      where a.deleted = 0 and a.status = 'PUBLISHED' and a.id = #{id}
      """)
  ArticleDetailVO selectPublicDetail(@Param("id") Long id);

  @Select("""
      select t.name
      from tag t
      join article_tag at on at.tag_id = t.id
      where at.article_id = #{articleId} and t.deleted = 0 and t.status = 'NORMAL'
      order by t.id
      """)
  List<String> selectTagNames(@Param("articleId") Long articleId);

  @Select("""
      select id from article
      where deleted = 0 and status = 'PUBLISHED' and published_at < (select published_at from article where id = #{id})
      order by published_at desc limit 1
      """)
  Long selectPreviousId(@Param("id") Long id);

  @Select("""
      select id from article
      where deleted = 0 and status = 'PUBLISHED' and published_at > (select published_at from article where id = #{id})
      order by published_at asc limit 1
      """)
  Long selectNextId(@Param("id") Long id);

  @Update("update article set view_count = view_count + 1 where id = #{id} and deleted = 0")
  int incrementViewCount(@Param("id") Long id);
}
