$ ->
    callback = (response) -> setLatestRepository(response)
    $.get 'https://api.github.com/users/andrewjkerr/repos?sort=updated', callback

setLatestRepository = (response) ->
    repo = response[0]
    date = moment(repo.updated_at).format("MMM D")
    $('.latest-repository').text("#{repo.name} (#{date})").attr('href', repo.html_url)
