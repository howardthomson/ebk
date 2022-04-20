#include <sys/stat.h>
#include <sys/errno.h>

int efb_file_stat (char *path, struct stat *buf) {

	int status;

	for (;;) {
		status = stat (path, buf);
		if (status != EINTR)
			break;
	}
	return (status);
}

int efb_link_stat (char *path, struct stat *buf) {

	int status;

	for (;;) {
		status = lstat (path, buf);
		if (status != EINTR)
			break;
	}
	return (status);

}

int efb_is_directory (struct stat *buf) {

	return (S_ISDIR(buf->st_mode));
}

int efb_is_plain (struct stat *buf) {

	return (S_ISREG(buf->st_mode));
}

int efb_is_symlink (struct stat *buf) {

	return (S_ISLNK(buf->st_mode));
}