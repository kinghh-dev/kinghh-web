package cn.kinghh.blog.service.impl;

import cn.kinghh.blog.common.BizException;
import cn.kinghh.blog.common.PageResult;
import cn.kinghh.blog.dto.ArticleQuery;
import cn.kinghh.blog.mapper.ArticleMapper;
import cn.kinghh.blog.service.ArticleService;
import cn.kinghh.blog.vo.ArticleCardVO;
import cn.kinghh.blog.vo.ArticleDetailVO;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ArticleServiceImpl implements ArticleService {
  private final ArticleMapper articleMapper;

  public ArticleServiceImpl(ArticleMapper articleMapper) {
    this.articleMapper = articleMapper;
  }

  @Override
  public PageResult<ArticleCardVO> listPublicArticles(ArticleQuery query) {
    long page = Math.max(query.getPage(), 1);
    long size = Math.min(Math.max(query.getSize(), 1), 50);
    long offset = (page - 1) * size;
    long total = articleMapper.countPublicArticles(query.getCategoryId(), query.getTagId(), query.getKeyword());
    List<ArticleCardVO> records = articleMapper.selectPublicCards(
        offset, size, query.getCategoryId(), query.getTagId(), query.getKeyword(), query.getSort());
    records.forEach(article -> article.setTags(articleMapper.selectTagNames(article.getId())));
    return new PageResult<>(page, size, total, records);
  }

  @Override
  @Transactional
  public ArticleDetailVO getPublicArticle(Long id) {
    ArticleDetailVO detail = articleMapper.selectPublicDetail(id);
    if (detail == null) {
      throw new BizException(404, "文章不存在或未发布");
    }
    articleMapper.incrementViewCount(id);
    detail.setViewCount(detail.getViewCount() == null ? 1 : detail.getViewCount() + 1);
    detail.setTags(articleMapper.selectTagNames(id));
    Long previousId = articleMapper.selectPreviousId(id);
    Long nextId = articleMapper.selectNextId(id);
    if (previousId != null) {
      ArticleDetailVO previous = articleMapper.selectPublicDetail(previousId);
      detail.setPreviousId(previousId);
      detail.setPreviousTitle(previous == null ? null : previous.getTitle());
    }
    if (nextId != null) {
      ArticleDetailVO next = articleMapper.selectPublicDetail(nextId);
      detail.setNextId(nextId);
      detail.setNextTitle(next == null ? null : next.getTitle());
    }
    return detail;
  }
}
