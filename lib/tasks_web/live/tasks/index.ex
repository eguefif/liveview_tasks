defmodule TasksWeb.TasksLive.Index do
  use TasksWeb, :live_view
  alias Tasks.Todo

  def render(assigns) do
    ~H"""
    <.table id="tasks" rows={@tasks}>
      <:col :let={task} label="Task">{task.task}</:col>
      <:col :let={task} label="Done">{task.done}</:col>
      <:action :let={task}>
        X
      </:action>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    tasks = Todo.list_tasks()
    {:ok, assign(socket, :tasks, tasks)}
  end
end
