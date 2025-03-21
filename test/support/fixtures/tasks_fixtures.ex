defmodule Tasks.TasksFixtures do
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        task: "some description",
        done: false
      })
      |> Tasks.Todo.create_task()

    task
  end
end
