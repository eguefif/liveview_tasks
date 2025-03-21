defmodule Tasks.TodoTest do
  use Tasks.DataCase

  alias Tasks.Todo

  describe "Todo" do
    alias Tasks.Todo.Task

    import Tasks.TasksFixtures

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Todo.list_tasks() == [task]
    end

    test "edit_task/0 update a task" do
      before_task = %{task: "Hello1", done: false}
      task = task_fixture(before_task)

      after_task = %{task: "Hello2", done: true}
      Todo.edit_task(task.id, after_task)

      result = Todo.get_task(task.id)
      assert result.task == after_task.task
      assert result.done == after_task.done
    end

    test "toggle_task/0 toggle the done value" do
      before_task = %{task: "Hello1", done: false}
      task = task_fixture(before_task)

      Todo.toggle_task(task.id)

      result = Todo.get_task(task.id)
      assert result.done == !task.done
    end

    test "title must be at least two characters long" do
      changeset = Task.changeset(%Task{}, %{task: "I"})
      assert %{task: ["should be at least 4 character(s)"]} = errors_on(changeset)
    end

    test "title must be at most 25 characters long" do
      changeset = Task.changeset(%Task{}, %{task: "aaaaaaaaaaaaaaaaaaaaaaaaaa"})
      assert %{task: ["should be at most 25 character(s)"]} = errors_on(changeset)
    end
  end
end
