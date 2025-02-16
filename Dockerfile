FROM python:3.12-slim-bookworm

# Install dependencies, including Git
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates git && \
    rm -rf /var/lib/apt/lists/*  # Clean up package lists to reduce image size

# Download and install uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Install FastAPI and Uvicorn
RUN pip install fastapi uvicorn

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin:$PATH"

# Set up the application directory
WORKDIR /app

# Copy all application files
COPY main.py /app/

# Explicitly set Git executable path for GitPython
ENV GIT_PYTHON_GIT_EXECUTABLE="/usr/bin/git"

# Run the application
CMD ["/root/.local/bin/uv", "run", "main.py"]
