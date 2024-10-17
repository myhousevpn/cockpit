FROM --platform=arm64 python:3.12

# Copy the application code to the /app directory in the container
COPY . /app
WORKDIR /app

# Install the required Python packages
RUN pip3 install -r requirements.txt

# Expose port 80 for the Flask app
EXPOSE 80

# Command to run the Flask app
CMD [ "python3", "app.py" ]
