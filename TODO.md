# Performance Options

* Try scaling with threads (divide file into chunks and give each chunk to
  its own thread)

* Try scaling with processes, open up pipes and have each process write
  the matching address to the parent process's pipe)

* Try caching so that each time a file is parsed, we cache the results and
  how far in the file we've looked.  Then on the next run start looking at
  the offset.
