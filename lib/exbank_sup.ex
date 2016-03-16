defmodule ExbankSup do
  use Supervisor

  def start do
    Supervisor.start_link(ExbankSup, [])
  end

  def init(_args) do
    {:ok, {{:rest_for_one, 5, 2000},
        [
          child(Backend, []),
          child(Atm, [])
        ]
      }
    }
  end

  defp child(module, args) do
    {module, {module, :start_link, args}, :permanent, :brutal_kill, :worker, [module]}
  end

end
