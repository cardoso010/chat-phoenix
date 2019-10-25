defmodule Chat.Accounts.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :chat,
    error_handler: Chat.Accounts.ErrorHandler,
    module: Chat.Accounts.Guardian

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # if there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # makes sure that a token was found and is valid
  # plug Guardian.Plug.EnsureAuthenticated
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
