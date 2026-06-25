package cn.kinghh.blog.vo;

import java.time.LocalDateTime;
import java.util.List;

public class ArticleCardVO {
  private Long id;
  private String title;
  private String summary;
  private String cover;
  private Long authorId;
  private String authorName;
  private String authorAvatar;
  private Long categoryId;
  private String categoryName;
  private List<String> tags;
  private Long viewCount;
  private Long likeCount;
  private Long commentCount;
  private Long favoriteCount;
  private Boolean isTop;
  private Boolean isRecommend;
  private LocalDateTime publishedAt;
  private LocalDateTime updatedAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getTitle() { return title; }
  public void setTitle(String title) { this.title = title; }
  public String getSummary() { return summary; }
  public void setSummary(String summary) { this.summary = summary; }
  public String getCover() { return cover; }
  public void setCover(String cover) { this.cover = cover; }
  public Long getAuthorId() { return authorId; }
  public void setAuthorId(Long authorId) { this.authorId = authorId; }
  public String getAuthorName() { return authorName; }
  public void setAuthorName(String authorName) { this.authorName = authorName; }
  public String getAuthorAvatar() { return authorAvatar; }
  public void setAuthorAvatar(String authorAvatar) { this.authorAvatar = authorAvatar; }
  public Long getCategoryId() { return categoryId; }
  public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
  public String getCategoryName() { return categoryName; }
  public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
  public List<String> getTags() { return tags; }
  public void setTags(List<String> tags) { this.tags = tags; }
  public Long getViewCount() { return viewCount; }
  public void setViewCount(Long viewCount) { this.viewCount = viewCount; }
  public Long getLikeCount() { return likeCount; }
  public void setLikeCount(Long likeCount) { this.likeCount = likeCount; }
  public Long getCommentCount() { return commentCount; }
  public void setCommentCount(Long commentCount) { this.commentCount = commentCount; }
  public Long getFavoriteCount() { return favoriteCount; }
  public void setFavoriteCount(Long favoriteCount) { this.favoriteCount = favoriteCount; }
  public Boolean getIsTop() { return isTop; }
  public void setIsTop(Boolean top) { isTop = top; }
  public Boolean getIsRecommend() { return isRecommend; }
  public void setIsRecommend(Boolean recommend) { isRecommend = recommend; }
  public LocalDateTime getPublishedAt() { return publishedAt; }
  public void setPublishedAt(LocalDateTime publishedAt) { this.publishedAt = publishedAt; }
  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
