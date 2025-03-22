defmodule TasksWeb.TasksLive.Index do
  use TasksWeb, :live_view
  alias Tasks.Todo
  alias Tasks.Todo.Task

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="task-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:task]} type="text" label="Task" />
      </.simple_form>

      <.table id="tasks" rows={@tasks}>
        <:col :let={task} label="Task">{task.task}</:col>
        <:col :let={task} label="Done">{task.done}</:col>
        <:action :let={task}>
          <.link
            phx-click={JS.push("delete", value: %{id: task.id}) |> hide("##{task.id}")}
            data-confirm="Are you sure?"
          >
            X
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    tasks = Todo.list_tasks()

    socket =
      socket
      |> assign(:tasks, tasks)
      |> assign(:form, to_form(Todo.change_task(%Task{})))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"task" => task}, socket) do
    form =
      %Task{}
      |> Todo.change_task(task)
      |> to_form(action: :validate)

    socket =
      socket
      |> assign(:tasks, Todo.list_tasks())
      |> assign(:form, form)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"task" => task}, socket) do
    Todo.create_task(task)

    socket =
      socket
      |> assign(:tasks, Todo.list_tasks())
      |> assign(:form, to_form(Todo.change_task(%Task{})))

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    Todo.delete_task(id)
    tasks = Todo.list_tasks()
    {:noreply, assign(socket, :tasks, tasks)}
  end
end
