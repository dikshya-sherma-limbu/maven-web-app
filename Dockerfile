# Use a basic OpenJDK image
FROM openjdk:11-jdk

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/

# Set working directory
WORKDIR /app

# Install wget to download Jetty
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Define Jetty version and install it
ENV JETTY_VERSION=11.0.15
ENV JETTY_HOME=/opt/jetty

# Download and unpack Jetty
RUN mkdir -p $JETTY_HOME && \
    wget -qO- https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/${JETTY_VERSION}/jetty-home-${JETTY_VERSION}.tar.gz | tar xzf - -C $JETTY_HOME --strip-components=1

# Set up a Jetty base
ENV JETTY_BASE=/var/lib/jetty
RUN mkdir -p $JETTY_BASE
WORKDIR $JETTY_BASE
RUN java -jar $JETTY_HOME/start.jar --add-module=server,http,deploy

# Copy the WAR file
COPY target/comp367webapp.war $JETTY_BASE/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Jetty
CMD ["java", "-jar", "/opt/jetty/start.jar"]