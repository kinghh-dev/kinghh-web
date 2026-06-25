package cn.kinghh.blog.controller;

import cn.kinghh.blog.common.ApiResponse;
import cn.kinghh.blog.mapper.ArchiveMapper;
import cn.kinghh.blog.mapper.CategoryMapper;
import cn.kinghh.blog.mapper.TagMapper;
import cn.kinghh.blog.vo.ArchiveVO;
import cn.kinghh.blog.vo.CategoryVO;
import cn.kinghh.blog.vo.TagVO;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class PublicTaxonomyController {
  private final CategoryMapper categoryMapper;
  private final TagMapper tagMapper;
  private final ArchiveMapper archiveMapper;

  public PublicTaxonomyController(CategoryMapper categoryMapper, TagMapper tagMapper, ArchiveMapper archiveMapper) {
    this.categoryMapper = categoryMapper;
    this.tagMapper = tagMapper;
    this.archiveMapper = archiveMapper;
  }

  @GetMapping("/categories")
  public ApiResponse<List<CategoryVO>> categories() {
    return ApiResponse.ok(categoryMapper.selectPublicCategories());
  }

  @GetMapping("/tags")
  public ApiResponse<List<TagVO>> tags() {
    return ApiResponse.ok(tagMapper.selectPublicTags());
  }

  @GetMapping("/archives")
  public ApiResponse<List<ArchiveVO>> archives() {
    return ApiResponse.ok(archiveMapper.selectArchives());
  }
}
