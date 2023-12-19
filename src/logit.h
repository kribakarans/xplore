#ifndef __CGI_LOGIT_H__
#define __CGI_LOGIT_H__

#define logit(fmt, args...) (fprintf(stderr, "%17s:%-4d %17s: " fmt "\n", __FILE__, __LINE__, __func__, ##args))

#endif
