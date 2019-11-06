defmodule Voting.Button do
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Voting.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(Voting.PubSub, @topic, message)
  end
end
