//
// server.c -- A webserver written in C
// 
// Test with curl
// 
//    curl -D - http://localhost:3490/
//    curl -D - http://localhost:3490/date
//    curl -D - http://localhost:3490/hello
//    curl -D - http://localhost:3490/hello?You
// 
// You can also test the above URLs in your browser! They should work!


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <signal.h>
#include <time.h>
#include <sys/file.h>
#include <fcntl.h>

#define PORT 3490  // the port users will be connecting to
#define BACKLOG 10	 // how many pending connections queue will hold

#define BUF_SIZE 65536

void failed(char *);

// Send an HTTP response
//
// header:       "HTTP/1.1 404 NOT FOUND" or "HTTP/1.1 200 OK", etc.
// content_type: "text/plain", etc.
// body:         the data to send.
// 
int send_response(int fd, char *header, char *content_type, char *body)
{
   char response[BUF_SIZE];
   int response_length; // Total length of header plus body

   sprintf(response, "%s\n%s\r\n\r\n%s\n", header, content_type, body);
   response_length = strlen(response);
   int rv = write(fd, response, response_length);
   if (rv < 0) failed("send");
   return rv;
}

// Send a 404 response
void send_404(int fd)
{
   send_response(fd, "HTTP/1.1 404 NOT FOUND",
                     "text/html",
                     "<h1>404 Page Not Found</h1>");
}

// Send a 500 response
void send_500(int fd)
{
   send_response(fd, "HTTP/1.1 500 Internal Server Error",
                     "text/html",
                     "<h1>Mangled request</h1>");
}

// Send response for server root
// http://localhost:3490/
// GET / xyzasdfasdfasdf
void send_root(int fd)
{
   send_response(fd, "HTTP/1.1 202 OK",
                     "text/html",
                     "<h1>WebServer running...</h1>"); 
}

// Send a /date endpoint response
void send_date(int fd)
{
    //TODO
    time_t timeInSecond = time(NULL);
    char *date = ctime(&timeInSecond);
    char line[BUFSIZ];
    sprintf(line, "<h1>%s<h1>", date);
    send_response(fd, "HTTP/1.1 200 OK",
                      "text/html", 
                      line);
}

// Send a /hello endpoint response
void send_hello(int fd, char *req)
{
    //TODO
    char *line = "/hello?";
    if (strncmp(req, line, 7) != 0) {
       send_response(fd, "HTTP/1.1 200 OK",
                         "text/html",
                         "<h1>hello</h1>"); 
    } else {
       char name[100] = "hello,";
       int i = 6;
       while (req[i + 2] != EOF) {
          name[i] = req[i + 2];
          i++;
       }
       name[i] = '!';
       char line[BUFSIZ];
       sscanf(line, "<h1>%s<h1>", name);
       //printf("%s", line);
       send_response(fd, "HTTP/1.1 200 OK",
                         "text/html",
                         line);
    }
}

// Handle HTTP request and send response
void handle_http_request(int fd)
{
   char request[BUF_SIZE];
   char req_type[8]; // GET or POST
   char req_path[1024]; // /info etc.
   char req_protocol[128]; // HTTP/1.1
 
   // Read the request
   int nbytes = read(fd, request, BUF_SIZE-1);
   if (nbytes < 0) failed("recv");
   request[nbytes] = '\0';

   printf("Request: ");
   for (char *c = request; *c != '\n'; c++)
      putchar(*c);
   putchar('\n');
 
   // Get the request type and path from the first line
   // If you can't decode the request, generate a 500 error response
   // Otherwise call appropriate handler function, based on path
   // Hint: use sscanf() and strcmp()
   // "GET /path theRest"
   //   %s   %s   %s
   // /
   // /date
   // /potato
   // "GET asdfadf"
   // TODO
   sscanf(request, "%s %s %s", req_type, req_path, req_protocol);
   if (strncmp(req_path, "/hello", 6) == 0) {
      send_hello(fd, req_path);
   } else if (strcmp(req_path, "/date") == 0) {
      send_date(fd);
   } else if (strcmp(req_path, "/") == 0) {
      send_root(fd);
   } else if (req_path == NULL) {
      send_500(fd);
   } else {
      send_404(fd);
   }
   
}

// fatal error handler
void failed(char *msg)
{
   char buf[100];
   sprintf(buf, "WebServer: %s", msg);
   perror(buf);
   exit(1);
}

int main(int argc, char *argv[])
{
   int listenfd;
   struct addrinfo hints;
   struct addrinfo *res;
   char portString[5]; 
   sprintf(portString,"%d",PORT);

   // set up a socket
   listenfd = socket(AF_INET, SOCK_STREAM, 0);
   if (listenfd < 0) failed("opening socket");
   
   memset(&hints, 0, sizeof hints);
   hints.ai_family = AF_INET;  // use IPv4  
   hints.ai_socktype = SOCK_STREAM;    
   getaddrinfo("localhost",portString,&hints,&res);

   // bind the socket to the address, set up in res
   // call fail if bind fails
   // listen for connections to that address  (used BACKLOG constant)
   // fall fail if listen fails
   // call freeaddrinfo on res 
   //TODO
   
   bind(listenfd, res->ai_addr, res->ai_addrlen);
   listen(listenfd, BACKLOG);
   
   printf("WebServer: waiting for connections...\n");
   
   
   while(1){ 
      //accept new request
      // call fail if accept fails
      //TODO
      struct sockaddr_in client_addr;
      socklen_t client_addr_size = sizeof(client_addr);
      int ss = accept(listenfd,  (struct sockaddr *) &client_addr, &client_addr_size);
      if (ss == -1) {
         failed("error");
      }
      printf("WebServer: got connection\n");

      // call handle_http_request, passing in the new socket 
      // descriptor for the new connection, returned from accept
      // Note: listenfd is still listening for new connections.
      // close the new socket descriptor.
      // TODO 
      
      handle_http_request(ss);
      close(ss);
   }
   close(listenfd);
   return 0; /* we never get here */
}

