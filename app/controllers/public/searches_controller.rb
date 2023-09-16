class Public::SearchesController < ApplicationController
  def search
    # キーワードを分割して配列にする。(全角・半角スペース_連続にも対応)
    @keywords = params[:keywords].split(/[[:blank:]]+/)

    # Postの中身が空っぽのものを用意
    @results = Post.none

    # 検索ワードに都道府県名が入っているかチェック
    prefs = [] # 都道府県配列入れ物
    @keywords.each do |keyword|
      # 都道府県一覧から、keywordを含む都道府県IDをprefsに配列として追加する
      Prefecture.all.map{|pref| prefs << pref.id if pref.name.include?(keyword)}
    end

    # 実際の検索
    @keywords.each do |keyword|
      # @resultsにorの条件で、Postに定義したsearchメソッドの結果を入れて反映する
      @results = @results.or(Post.search(keyword, prefs))
    end

    # @postsに、結果の重複を取り除いたものを入れる
    @posts = @results.distinct
  end
end
