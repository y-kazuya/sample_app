$(function(){

  //いいねボタン→いいねフォーム削除＆いいね削除フォーム差し込み

  function buildunLikeform(like){
    var html =`<form class="unlike-form" action="/likes/${like.id}" accept-charset="UTF-8" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="✓"><input type="hidden" name="_method" value="delete">
        <input type="hidden" name="authenticity_token" value="l2JINcijhsXkQdlQ0GHdUQOR6KaeJbY1Qr8OCmsXy6CROAGAPiDqrKT9F+WV0jflSQYgkRQaSBT3ECVD/Zo/0A==">
        <input value="${like.micropost_id}" class="m_f" type="hidden" name="micropost_id">
        <input type="submit" name="commit" value="いいね解除" class="unlike-bo" data-disable-with="いいね解除">
      </form>`

    return html;
  }
  $(".microposts").on("click", function(){
    $(".like-form").on("submit", function(e){
      e.preventDefault();
      var formData = new FormData($(this)[0])
      var form = $(this)
      var target = $(this).parents(".timestamp")
      var t_count = $(this).siblings(".like_count").text()
      var t = $(this).siblings(".like_count")

      $.ajax({
        url: "/likes",
        type: "POST",
        data: formData,
        dataType: 'json',
        processData: false,
        contentType: false
      })
      .done(function(data){
        console.log(data)
        var unlikehtml = buildunLikeform(data)
        t.text(Number(t_count + 1))
        target.append(unlikehtml)
        form.remove()
      })
    })
  })



  //いいね削除ボタン→いいね削除フォーム削除＆いいね追加フォーム組み込み
  function buildLikeform(micro_id){
    var html =`<form class="like-form" action="/likes" accept-charset="UTF-8" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="✓">
        <input type="hidden" name="authenticity_token" value="80EQ4j3Opk++qMtIIgV+KzoTVRi2bLSU1L/Ff6YAm5f1G1lXy03KJv4UBf1ntpSfcISdLzxTSrVhEO42MI1v5w==">
        <input value="${micro_id}" class="m_f" type="hidden" name="micropost_id">
        <input type="submit" name="commit" value="いいね！" class="like-bo" data-disable-with="いいね！">
      </form>`
    return html;
  }
  $(".microposts").on("click", function(){
    $(".unlike-form").on("submit",function(){
      var t = $(this).siblings(".like_count").text()
      $(this).siblings(".like_count").text(t - 1)
      var micro_id =  $(this).parents("li").attr("id").match(/[0-9]+$/)[0]
      var likehtml = buildLikeform(micro_id)
      $(this).parents(".timestamp").append(likehtml)
      $(this).remove()


    })
  })
})