# Use the official R image from the Docker Hub
FROM r-base:latest

# Install system dependencies needed for R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libsodium-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages('plumber', repos='http://cran.us.r-project.org')"
RUN R -e "install.packages('webutils', repos='http://cran.us.r-project.org')"

# Copy the API script into the Docker image
COPY plumber.R /plumber.R

# Expose the port Plumber will run on
EXPOSE 8000

# Run the Plumber API
CMD ["R", "-e", "pr <- plumber::plumb('/plumber.R'); pr$run(host = '0.0.0.0', port = as.numeric(Sys.getenv('PORT', 8000)))"]
