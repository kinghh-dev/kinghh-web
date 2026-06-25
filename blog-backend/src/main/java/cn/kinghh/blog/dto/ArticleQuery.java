package cn.kinghh.blog.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

public class ArticleQuery {
  @Min(1)
  private long page = 1;
  @Min(1)
  @Max(50)
  private long size = 10;
  private Long categoryId;
  private Long tagId;
  private String keyword;
  private String sort = "latest";

  public long getPage() { return page; }
  public void setPage(long page) { this.page = page; }
  public long getSize() { return size; }
  public void setSize(long size) { this.size = size; }
  public Long getCategoryId() { return categoryId; }
  public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
  public Long getTagId() { return tagId; }
  public void setTagId(Long tagId) { this.tagId = tagId; }
  public String getKeyword() { return keyword; }
  public void setKeyword(String keyword) { this.keyword = keyword; }
  public String getSort() { return sort; }
  public void setSort(String sort) { this.sort = sort; }
}
