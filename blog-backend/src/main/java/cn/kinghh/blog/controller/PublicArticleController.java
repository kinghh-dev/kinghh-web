package cn.kinghh.blog.controller;

import cn.kinghh.blog.common.ApiResponse;
import cn.kinghh.blog.common.PageResult;
import cn.kinghh.blog.dto.ArticleQuery;
import cn.kinghh.blog.service.ArticleService;
import cn.kinghh.blog.vo.ArticleCardVO;
import cn.kinghh.blog.vo.ArticleDetailVO;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/articles")
public class PublicArticleController {
  private final ArticleService articleService;

  public PublicArticleController(ArticleService articleService) {
    this.articleService = articleService;
  }

  @GetMapping
  public ApiResponse<PageResult<ArticleCardVO>> list(@Valid ArticleQuery query) {
    return ApiResponse.ok(articleService.listPublicArticles(query));
  }

  @GetMapping("/search")
  public ApiResponse<PageResult<ArticleCardVO>> search(@Valid ArticleQuery query) {
    return ApiResponse.ok(articleService.listPublicArticles(query));
  }

  @GetMapping("/{id}")
  public ApiResponse<ArticleDetailVO> detail(@PathVariable Long id) {
    return ApiResponse.ok(articleService.getPublicArticle(id));
  }
}
