defmodule Tasks.Todo do
  import Ecto.Query, warn: false

  alias Tasks.Todo.Task
  alias Tasks.Repo

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def delete_task(id) do
    task = Repo.get!(Task, id)
    Repo.delete(task)
  end

  def edit_task(id, attrs \\ %{}) do
    Task
    |> Repo.get!(id)
    |> Task.changeset(attrs)
    |> Repo.update!()
  end

  def toggle_task(id) do
    task = Repo.get!(Task, id)
    attrs = %{task: task.task, done: !task.done}

    Task.changeset(task, attrs)
    |> Repo.update!()
  end

  def get_task(id) do
    Repo.get!(Task, id)
  end
end
