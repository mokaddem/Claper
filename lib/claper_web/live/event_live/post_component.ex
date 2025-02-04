defmodule ClaperWeb.EventLive.PostComponent do
  use ClaperWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"post-#{@post.uuid}"} class={if @post.__meta__.state == :deleted, do: "hidden"}>
      <%= if @post.attendee_identifier == @attendee_identifier || (not is_nil(@current_user) && @post.user_id == @current_user.id) do %>
        <div class="px-4 pt-3 pb-8 rounded-b-lg rounded-tl-lg bg-gray-700 text-white relative z-0 break-all">
          <button
            phx-click={
              JS.toggle(
                to: "#post-menu-#{@post.id}",
                out: "animate__animated animate__fadeOut",
                in: "animate__animated animate__fadeIn"
              )
            }
            phx-click-away={
              JS.hide(to: "#post-menu-#{@post.id}", transition: "animate__animated animate__fadeOut")
            }
            class="float-right mr-1"
          >
            <img src="/images/icons/ellipsis-horizontal-white.svg" class="h-5" />
          </button>
          <div
            id={"post-menu-#{@post.id}"}
            class="hidden absolute right-4 top-7 bg-white rounded-lg px-5 py-2"
          >
            <span class="text-red-500">
              <%= link(gettext("Delete"),
                to: "#",
                phx_click: "delete",
                phx_value_id: @post.uuid,
                phx_value_event_id: @event.uuid,
                data: [confirm: gettext("Are you sure?")]
              ) %>
            </span>
          </div>
          <p><%= @post.body %></p>

          <div class="flex h-6 text-sm float-right text-white space-x-2">
            <%= if @post.like_count > 0 do %>
              <div class="flex px-1 items-center">
                <img src="/images/icons/thumb.svg" class="h-4" />
                <span class="ml-1 text-white"><%= @post.like_count %></span>
              </div>
            <% end %>
            <%= if @post.love_count > 0 do %>
              <div class="flex px-1 items-center">
                <img src="/images/icons/heart.svg" class="h-4" />
                <span class="ml-1 text-white"><%= @post.love_count %></span>
              </div>
            <% end %>
            <%= if @post.lol_count > 0 do %>
              <div class="flex px-1 items-center">
                <img src="/images/icons/laugh.svg" class="h-4" />
                <span class="ml-1 text-white"><%= @post.lol_count %></span>
              </div>
            <% end %>
          </div>
        </div>
      <% else %>
        <div class="px-4 pt-3 pb-8 rounded-b-lg rounded-tr-lg bg-white text-black relative z-0 break-all">
          <%= if is_a_leader(@post, @event, @leaders) do %>
            <div class="inline-flex items-center space-x-1 justify-center px-3 py-0.5 rounded-full text-xs font-medium bg-supporting-yellow-100 text-supporting-yellow-800 mb-2">
              <img src="/images/icons/star.svg" class="h-3" />
              <span><%= gettext("Host") %></span>
            </div>
          <% end %>

          <%= if @is_leader do %>
            <button
              phx-click={
                JS.toggle(
                  to: "#post-menu-#{@post.id}",
                  out: "animate__animated animate__fadeOut",
                  in: "animate__animated animate__fadeIn"
                )
              }
              phx-click-away={
                JS.hide(
                  to: "#post-menu-#{@post.id}",
                  transition: "animate__animated animate__fadeOut"
                )
              }
              class="float-right mr-1"
            >
              <img src="/images/icons/ellipsis-horizontal.svg" class="h-5" />
            </button>
            <div
              id={"post-menu-#{@post.id}"}
              class="hidden absolute right-4 top-7 bg-gray-900 rounded-lg px-5 py-2"
            >
              <span class="text-red-500">
                <%= link(gettext("Delete"),
                  to: "#",
                  phx_click: "delete",
                  phx_value_id: @post.uuid,
                  phx_value_event_id: @event.uuid,
                  data: [confirm: gettext("Are you sure?")]
                ) %>
              </span>
            </div>
          <% end %>

          <p><%= @post.body %></p>

          <div class="flex h-6 text-xs float-right space-x-2">
            <%= if not Enum.member?(@liked_posts, @post.id) do %>
              <button
                phx-click="react"
                phx-value-type="👍"
                phx-value-post-id={@post.uuid}
                class="flex rounded-full px-3 py-1 border border-gray-300 bg-white items-center"
              >
                <img src="/images/icons/thumb.svg" class="h-4" />
                <%= if @post.like_count > 0 do %>
                  <span class="ml-1"><%= @post.like_count %></span>
                <% end %>
              </button>
            <% else %>
              <button
                phx-click="unreact"
                phx-value-type="👍"
                phx-value-post-id={@post.uuid}
                class="flex rounded-full px-3 py-1 border border-gray-300 bg-gray-100 items-center"
              >
                <span class="">
                  <img src="/images/icons/thumb.svg" class="h-4" />
                </span>
                <%= if @post.like_count > 0 do %>
                  <span class="ml-1"><%= @post.like_count %></span>
                <% end %>
              </button>
            <% end %>
            <%= if not Enum.member?(@loved_posts, @post.id) do %>
              <button
                phx-click="react"
                phx-value-type="❤️"
                phx-value-post-id={@post.uuid}
                class="flex rounded-full px-3 py-1 border border-gray-300 bg-white items-center"
              >
                <img src="/images/icons/heart.svg" class="h-4" />
                <%= if @post.love_count > 0 do %>
                  <span class="ml-1"><%= @post.love_count %></span>
                <% end %>
              </button>
            <% else %>
              <button
                phx-click="unreact"
                phx-value-type="❤️"
                phx-value-post-id={@post.uuid}
                class="flex rounded-full px-3 py-1 border border-gray-300 bg-gray-100 items-center"
              >
                <img src="/images/icons/heart.svg" class="h-4" />
                <%= if @post.love_count > 0 do %>
                  <span class="ml-1"><%= @post.love_count %></span>
                <% end %>
              </button>
            <% end %>
            <%= if not Enum.member?(@loled_posts, @post.id) do %>
              <button
                phx-click="react"
                phx-value-type="😂"
                phx-value-post-id={@post.uuid}
                class="flex rounded-full px-3 py-1 border border-gray-300 bg-white items-center"
              >
                <img src="/images/icons/laugh.svg" class="h-4" />
                <%= if @post.lol_count > 0 do %>
                  <span class="ml-1"><%= @post.lol_count %></span>
                <% end %>
              </button>
            <% else %>
              <button
                phx-click="unreact"
                phx-value-type="😂"
                phx-value-post-id={@post.uuid}
                class="flex rounded-full px-3 py-1 border border-gray-300 bg-gray-100 items-center"
              >
                <img src="/images/icons/laugh.svg" class="h-4" />
                <%= if @post.lol_count > 0 do %>
                  <span class="ml-1"><%= @post.lol_count %></span>
                <% end %>
              </button>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp is_a_leader(post, event, leaders) do
    !is_nil(post.user_id) &&
      (post.user_id == event.user_id ||
         Enum.any?(leaders, fn leader ->
           leader.user_id == post.user_id
         end))
  end
end
