defmodule TasksWeb.TasksLive.Index do
  use TasksWeb, :live_view
  alias Tasks.Todo
  alias Tasks.Todo.Task

  @impl true
  def render(assigns) do
    # row_click={fn task -> JS.push("toggle", value: %{id: task.id}) end}
    ~H"""
    <div>
      <.simple_form for={@form} id="task-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:task]} type="text" label="Task" />
      </.simple_form>

      <.tasks_list tasks={@tasks} />
    </div>
    """
  end

  attr :tasks, :list, required: true

  def tasks_list(assigns) do
    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading text-zinc-500">
          <tr>
            <th class="p-0 pb-4 pr-6 font-normal">Task</th>
            <th class="p-0 pb-4 pr-6 font-normal">Completed</th>
            <th class="p-0 pb-4 font-normal"></th>
          </tr>
        </thead>
        <tbody class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700">
          <tr :for={task <- @tasks} id={"row-#{task.id}"} class="group hover:bg-zinc-50">
            <td class="p-0 pb-4 pr-6 font-normal" phx-click={JS.push("toggle", value: %{id: task.id})}>
              {task.task}
            </td>
            <td class="p-0 pb-4 pr-6"><.status task_status={task.done} /></td>
            <td class="p-0 pb-4 font-normal">
              <.link phx-click={JS.push("delete", value: %{id: task.id}) |> hide("##{task.id}")}>
                X
              </.link>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  attr :task_status, :boolean, required: true

  def status(assigns) do
    icon = if assigns.task_status, do: "hero-check-solid", else: "hero-x-mark-solid"
    assigns = assign(assigns, :icon_class, icon)

    ~H"""
    <.icon name={@icon_class} />
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
  def handle_event("toggle", %{"id" => id}, socket) do
    Todo.toggle_task(id)

    socket =
      socket
      |> assign(:tasks, Todo.list_tasks())
      |> assign(:form, to_form(Todo.change_task(%Task{})))

    {:noreply, socket}
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
