package cn.kinghh.blog.entity;

import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("article")
public class Article {
  private Long id;
  private String title;
  private String summary;
  private String content;
  private String cover;
  private Long authorId;
  private Long categoryId;
  private String status;
  private Boolean isTop;
  private Boolean isRecommend;
  private Long viewCount;
  private Long likeCount;
  private Long commentCount;
  private Long favoriteCount;
  private LocalDateTime publishedAt;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;
  @TableLogic
  private Integer deleted;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getTitle() { return title; }
  public void setTitle(String title) { this.title = title; }
  public String getSummary() { return summary; }
  public void setSummary(String summary) { this.summary = summary; }
  public String getContent() { return content; }
  public void setContent(String content) { this.content = content; }
  public String getCover() { return cover; }
  public void setCover(String cover) { this.cover = cover; }
  public Long getAuthorId() { return authorId; }
  public void setAuthorId(Long authorId) { this.authorId = authorId; }
  public Long getCategoryId() { return categoryId; }
  public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public Boolean getIsTop() { return isTop; }
  public void setIsTop(Boolean top) { isTop = top; }
  public Boolean getIsRecommend() { return isRecommend; }
  public void setIsRecommend(Boolean recommend) { isRecommend = recommend; }
  public Long getViewCount() { return viewCount; }
  public void setViewCount(Long viewCount) { this.viewCount = viewCount; }
  public Long getLikeCount() { return likeCount; }
  public void setLikeCount(Long likeCount) { this.likeCount = likeCount; }
  public Long getCommentCount() { return commentCount; }
  public void setCommentCount(Long commentCount) { this.commentCount = commentCount; }
  public Long getFavoriteCount() { return favoriteCount; }
  public void setFavoriteCount(Long favoriteCount) { this.favoriteCount = favoriteCount; }
  public LocalDateTime getPublishedAt() { return publishedAt; }
  public void setPublishedAt(LocalDateTime publishedAt) { this.publishedAt = publishedAt; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
  public Integer getDeleted() { return deleted; }
  public void setDeleted(Integer deleted) { this.deleted = deleted; }
}
