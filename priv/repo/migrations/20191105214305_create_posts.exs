defmodule Voting.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :score, :integer
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:topic_id])
  end
end
