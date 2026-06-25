package cn.kinghh.blog.vo;

public class ArticleDetailVO extends ArticleCardVO {
  private String content;
  private Long previousId;
  private String previousTitle;
  private Long nextId;
  private String nextTitle;

  public String getContent() { return content; }
  public void setContent(String content) { this.content = content; }
  public Long getPreviousId() { return previousId; }
  public void setPreviousId(Long previousId) { this.previousId = previousId; }
  public String getPreviousTitle() { return previousTitle; }
  public void setPreviousTitle(String previousTitle) { this.previousTitle = previousTitle; }
  public Long getNextId() { return nextId; }
  public void setNextId(Long nextId) { this.nextId = nextId; }
  public String getNextTitle() { return nextTitle; }
  public void setNextTitle(String nextTitle) { this.nextTitle = nextTitle; }
}
