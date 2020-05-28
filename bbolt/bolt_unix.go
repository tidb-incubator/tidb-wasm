// +build !windows,!plan9,!solaris

package bbolt

import (
	"time"
)

// flock acquires an advisory lock on a file descriptor.
func flock(db *DB, exclusive bool, timeout time.Duration) error {
	return nil
}

// funlock releases an advisory lock on a file descriptor.
func funlock(db *DB) error {
	return nil
}

// mmap memory maps a DB's data file.
func mmap(db *DB, sz int) error {
	return nil
}

// munmap unmaps a DB's data file from memory.
func munmap(db *DB) error {
	return nil
}

// NOTE: This function is copied from stdlib because it is not available on darwin.
func madvise(b []byte, advice int) (err error) {
	return nil
}
