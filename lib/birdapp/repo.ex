defmodule Birdapp.Repo do
  use Ecto.Repo,
    otp_app: :birdapp,
    adapter: Ecto.Adapters.MyXQL
end
