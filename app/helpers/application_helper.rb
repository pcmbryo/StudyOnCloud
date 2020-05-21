module ApplicationHelper
  def page_title
    title = "StudyOnCloud"
    title = @page_title + "|" + title if @page_title 
  end
end
