package cn.kinghh.blog.service;

import cn.kinghh.blog.common.PageResult;
import cn.kinghh.blog.dto.ArticleQuery;
import cn.kinghh.blog.vo.ArticleCardVO;
import cn.kinghh.blog.vo.ArticleDetailVO;

public interface ArticleService {
  PageResult<ArticleCardVO> listPublicArticles(ArticleQuery query);

  ArticleDetailVO getPublicArticle(Long id);
}
