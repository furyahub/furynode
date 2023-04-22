import burn_lock_functions
from burn_lock_functions import FurynetcliCredentials
from test_utilities import get_required_env_var, get_shell_output


def furynet_cli_credentials_for_test(key: str) -> FurynetcliCredentials:
    """Returns FurynetcliCredentials for the test keyring with from_key set to key"""
    return FurynetcliCredentials(
        keyring_passphrase="",
        keyring_backend="test",
        from_key=key,
        furynd_homedir=f"""{get_required_env_var("HOME")}/.furynd"""
    )


def create_new_furyaddr_and_credentials() -> (str, FurynetcliCredentials):
    new_account_key = get_shell_output("uuidgen")
    credentials = furynet_cli_credentials_for_test(new_account_key)
    new_addr = burn_lock_functions.create_new_furyaddr(credentials=credentials, keyname=new_account_key)
    credentials.from_key = new_addr["name"]
    return new_addr["address"], credentials,
