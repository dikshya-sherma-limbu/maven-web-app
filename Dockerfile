# Use a basic OpenJDK image
FROM openjdk:11-jdk

# Install required packages
RUN apt-get update && \
    apt-get install -y maven wget && \
    rm -rf /var/lib/apt/lists/*

# Define Jetty version and install it
ENV JETTY_VERSION=11.0.15
ENV JETTY_HOME=/opt/jetty
ENV JETTY_BASE=/var/lib/jetty

# Download and unpack Jetty
RUN mkdir -p $JETTY_HOME && \
    wget -qO- https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/${JETTY_VERSION}/jetty-home-${JETTY_VERSION}.tar.gz | tar xzf - -C $JETTY_HOME --strip-components=1

# Set up a Jetty base with JSP support
RUN mkdir -p $JETTY_BASE
WORKDIR $JETTY_BASE
RUN java -jar $JETTY_HOME/start.jar --add-module=server,http,deploy,jsp

# Copy project files and build
WORKDIR /app
COPY . .
RUN mvn clean package

# Copy the WAR file
RUN cp target/comp367webapp.war $JETTY_BASE/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Jetty
WORKDIR $JETTY_BASE
CMD ["java", "-jar", "/opt/jetty/start.jar"]