from tbrocks import core


def test_add67():
    expected = 10 + 67
    got = core.add67(10)
    assert expected == got
