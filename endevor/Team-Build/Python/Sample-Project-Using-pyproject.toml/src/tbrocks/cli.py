import click
from tbrocks import core


@click.group()
def cli():
    pass


@cli.command()
@click.option("-c", "--count", default=1, help="Number of greetings.")
@click.argument("name")
def greet(count, name):
    """
    Simple program that greets NAME for a total of COUNT times.
    """
    for x in range(count):
        click.echo(f"Hello, {name}!")


@cli.command()
@click.argument("number", type=int)
def add67(number):
    """
    Simple program that adds 67 to NUMBER.
    """
    click.echo(core.add67(number))


cli.add_command(greet)
