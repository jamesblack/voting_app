defmodule VotingWeb.Live.Buttons do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <form phx-submit="addPost">
        <input type="text" name="postTitle" />
        <button type="submit">Add Post</button>
      </form>
      <table>
        <tr><th>Post Title</th><th>Score</th></tr>
        <%= for post <- @posts do %>
          <tr>
            <td><%= post.title %></td>
            <td><%= post.score %></td>
            <td>
              <button phx-click="upvote" phx-value-id="<%= post.id %>">▲</button>
              <button phx-click="downvote" phx-value-id="<%= post.id %>">▼</button>
            </td>
          </tr>
        <% end %>
      </table>

    """
  end

  def mount(_, socket) do
    if connected?(socket), do: Voting.Button.subscribe()
    topic = Voting.Topics.get_topic!("1") |> Voting.Repo.preload([:posts])

    socket =
      socket
      |> assign(:presses, 0)
      |> assign(
        :posts,
        topic.posts |> Enum.sort(fn post_a, post_b -> post_a.score >= post_b.score end)
      )

    {:ok, socket}
  end

  def handle_event("addPost", %{"postTitle" => postTitle}, socket) do
    {:ok, post} = Voting.Posts.create_post(%{title: postTitle, score: 0, topic_id: 1})
    Voting.Button.broadcast({:post_created, post})
    {:noreply, socket}
  end

  def handle_event("upvote", %{"id" => id}, socket) do
    IO.inspect(socket.assigns)
    post = Enum.find(socket.assigns.posts, fn post -> post.id == String.to_integer(id) end)
    Voting.Posts.update_post(post, %{score: post.score + 1})

    Voting.Button.broadcast({:upvote_pressed, String.to_integer(id)})
    {:noreply, socket}
  end

  def handle_event("downvote", %{"id" => id}, socket) do
    post = Enum.find(socket.assigns.posts, fn post -> post.id == String.to_integer(id) end)
    Voting.Posts.update_post(post, %{score: post.score - 1})

    Voting.Button.broadcast({:downvote_pressed, String.to_integer(id)})
    {:noreply, socket}
  end

  def handle_info({:upvote_pressed, id}, socket) do
    index = Enum.find_index(socket.assigns.posts, fn post -> post.id == id end)

    {:noreply,
     update(socket, :posts, fn posts ->
       List.update_at(posts, index, fn post -> %{post | score: post.score + 1} end)
     end)}
  end

  def handle_info({:downvote_pressed, id}, socket) do
    index = Enum.find_index(socket.assigns.posts, fn post -> post.id == id end)

    {:noreply,
     update(socket, :posts, fn posts ->
       List.update_at(posts, index, fn post -> %{post | score: post.score - 1} end)
     end)}
  end

  def handle_info({:post_created, post}, socket) do
    IO.inspect(post)
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end
end
