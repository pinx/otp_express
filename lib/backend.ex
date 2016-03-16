defmodule Backend do
  use GenServer

  @db DbList

  @accounts [
    {1, 100, "1234", "Henry Nystrom"},
    {2, 200, "4321", "Francesco Cesarini"},
    {3, 1000, "1111", "Donald Duck"},
    {4, 5000, "1234", "Henry Nystrom"}
  ]
  defmodule State do
    defstruct accounts: []
  end

  
  def start do
    GenServer.start({:local, __MODULE__}, __MODULE__, [], [])
  end

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    accounts = 
      @accounts
      |> Enum.map(
        fn {no, balance, pin, name} -> 
          DbList.insert(new_account(no, balance, pin, name), @db.empty)
        end)
        # map over @accounts and insert in db
    {:ok, %State{accounts: accounts}}
  end

  def terminate(reason, state) do
    :ok
  end

  def handle_cast({:stop}) do
    GenServer.stop(__MODULE__)
  end

  def pin_valid(account_no, input) do
    call({:pin_valid, account_no, input})
  end


  def call(msg) do
    :gen_server.call(__MODULE__, msg)
  end

  def handle_call({:account, :all}) do

  end


  def handle_call({:account, account}, _from, state) do
    case account do
      :all ->
        reply = @db.db_to_list(state.accounts)
        |> List.map(fn %Account{no: no, name: name} -> {no, name} end)
        #get list of accounts from db
        {:reply, reply, state}
      name when is_list(name) ->
        {:reply, find_account(name, state), state}
      no when is_integer(no) ->
        {:reply, find_account(no, state), state}
    end
  end

  def handle_call({:pin_valid, account_no, pin}, _from, state) do
    account = find_account(account_no, state)
    {:reply, is_pin_valid(account, pin), state}
  end

  def handle_call({:change_pin, user, old_pin, new_pin}, _from, state) do
    case do_change_pin do
      # implement
      {:ok, new_state} -> {:reply, :ok, new_state}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end  

  def handle_call({:balance, account_no, pin}, _from, state) do
    {:reply, do_balance(account_no, pin, state), state}
  end

  def handle_call({:withdraw, from_account_no, pin, amount}, _from, state) do
    case do_withdraw(from_account_no, pin, amount, state) do
      {:ok, new_state} -> {:reply, :ok, new_state}

    end
  end


  ######################
  # Internal functions #
  ######################

  @spec new_account(integer, float, String.t, String.t) :: %Account{}
  defp new_account(no, balance, pin, name) do
    %Account{no: no, balance: balance, pin: pin, name: name}
  end

  @spec find_account(integer, List) :: %Account{}
  defp find_account(account_no, state) when is_integer(account_no) do
    @db.lookup(account_no, state.accounts)
  end

  @spec find_account(List, List) :: %Account{}
  defp find_account(account, state) when is_list(account) do
    @db.lookup_all(account.no, state.accounts)
  end

  defp is_pin_valid([], _), do: false
  defp is_pin_valid([account | _], pin), do: account.pin == pin
  defp is_pin_valid(account, pin), do: account.pin == pin

  defp do_change_pin do
  end


  defp do_balance(_,_,_) do
  end

  defp do_withdraw(_,_,_,_) do
  end

end

