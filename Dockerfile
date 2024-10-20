FROM python:3.11.2-slim-bullseye

# Install dependencies for docker-compose
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    libffi-dev \
    libssl-dev \
    python3-dev \
    build-essential \
 && apt-get clean

# Download and install Docker Compose binary from Docker's official release
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-linux-aarch64" -o /usr/bin/docker-compose \
    && chmod +x /usr/bin/docker-compose

# Set the working directory
WORKDIR /app

# Copy the application code to the container
COPY . /app
WORKDIR /app

# Install required Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 80 for the Flask app
EXPOSE 80

# Command to run the Flask app
CMD [ "python3", "app.py" ]
