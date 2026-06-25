package cn.kinghh.blog.vo;

public class TagVO {
  private Long id;
  private String name;
  private String slug;
  private Long articleCount;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getSlug() { return slug; }
  public void setSlug(String slug) { this.slug = slug; }
  public Long getArticleCount() { return articleCount; }
  public void setArticleCount(Long articleCount) { this.articleCount = articleCount; }
}
