<%# ID "comments" の要素の末尾に、新しいコメントを挿入する %>
<%= turbo_stream.append "comments" do %>
  <div class="mb-5 p-4 bg-gray-100 rounded-lg">
    <%= @comment.content %>
  </div>
<% end %>

<%# フォームを空にする指示 %>
<%= turbo_stream.replace "new_comment_form" do %>
  <%= render partial: "comments/form", locals: { post: @post } %>
<% end %>