defmodule Tasks.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_task" do
    field :done, :boolean, default: false
    field :task, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:task, :done])
    |> validate_required([:task, :done])
  end
end
