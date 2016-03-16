defmodule DbList do

  def empty do
    []
  end

  def insert(account, db_ref) do
    db_ref ++ [ account ]
  end

  def db_to_list(db_ref) do
    db_ref
  end

  def db_size(db_ref) do
    Enum.count(db_ref)
  end

  def lookup(account_number, db_ref) do
    Enum.find(db_ref, fn a -> a.no == account_number end)
  end

  def lookup_all(account_field, key, db_ref) do
    Enum.filter(db_ref, 
      fn a -> Map.fetch!(a, account_field) == key end
    )
  end

  def update(account, db_ref) do
    Enum.filter(db_ref, fn a -> a.no != account.no end) ++ [ account ]
  end

  def close(db_ref) do
  end

end

