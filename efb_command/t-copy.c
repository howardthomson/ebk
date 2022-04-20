#include <sys/stat.h>


rt_public void file_stat (char *path, struct stat *buf)
           				/* Path name */
                 		/* Structure to fill in */
{
	/* This is an encapsulation of the stat() system call. The routine either
	 * succeeds and returns or fails and raises the appropriate exception.
	 */

	int status;			/* System call status */
	
	for (;;) {
		errno = 0;						/* Reset error condition */
#ifdef HAS_LSTAT
		status = lstat(path, buf);
		if (status == 0) {
			/* We found a file, now let's check if it is not a symbolic link,
			 * if it is the case, we need to call `stat' to make sure the link
			 * is valid. It is going to slow down current call by stating twice
			 * the info, but this case is quite rare and there is a benefit
			 * in using `lstat' over `stat' the first time as more than 90%
			 * of the files we stat are not symlink. */
			if ((buf->st_mode & S_IFLNK) == S_IFLNK) {
				status = stat (path, buf);
			}
		}
#else
		status = stat(path, buf);		/* Get file statistics */
#endif
		if (status == -1) {				/* An error occurred */
			if (errno == EINTR)			/* Interrupted by signal */
				continue;				/* Re-issue system call */
			else
				esys();					/* Raise exception */
		}
		break;
	}
#if defined EIF_VMS && defined _VMS_V6_SOURCE
	buf->st_uid &= 0x0000FFFF ;		/* VMS: mask out group id */
#endif
}

