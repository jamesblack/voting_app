defmodule Voting.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :score, :integer
    field :title, :string
    belongs_to :topic, Voting.Topics.Topic

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :score, :topic_id])
    |> validate_required([:title, :score, :topic_id])
  end
end
