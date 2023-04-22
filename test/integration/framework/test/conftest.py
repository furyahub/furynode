import pytest
import furytool.test_utils


@pytest.fixture(scope="function")
def ctx(request):
    yield from furytool.test_utils.pytest_ctx_fixture(request)


@pytest.fixture(autouse=True)
def test_wrapper_fixture():
    furytool.test_utils.pytest_test_wrapper_fixture()
