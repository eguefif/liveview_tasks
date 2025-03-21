alias Tasks.Repo
alias Tasks.Todo.Task

tasks = [
  %{task: "Groceries to Fruiterie", done: false},
  %{task: "Make you tax returns", done: false},
  %{task: "Call your mother", done: true},
  %{task: "Go on the moon", done: true},
  %{task: "Travel to Mars", done: false}
]

Enum.each(tasks, fn task ->
  %Task{}
  |> Task.changeset(task)
  |> Repo.insert!()
end)
