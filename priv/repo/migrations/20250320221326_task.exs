defmodule Tasks.Repo.Migrations.Task do
  use Ecto.Migration

  def change do
    create table(:todo_task) do
      add :task, :string
      add :done, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
