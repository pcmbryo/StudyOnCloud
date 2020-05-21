module ApplicationHelper
  # コントローラから受け取ったページタイトルに"スタクラ"を付与してviewへ渡す
  def page_title
    title = "スタクラ"
    title = @page_title + " | " + title if @page_title
    title
  end
end
