# Step 1: Use an official, lightweight Python runtime as a parent image
# Alpine is used because it creates very small docker images (good DevOps practice!)
FROM python:3.9-alpine

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy only the requirements file first
# We do this first to leverage Docker cache. If requirements don't change, 
# Docker won't reinstall packages on every build.
COPY requirements.txt .

# Step 4: Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy the rest of the application code into the container
COPY app.py .

# Step 6: Create a non-root user for security (Best Practice: containers shouldn't run as root)
RUN adduser -D myuser
USER myuser

# Step 7: Define environment variables
ENV APP_VERSION=1.0.0
ENV APP_ENV=production
ENV PORT=8080

# Step 8: Expose the port the app runs on
EXPOSE 8080

# Step 9: Define the command to run the application
CMD ["python", "app.py"]
