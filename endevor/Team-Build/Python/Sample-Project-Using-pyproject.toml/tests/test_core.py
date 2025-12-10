from tbrocks.core import add67


def test_add67():
    expected = 10 + 67
    got = add67(10)
    assert expected == got
