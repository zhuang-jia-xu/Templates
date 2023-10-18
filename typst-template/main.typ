#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "2023 Fall Systems Programming PA1 Report",
  authors: (
    "莊加旭",
  ),
  date: "October 12, 2023",
)

// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!

+ *What is busy waiting? How do you avoid busy waiting in this assignment? Is it possible to have busy waiting even with select()/poll()?*

  Busy waiting means a process repeatedly checks for a condition or waits for an event without yielding the processor to other processes. The process keeps the processor busy by executing instructions in a loop, waisting CPU resources even when there is no work to be done.

  I use `poll()` to monitor incoming connections and new requests sent from connected clients on server. This allows the server to block until one or more of these sources becomes ready for some operation, thus prevents busy waiting.

  However, it is possible to have busy waiting even with `select()/poll()` if they are misused. For example, if a program calls select()/poll() with a timeout of zero and repeatedly invokes them in a loop, it effectively performs busy waiting. In such cases, the program is constantly checking for events without any delay, resulting in waisted CPU resources.

+ *What is starvation? Is it possible for a request to encounter starvation in this assignment? Please explain.*

  Starvation is a problem encountered when a process is perpetually denied necessary resources to process its work. In my implementation, every request begins with a header. After the header is recieved, the server will process the request and respond immediately. I also seperates the checking and actual posting into two requests, so the server don't need to wait for the client in any circumstances, therefore starvation should not happen on the server. However, I use blocking IO to read user input on the client, which might cause starvation if no input can be read from stdin. 

+ *How do you handle a file’s consistency when multiple requests within a process access to it simultaneously?*

  Since acquiring a lock on something that is already locked by the same process would not be blocked. I maintain an array storing whether a specific record is "locked" by the process itself in the server.

+ *How do you handle a file’s consistency when different process access to it simultaneously?*
 I use the `F_SETLK` option with `fcntl` to lock a record, which is a section of the `./BulletinBoard` file. This system call would fail if the record is already locked by a different process. If that's the case, to handl the file's consistency, the server shouldn't write to the record.
