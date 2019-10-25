defmodule ChatWeb.ViewHelper do
  def current_user(conn), do: Guardian.Plug.current_resource(conn)
  def logged_in?(conn, opts \\ []), do: Guardian.Plug.authenticated?(conn, opts)
end
