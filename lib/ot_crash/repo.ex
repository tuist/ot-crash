defmodule OtCrash.Repo do
  use Ecto.Repo,
    otp_app: :ot_crash,
    adapter: Ecto.Adapters.Postgres
end
