$(function(){

  var target = $("#search_list")
  function buildHtml(users){
    if (users.length == 0){
      html = "<p>お探しのユーザーはいません</p>"
      target.append(html)
    }
    else {
      users.forEach(function(user){
        var html = `<li>
        ${user.image_url}
        <a href="/users/${user.id}">${user.name}</a>
        </li>`
        target.append(html)
      })
    }
  }

  $("#search").on("keyup",function(){
    var keyword = $(this).val()
    if (!keyword){
      target.empty()
    }
    else{
      $.ajax({
        url: "/users",
        type: "GET",
        data: {keyword: keyword},
        dataType: 'json'
      })
      .done(function(data){
        var target = $("#search_list")
        target.empty()
        buildHtml(data)
      })
      .fail(function(){
        alert("eroor")
      })
    }
  })
})