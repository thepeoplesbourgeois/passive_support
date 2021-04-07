defmodule PassiveSupport.File do
  alias PassiveSupport.Item

  @doc """
  Creates a directory under the directory reported by `System.tmp_dir/0`

  Useful for making
  """
  def mk_tmpdir(dirname) do
    dirname
    |> Item.tap(&[System.tmp_dir(), &1])
    |> IO.chardata_to_string()
    |> Item.tee(&File.mkdir/1)
  end

  def mk_tmpdir(dirname \\ tmp_dirname(), fun)
  def mk_tmpdir(dirname, fun) when is_function(fun, 1) do
    dir = mk_tmpdir(dirname)
    fun.(dir)
    File.rm_rf(dir)
  end

  defp tmp_dirname,
    do: :rand.uniform_real
     |> to_string
     |> Base.encode64
     |> String.slice(0, 16)

end
