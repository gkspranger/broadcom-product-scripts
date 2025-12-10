from click.testing import CliRunner
from tbrocks.cli import greet


def test_greet():
    name = "Neal"
    runner = CliRunner()
    result = runner.invoke(greet, ["-c", 3, name])

    assert result.exit_code == 0
    assert result.stdout.count(f"Hello, {name}!") == 3
