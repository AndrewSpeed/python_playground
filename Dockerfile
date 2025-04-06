FROM python:3.12

ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy PYTHONDONTWRITEBYTECODE=1

# Configure the Python directory so it is consistent
ENV UV_PYTHON_INSTALL_DIR=/python

# Only use the managed Python version
ENV UV_PYTHON_PREFERENCE=only-managed

WORKDIR /usr/src/app

# install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install Python before the project for caching
RUN uv python install 3.12

# copy dependency files
COPY pyproject.toml uv.lock /usr/src/app/

RUN uv sync --frozen --no-dev

# Place executables in the environment at the front of the path
ENV PATH="/usr/src/app/.venv/bin:$PATH"
