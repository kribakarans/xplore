#ifndef __CGI_HTML_H__
#define __CGI_HTML_H__

#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>

/* without line terminator */
#define html_s(fmt, args...) \
do { \
	fprintf(stderr, "\e[33m" fmt "\e[0m", ##args); \
	fprintf(stdout, fmt "", ##args); \
} while(0);

#define html(fmt, args...) \
do { \
	fprintf(stderr, "\e[33m" fmt "\e[0m\n", ##args); \
	fprintf(stdout, fmt "\n", ##args); \
} while(0);

#define html_header_title(title) \
do { \
	html("<!DOCTYPE html>"); \
	html("<html lang=\"en\">"); \
	html("<head>"); \
	html("<meta charset=\"UTF-8\">"); \
	html("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"); \
	html("<title>" title "</title>"); \
	html("</head>"); \
} while(0);

#define html_footer() \
do { \
	html("</html>"); \
} while(0);

#define html_body_init() html("<body>")
#define html_body_end()  html("</body>")

#define html_error(fmt, args...) \
do { \
	html_header_title("ERROR!"); \
	html("<body>"); \
	html("<h2 style=\"color:Tomato;\">Oops! " fmt "</h2>", ##args); \
	fprintf(stdout, "<h4 style=\"font-family:Courier New;\">Trace: %s:%d %s(): " fmt "</h4>\n", __FILE__, __LINE__, __func__, ##args); \
	html("</body>"); \
	html_footer(); \
} while(0);

#define html_printf(fmt, args...) \
do { \
	fprintf(stdout, "<p style=\"font-family:Courier New;\">" fmt "</hp>\n", ##args); \
} while(0);

#define html_printdebug(fmt, args...) \
do { \
	fprintf(stdout, "<h4 style=\"font-family:Courier New;\"> %s:%d %s(): " fmt "</h4>\n", __FILE__, __LINE__, __func__, ##args); \
} while(0);

/* Declarations: */
void html_init(void);
void html_hello(void);
void html_load_page(const char *file);

#endif