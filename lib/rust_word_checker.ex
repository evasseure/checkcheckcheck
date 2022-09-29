defmodule RustWordChecker do
  use Rustler, otp_app: :checkcheckcheck, crate: "rustwordchecker"

  # When your NIF is loaded, it will override this function.
  # def check(_word, _dictionnary), do: :erlang.nif_error(:nif_not_loaded)
  def correct(_text, _dictionnary), do: :erlang.nif_error(:nif_not_loaded)
end
