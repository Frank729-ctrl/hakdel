-- 003_quiz_questions.sql
-- 330 questions: 11 categories × 3 tiers × 10 questions
-- tier1=easy(10pts), tier2=medium(20pts), tier3=hard(30pts)
-- Run: mysql -u root -pShequan123! hakdel < database/003_quiz_questions.sql

USE hakdel;

-- ════════════════════════════════════════════════════════
-- 1. IT FUNDAMENTALS  (slug: it-fundamentals)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

-- Tier 1 (easy, 10 pts)
('it-fundamentals','IT Fundamentals',1,
 'What does CPU stand for?',
 'Central Processing Unit','Core Processing Utility','Central Program Unit','Computer Processing Unit',
 'a','The CPU (Central Processing Unit) is the primary component that executes instructions in a computer.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'Which of the following is volatile memory that loses its contents when power is removed?',
 'HDD','SSD','ROM','RAM',
 'd','RAM (Random Access Memory) is volatile — its contents are lost when the computer is powered off. ROM, HDD, and SSD retain data.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'What is the function of an operating system?',
 'Manage hardware resources and provide services to applications',
 'Browse the internet',
 'Compile source code into machine code',
 'Encrypt files on disk',
 'a','An OS manages hardware resources (CPU, memory, I/O) and provides an interface for applications to run.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'Which storage device uses spinning magnetic platters?',
 'SSD','USB flash drive','HDD','ROM chip',
 'c','HDDs (Hard Disk Drives) use spinning magnetic platters. SSDs use flash memory with no moving parts.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'What does BIOS stand for?',
 'Basic Input/Output System','Binary Integrated Operating Software','Base Input Output Storage','Boot Initialisation Operating System',
 'a','BIOS (Basic Input/Output System) is firmware that initialises hardware during the boot process before handing off to the OS.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'Which of the following is an example of an input device?',
 'Monitor','Printer','Keyboard','Speaker',
 'c','A keyboard sends data into the computer. Monitors, printers, and speakers are output devices.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'What does LAN stand for?',
 'Large Area Network','Local Area Network','Linked Application Node','Layered Access Network',
 'b','LAN (Local Area Network) connects devices within a limited area such as a home, office, or building.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'Which numbering system does a computer use internally?',
 'Decimal (base 10)','Hexadecimal (base 16)','Octal (base 8)','Binary (base 2)',
 'd','Computers operate on binary (base 2) — all data is represented as 0s and 1s at the hardware level.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'What is the purpose of a file system?',
 'Connect computers to a network',
 'Organise and manage files on a storage device',
 'Execute programs faster',
 'Protect against malware',
 'b','A file system (e.g. NTFS, ext4, FAT32) organises data on storage devices into files and directories.','easy',1,10),

('it-fundamentals','IT Fundamentals',1,
 'Which of these is a common Windows file system?',
 'ext4','ZFS','NTFS','HFS+',
 'c','NTFS (New Technology File System) is the default file system for modern Windows. ext4 is Linux, HFS+ is macOS.','easy',1,10),

-- Tier 2 (medium, 20 pts)
('it-fundamentals','IT Fundamentals',1,
 'What is the difference between 32-bit and 64-bit operating systems?',
 '64-bit is only for servers',
 '32-bit supports more RAM than 64-bit',
 '64-bit can address more memory and process larger data chunks simultaneously',
 'There is no practical difference',
 'c','A 64-bit OS can address up to 16 exabytes of memory vs ~4 GB for 32-bit, and processes data in 64-bit chunks.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'What is the role of a device driver?',
 'Connects two LANs together',
 'Provides a standardised interface between the OS and hardware devices',
 'Boots the operating system from disk',
 'Encrypts data sent to peripherals',
 'b','Device drivers act as translators between OS calls and hardware-specific commands, enabling the OS to control diverse hardware.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'What does RAID 1 provide?',
 'Striping for performance','Mirroring for redundancy','Parity for fault tolerance','Compression for capacity',
 'b','RAID 1 mirrors data across two or more disks. If one fails, the mirror survives. It provides redundancy but no performance gain over a single disk.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'Which TCP/IP layer handles routing between networks?',
 'Application','Transport','Internet (Network)','Link (Data Link)',
 'c','The Internet layer (Layer 3) handles IP addressing and routing packets between different networks using routers.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'What is virtualisation in computing?',
 'Converting analogue signals to digital',
 'Running multiple virtual machines on a single physical host',
 'Compressing files to save space',
 'Connecting remote computers via VPN',
 'b','Virtualisation uses a hypervisor to run multiple isolated OS instances on a single physical machine, improving resource utilisation.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'What is the purpose of a subnet mask?',
 'Encrypt network traffic','Identify the network and host portions of an IP address','Assign IP addresses automatically','Filter incoming connections',
 'b','A subnet mask (e.g. 255.255.255.0) identifies which part of an IP address is the network and which is the host.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'What does POST stand for in the boot process?',
 'Power-On Self-Test','Program Operating System Transfer','Primary Output Storage Test','Protocol Output Scanning Tool',
 'a','POST (Power-On Self-Test) runs at startup to verify that essential hardware components are functioning before the OS loads.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'What is the difference between a process and a thread?',
 'A process is lighter weight than a thread',
 'Threads do not share memory; processes do',
 'A process is an independent program; threads are units of execution within a process sharing its memory',
 'They are identical concepts in modern OSes',
 'c','A process has its own memory space. Threads within a process share memory, making inter-thread communication faster but requiring synchronisation.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'What is the primary purpose of a UPS (Uninterruptible Power Supply)?',
 'Speed up CPU performance',
 'Provide temporary power during outages to allow safe shutdown',
 'Cool server components',
 'Filter network traffic',
 'b','A UPS provides battery backup power when the mains supply fails, giving time for safe system shutdown or generator startup.','medium',2,20),

('it-fundamentals','IT Fundamentals',1,
 'What protocol automatically assigns IP addresses to devices on a network?',
 'DNS','DHCP','FTP','SNMP',
 'b','DHCP (Dynamic Host Configuration Protocol) automatically assigns IP addresses, subnet masks, gateways, and DNS servers to devices.','medium',2,20),

-- Tier 3 (hard, 30 pts)
('it-fundamentals','IT Fundamentals',1,
 'In RAID 5, a minimum of how many disks is required, and what is the fault tolerance?',
 '2 disks, 1 can fail','3 disks, 1 can fail','4 disks, 2 can fail','2 disks, 0 can fail',
 'b','RAID 5 uses distributed parity across at least 3 disks. Any single disk can fail and data can be rebuilt from parity.','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'What is the difference between NVMe and SATA SSDs?',
 'NVMe uses the PCIe bus and is significantly faster; SATA is limited by the older SATA interface',
 'SATA SSDs use PCIe; NVMe uses USB',
 'NVMe drives are larger in physical size',
 'There is no speed difference between them',
 'a','NVMe (Non-Volatile Memory Express) uses PCIe lanes, achieving ~3500 MB/s+. SATA SSDs are capped at ~600 MB/s by the SATA interface.','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'Which CPU scheduling algorithm can cause starvation of low-priority processes?',
 'Round Robin','First-Come First-Served','Priority Scheduling','Shortest Job First',
 'c','Priority Scheduling always runs the highest-priority process first. Low-priority processes may never execute if high-priority processes keep arriving — this is starvation.','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'What is the function of the Memory Management Unit (MMU)?',
 'Store the BIOS firmware',
 'Translate virtual memory addresses to physical addresses',
 'Manage disk I/O operations',
 'Schedule CPU time between processes',
 'b','The MMU performs virtual-to-physical address translation using a page table, enabling memory isolation between processes.','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'In the context of operating systems, what is a deadlock?',
 'A crashed application that cannot be closed',
 'A situation where two or more processes wait indefinitely for resources held by each other',
 'An OS that fails to boot',
 'A corrupted file system that cannot be read',
 'b','Deadlock occurs when processes circularly wait for resources (Coffman conditions: mutual exclusion, hold-and-wait, no preemption, circular wait).','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'What does UEFI improve over legacy BIOS?',
 'UEFI supports only 32-bit systems',
 'UEFI supports larger disks (>2TB via GPT), faster boot, Secure Boot, and a graphical interface',
 'UEFI removes the need for an OS',
 'UEFI only works with Windows',
 'b','UEFI (Unified Extensible Firmware Interface) supports GPT disks (>2 TB), Secure Boot to verify OS integrity, faster initialisation, and a mouse-driven UI.','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'What is cache memory and why is it used?',
 'It is a backup storage system for hard drives',
 'It is slow storage used for archival',
 'It is small, fast memory between the CPU and RAM that stores frequently accessed data to reduce latency',
 'It is the memory used by the GPU',
 'c','CPU cache (L1, L2, L3) sits between the processor and main RAM. Accessing cache takes nanoseconds vs tens of nanoseconds for RAM, dramatically improving performance.','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'What is the purpose of an interrupt in an operating system?',
 'To stop the CPU permanently',
 'To signal the CPU that a hardware or software event needs immediate attention, preempting current execution',
 'To encrypt memory pages',
 'To allocate new processes in the queue',
 'b','Interrupts (hardware or software) signal the CPU to pause current execution, save state, run an interrupt handler, then resume. Essential for I/O and timers.','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'What is thrashing in operating systems?',
 'A type of network attack',
 'Excessive paging activity where the OS spends more time swapping pages than executing processes',
 'Overclocking the CPU beyond safe limits',
 'A disk fragmentation condition',
 'b','Thrashing occurs when a system has insufficient RAM, causing constant page faults and swapping. The OS spends most time on memory management instead of useful work.','hard',3,30),

('it-fundamentals','IT Fundamentals',1,
 'What does the term "endianness" refer to in computing?',
 'The direction data travels on a bus',
 'The byte order in which multi-byte data is stored in memory (big-endian vs little-endian)',
 'The orientation of bits within a single byte',
 'The encoding format of character sets',
 'b','Big-endian stores the most significant byte first (e.g. network protocols). Little-endian stores the least significant byte first (e.g. x86 CPUs). Matters in binary protocols and cross-platform data exchange.','hard',3,30),

-- ════════════════════════════════════════════════════════
-- 2. TERMINAL & LINUX  (slug: terminal-linux)
-- ════════════════════════════════════════════════════════

-- Tier 1
('terminal-linux','Terminal & Linux',2,
 'Which command lists files in the current directory?',
 'dir','show','ls','list',
 'c','`ls` lists directory contents on Linux/Unix systems. Flags like -la show hidden files and details.','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'What does `pwd` display?',
 'List of running processes','Current user password','Present working directory','Port numbers in use',
 'c','`pwd` (Print Working Directory) outputs the absolute path of your current directory.','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'Which command creates a new directory?',
 'newdir','createdir','mkdir','makedir',
 'c','`mkdir dirname` creates a new directory. Use `mkdir -p` to create nested directories in one command.','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'What does `rm -rf` do?',
 'Renames a file','Removes a directory and all its contents recursively and forcefully',
 'Restores deleted files','Runs a file as root',
 'b','`rm -r` removes directories recursively; `-f` forces deletion without prompts. Use with extreme caution — there is no recycle bin.','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'What command displays the contents of a text file?',
 'view','open','cat','read',
 'c','`cat filename` outputs file contents to the terminal. `less` is better for large files (allows scrolling).','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'Which command copies a file?',
 'mv','cp','ln','rp',
 'b','`cp source destination` copies a file. `mv` moves/renames it. `ln` creates a hard or symbolic link.','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'What permission does chmod 755 grant?',
 'Owner: rwx, Group: r-x, Others: r-x',
 'Owner: rwx, Group: rwx, Others: rwx',
 'Owner: rw-, Group: r--, Others: r--',
 'Owner: rwx, Group: rw-, Others: r--',
 'a','In octal: 7=rwx, 5=r-x. So 755 = owner can read/write/execute; group and others can read/execute.','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'What does the pipe operator `|` do?',
 'Runs two commands simultaneously','Sends the output of one command as input to another','Redirects output to a file','Runs a command in the background',
 'b','The pipe chains commands: `ls | grep .txt` sends ls output to grep. Fundamental to the Unix philosophy of small composable tools.','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'Which file contains user account information on Linux?',
 '/etc/group','/etc/shadow','/etc/users','/etc/passwd',
 'd','`/etc/passwd` stores user account info (username, UID, GID, home, shell). Passwords are in `/etc/shadow`.','easy',1,10),

('terminal-linux','Terminal & Linux',2,
 'What does `sudo` allow you to do?',
 'Switch to a different shell',
 'Execute a command with superuser (root) privileges',
 'Search for a command',
 'Show disk usage',
 'b','`sudo` (superuser do) runs the following command with root privileges, provided the user is in the sudoers list.','easy',1,10),

-- Tier 2
('terminal-linux','Terminal & Linux',2,
 'What does `grep -r "pattern" /etc/` do?',
 'Replaces pattern in all files under /etc',
 'Recursively searches for pattern in all files under /etc and prints matching lines',
 'Counts occurrences of pattern in /etc',
 'Deletes files matching pattern in /etc',
 'b','`grep -r` recurses into subdirectories. Combined with patterns this is how you search config files for specific values (e.g. API keys).','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'What is the difference between `>` and `>>` in shell redirection?',
 '`>` appends; `>>` overwrites','`>` overwrites; `>>` appends',
 '`>` redirects stdin; `>>` redirects stderr',
 'There is no difference',
 'b','`>` overwrites the file (truncates). `>>` appends to it. `2>` redirects stderr. `&>` redirects both stdout and stderr.','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'How do you make a script executable?',
 'bash script.sh --exec','source script.sh','chmod +x script.sh','run script.sh',
 'c','`chmod +x` adds the execute bit. After that you can run it as `./script.sh`. The shebang line (`#!/bin/bash`) determines the interpreter.','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'What does `ps aux` display?',
 'Network connections','Disk usage','All running processes for all users with detailed info','System performance stats',
 'c','`ps aux` shows all processes (a=all users, u=user-friendly format, x=processes without tty). Use with `grep` to find specific processes.','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'What is the purpose of `/etc/crontab`?',
 'Store user passwords','Define scheduled tasks (cron jobs)','Configure the firewall','List installed packages',
 'b','Crontab defines scheduled commands. Format: `minute hour day month weekday user command`. User-level crons are in `/var/spool/cron/`.','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'How do you find all files larger than 100MB under /var?',
 'ls -l /var | grep 100M',
 'find /var -size +100M',
 'du -h /var > 100M',
 'locate /var 100M',
 'b','`find` with `-size +100M` finds files exceeding 100 MB. Use `-type f` to restrict to files only.','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'What does `netstat -tulpn` show?',
 'Active firewall rules',
 'All listening TCP/UDP ports with PID/program name',
 'Network interface statistics',
 'ARP cache entries',
 'b','`-t` TCP, `-u` UDP, `-l` listening, `-p` PID/program, `-n` numeric addresses. Useful for spotting unexpected open ports.','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'What is a symbolic (soft) link in Linux?',
 'A copy of a file',
 'A pointer that references another file by path; if the target is deleted the link breaks',
 'A hard reference to the same inode as another file',
 'A compressed archive of a file',
 'b','A symlink (`ln -s target link`) stores the path to the target. If the target is removed, the symlink breaks. Hard links reference the same inode and persist.','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'Which command shows disk usage of directories in human-readable format?',
 'df -h','ls -lh','du -sh *','fdisk -l',
 'c','`du -sh *` (disk usage, summarise, human-readable) shows the size of each item in the current directory.','medium',2,20),

('terminal-linux','Terminal & Linux',2,
 'What does the `&&` operator do between two commands?',
 'Runs the second command regardless of the first''s exit code',
 'Runs both commands in parallel',
 'Runs the second command only if the first succeeds (exit code 0)',
 'Runs commands in the background',
 'c','`cmd1 && cmd2` executes cmd2 only when cmd1 exits with 0 (success). `||` runs cmd2 only on failure.','medium',2,20),

-- Tier 3
('terminal-linux','Terminal & Linux',2,
 'What is the difference between `/etc/passwd` and `/etc/shadow`?',
 '/etc/passwd stores encrypted passwords; /etc/shadow stores plaintext',
 '/etc/passwd stores account metadata readable by all users; /etc/shadow stores hashed passwords readable only by root',
 'They are identical; one is a backup',
 '/etc/shadow is used on Debian; /etc/passwd on Red Hat',
 'b','`/etc/passwd` is world-readable and contains UID/GID/shell. `/etc/shadow` (readable only by root) contains the salted password hash and expiry info.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'In bash, what does `2>&1` mean?',
 'Run the command twice','Redirect stderr (fd 2) to wherever stdout (fd 1) currently points',
 'Send output to two files simultaneously','Background the command with priority 2',
 'b','File descriptor 1 = stdout, 2 = stderr. `2>&1` merges stderr into stdout. Common: `cmd > out.txt 2>&1` captures everything.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'What does the sticky bit on a directory do?',
 'Prevents the directory from being deleted',
 'Makes files execute with owner privileges',
 'Only allows the file owner (or root) to delete or rename files within the directory',
 'Marks the directory as read-only',
 'c','The sticky bit (chmod +t or 1xxx) on `/tmp` prevents users from deleting each other''s files even though everyone has write permission.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'What is the purpose of `iptables -A INPUT -p tcp --dport 22 -j ACCEPT`?',
 'Block all TCP traffic on port 22',
 'Append a rule to the INPUT chain that accepts incoming TCP connections on port 22',
 'Log connections to port 22',
 'Delete existing rules for port 22',
 'b','iptables rule: `-A INPUT` appends to INPUT chain, `-p tcp` TCP protocol, `--dport 22` destination port 22 (SSH), `-j ACCEPT` accepts the packet.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'What does `lsof -i :80` display?',
 'Log files associated with port 80',
 'List of all processes that have port 80 open',
 'Firewall rules for port 80',
 'HTTP traffic on port 80',
 'b','`lsof` (list open files) with `-i :port` shows which processes have that port open. Critical for identifying what is listening on a port.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'What is the setuid bit and when is it a security risk?',
 'Allows group members to execute a file',
 'Makes a program execute with the file owner''s privileges; risky if a setuid root binary has a vulnerability allowing privilege escalation',
 'Prevents files from being modified',
 'Enables remote execution via SSH',
 'b','Setuid programs run as the file owner. If root-owned and exploitable (e.g. buffer overflow), an attacker can gain root. Search: `find / -perm -4000` finds setuid binaries.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'What is the difference between `kill` and `kill -9`?',
 'There is no difference; both terminate a process immediately',
 '`kill` sends SIGTERM (15) allowing the process to clean up; `kill -9` sends SIGKILL which the OS forces immediately with no cleanup',
 '`kill` only works on zombie processes',
 '`kill -9` is for background processes only',
 'b','SIGTERM (default) requests graceful shutdown — the process can ignore it or clean up. SIGKILL cannot be caught or ignored; the kernel removes the process immediately.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'What does `/proc` represent in Linux?',
 'A disk partition for programs','A virtual filesystem exposing kernel and process information in real time',
 'The root user''s home directory','Log files for system processes',
 'b','`/proc` is a virtual filesystem (procfs) — no disk storage. `/proc/PID/` exposes process memory maps, open files, etc. `/proc/sys/` exposes kernel parameters.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'What command shows the last 50 lines of a log file and follows new entries in real time?',
 'cat -n 50 /var/log/syslog','head -50 /var/log/syslog',
 'tail -n 50 -f /var/log/syslog','less +50 /var/log/syslog',
 'c','`tail -f` (follow) watches the file for new lines. `-n 50` shows the last 50 lines first. Essential for live log monitoring.','hard',3,30),

('terminal-linux','Terminal & Linux',2,
 'What is the purpose of `ssh-keygen` and how does public key auth work?',
 'Generates SSL certificates for web servers',
 'Generates an RSA/Ed25519 key pair; the public key is placed on the server; the client proves possession of the private key without transmitting it',
 'Encrypts files using AES',
 'Generates one-time passwords for 2FA',
 'b','`ssh-keygen` creates a key pair. The public key goes into `~/.ssh/authorized_keys` on the server. Auth uses challenge-response: server sends a random value encrypted with the public key; only the private key can decrypt it.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 3. CS FUNDAMENTALS  (slug: cs-fundamentals)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

-- Tier 1
('cs-fundamentals','CS Fundamentals',3,
 'What is an algorithm?',
 'A programming language','A step-by-step procedure for solving a problem','A type of data storage','A computer network protocol',
 'b','An algorithm is a finite, well-defined sequence of instructions for solving a problem or performing a computation.','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'What is the time complexity of accessing an element in an array by index?',
 'O(n)','O(log n)','O(1)','O(n²)',
 'c','Array index access is O(1) — constant time — because the memory address is calculated directly from the base address and index.','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'Which data structure operates on a LIFO (Last-In First-Out) basis?',
 'Queue','Linked list','Stack','Tree',
 'c','A stack is LIFO: the last item pushed is the first popped. Used in function call management, undo operations, and expression evaluation.','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'What is a queue data structure?',
 'LIFO: last in, first out','FIFO: first in, first out','A sorted tree structure','A key-value store',
 'b','A queue is FIFO — elements are dequeued in the order they were enqueued. Used in task scheduling, BFS, and message buffers.','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'What does OOP stand for?',
 'Object-Oriented Programming','Open Operating Protocol','Output Optimised Processing','Object Operational Pipeline',
 'a','OOP organises code around objects that combine data (attributes) and behaviour (methods), promoting reusability through inheritance and encapsulation.','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'What is the difference between compiled and interpreted languages?',
 'Compiled languages are slower','Compiled languages translate code to machine code before execution; interpreted languages execute source code line by line at runtime',
 'Interpreted languages are always faster','There is no real difference today',
 'b','Compilers (e.g. C, Go) produce standalone executables. Interpreters (e.g. Python, Ruby) execute source or bytecode at runtime, enabling faster development but typically slower execution.','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'What is recursion?',
 'Running two threads simultaneously','A function that calls itself with a smaller subproblem until reaching a base case',
 'Looping through an array backwards','Storing data in a tree structure',
 'b','Recursion: a function calls itself. Must have a base case to stop. Used in tree traversal, divide-and-conquer algorithms, and problems like Fibonacci.','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'What does a linked list consist of?',
 'Contiguous memory blocks indexed by number',
 'Nodes where each node stores data and a pointer to the next node',
 'Key-value pairs with O(1) lookup',
 'A balanced binary tree',
 'b','A linked list stores nodes non-contiguously. Each node has a data field and a next pointer. Insertion/deletion O(1) at head; search O(n).','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'What is the purpose of version control systems like Git?',
 'Speed up code compilation',
 'Track changes to source code over time, enabling collaboration and rollback',
 'Deploy applications to servers',
 'Encrypt source code',
 'b','Git tracks every change as a commit with author, timestamp, and diff. Teams can branch, merge, and revert, preventing data loss and enabling parallel work.','easy',1,10),

('cs-fundamentals','CS Fundamentals',3,
 'What is Big O notation used for?',
 'Measuring code style quality','Describing the upper-bound time or space complexity of an algorithm as input size grows',
 'Counting lines of code','Measuring memory leaks',
 'b','Big O classifies algorithms by how runtime or memory scales with input size n. O(1) constant, O(n) linear, O(n²) quadratic, O(log n) logarithmic.','easy',1,10),

-- Tier 2
('cs-fundamentals','CS Fundamentals',3,
 'What is the time complexity of binary search on a sorted array?',
 'O(n)','O(n log n)','O(log n)','O(1)',
 'c','Binary search halves the search space each step. For n=1000, it takes at most 10 comparisons (log₂1000 ≈ 10).','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What is the difference between a tree and a graph?',
 'Trees can have cycles; graphs cannot','A tree is a connected acyclic graph; a graph can have cycles and disconnected components',
 'Graphs are always directed; trees are not','There is no difference',
 'b','A tree is a special graph: connected, undirected (or directed toward root), and acyclic with exactly n-1 edges for n nodes.','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What is a hash table and what is its average-case lookup complexity?',
 'A sorted array with O(log n) lookup',
 'A data structure mapping keys to values via a hash function with O(1) average lookup',
 'A balanced binary search tree with O(log n) lookup',
 'A linked list with O(n) lookup',
 'b','Hash tables use a hash function to compute an index. Average O(1) for insert/lookup/delete. Worst case O(n) with many collisions (handled by chaining or open addressing).','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What is the difference between heap memory and stack memory?',
 'Stack is for long-lived objects; heap is for short-lived function data',
 'Stack holds local variables and function call frames (auto-managed, LIFO, limited size); heap holds dynamically allocated objects (manually or GC managed, larger)',
 'They are identical; the OS chooses which to use',
 'Heap is faster than stack for all operations',
 'b','Stack: fast, automatically reclaimed on function return, limited size. Heap: flexible size, requires manual `free()` or garbage collection, used for objects with dynamic lifetime.','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What sorting algorithm has best-case O(n) and worst-case O(n²)?',
 'Merge sort','Quick sort','Insertion sort','Heap sort',
 'c','Insertion sort: O(n) when array is already sorted (best case), O(n²) worst case (reverse sorted). Efficient in practice for small or nearly sorted arrays.','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What is dynamic programming?',
 'Programming applications that change UI at runtime',
 'An optimisation technique that solves complex problems by breaking them into overlapping subproblems and storing results to avoid recomputation',
 'A way to dynamically allocate memory',
 'Multi-threaded programming using dynamic threads',
 'b','DP stores subproblem results (memoisation or tabulation) to avoid redundant computation. Examples: Fibonacci, shortest path (Dijkstra), 0/1 knapsack.','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What is polymorphism in OOP?',
 'An object inheriting from multiple classes',
 'The ability of different objects to respond to the same interface/method call with their own behaviour',
 'Hiding internal object state',
 'Preventing a class from being instantiated',
 'b','Polymorphism (runtime): a base class reference can point to a derived class object and call overridden methods. Enables writing code against abstractions.','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What is a deadlock in concurrent programming?',
 'A thread waiting for user input',
 'A state where two or more threads are each holding a resource the other needs, waiting indefinitely',
 'A thread that runs too slowly',
 'Memory corruption from two threads writing simultaneously',
 'b','Classic deadlock: Thread A holds lock 1, wants lock 2. Thread B holds lock 2, wants lock 1. Both wait forever. Prevention: acquire locks in consistent order.','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What does API stand for and what is its purpose?',
 'Application Protocol Interface — defines network packet formats',
 'Application Programming Interface — a defined contract allowing software components to communicate',
 'Automated Program Installer — manages software dependencies',
 'Async Process Integration — enables parallel execution',
 'b','An API defines how software components interact: what functions are available, their inputs/outputs, and expected behaviour. REST APIs use HTTP; library APIs define function signatures.','medium',2,20),

('cs-fundamentals','CS Fundamentals',3,
 'What is the difference between TCP and UDP?',
 'TCP is connectionless and faster; UDP guarantees delivery',
 'TCP establishes a connection, guarantees ordered delivery, and performs error checking; UDP is connectionless with lower overhead but no delivery guarantee',
 'UDP is only used for file transfers',
 'TCP does not use checksums',
 'b','TCP: 3-way handshake, acknowledgements, retransmission — reliable but slower. UDP: no connection setup, minimal overhead — suited for DNS, video streaming, gaming.','medium',2,20),

-- Tier 3
('cs-fundamentals','CS Fundamentals',3,
 'What is the difference between NP, NP-hard, and NP-complete?',
 'They are identical; just different notations',
 'NP: problems verifiable in polynomial time. NP-hard: at least as hard as NP problems. NP-complete: both NP and NP-hard (e.g. Traveling Salesman)',
 'NP problems are unsolvable; NP-hard are solvable in O(n²)',
 'NP-complete problems can be solved in polynomial time',
 'b','P⊆NP. NP-hard has no polynomial-time verifier. NP-complete is the intersection: in NP and every NP problem reduces to it. Solving any NP-complete in P would prove P=NP.','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'What is a B-tree and why is it used in databases?',
 'A binary search tree with O(log n) lookup',
 'A self-balancing m-ary tree where nodes can have many children, minimising disk I/O by keeping tree height low',
 'A data structure for string prefix searching',
 'A tree used only for in-memory sorting',
 'b','B-trees keep data sorted in nodes of up to m children. Databases use them for indexes because a single disk read fetches many keys, and tree height stays O(log_m n), minimising expensive disk seeks.','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'What is the CAP theorem?',
 'A distributed system can be consistent, available, and partition-tolerant simultaneously',
 'A distributed system can guarantee at most two of: Consistency, Availability, and Partition tolerance',
 'Cache, Access, and Performance are the three pillars of system design',
 'Complexity, Accuracy, and Precision are trade-offs in algorithms',
 'b','CAP (Brewer''s theorem): in the presence of a network partition, a distributed system must choose between consistency (all nodes see same data) and availability (every request gets a response).','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'In garbage-collected languages, what is a memory leak and can it still occur?',
 'No; garbage collection prevents all memory leaks',
 'Yes; memory leaks occur when objects are still reachable (referenced) but no longer needed, preventing the GC from collecting them',
 'Memory leaks only occur in C and C++',
 'A memory leak means the GC is running too frequently',
 'b','GC prevents dangling pointer leaks but not logical leaks — keeping references to objects you no longer need (e.g. ever-growing caches, event listeners never removed).','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'What is the difference between concurrency and parallelism?',
 'They are identical concepts',
 'Concurrency is structuring a program to handle multiple tasks that can overlap in time; parallelism is executing multiple computations simultaneously on multiple cores',
 'Parallelism is for I/O; concurrency is for CPU-bound tasks',
 'Concurrency requires multiple CPUs',
 'b','Concurrency: dealing with multiple things at once (can be on one CPU via context switching). Parallelism: doing multiple things at once (requires multiple CPUs/cores).','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'What is a trie and what is it optimised for?',
 'A balanced binary search tree for integers',
 'A tree structure where each node represents a character; optimised for prefix-based string searching and autocomplete',
 'A cache replacement algorithm',
 'A type of hash table for strings',
 'b','Tries store strings character by character. Lookup is O(L) where L is string length, regardless of how many strings are stored. Used in autocomplete, spell checking, and IP routing tables.','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'What is the difference between process memory segments: text, data, BSS, heap, and stack?',
 'They are different names for the same memory region',
 'Text: compiled code (read-only). Data: initialised globals. BSS: uninitialised globals. Heap: dynamic allocation. Stack: function frames and locals.',
 'Stack and heap are the same; text and data are the same',
 'BSS is the boot sector; text is user data',
 'b','Process address space segments: text (executable code), data (initialised static/global vars), BSS (zero-initialised statics), heap (malloc/new), stack (call frames, local vars).','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'What is eventual consistency in distributed systems?',
 'All nodes always have identical data at all times',
 'Given no new updates, all replicas will eventually converge to the same value, but may temporarily differ',
 'The system guarantees zero data loss',
 'Read operations always return the most recent write',
 'b','Eventual consistency (BASE model) trades strong consistency for availability. DNS and NoSQL databases like Cassandra use it. It''s suitable when temporary stale reads are acceptable.','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'What is the two''s complement representation used for?',
 'Representing floating-point numbers','Representing signed integers in binary so that addition and subtraction use the same hardware circuit',
 'Encoding ASCII characters','Compressing binary data',
 'b','Two''s complement: flip all bits and add 1. A single adder circuit handles both addition and subtraction of signed integers. 8-bit range: -128 to 127.','hard',3,30),

('cs-fundamentals','CS Fundamentals',3,
 'What is memoisation and how does it differ from tabulation?',
 'They are identical',
 'Memoisation is top-down DP (recursive, cache results on first call); tabulation is bottom-up DP (iterative, fill table from base cases up)',
 'Tabulation is for strings only; memoisation is for numbers',
 'Memoisation always uses less memory',
 'b','Both avoid recomputation. Memoisation recurses and caches. Tabulation iterates in dependency order. Tabulation often has better constant factors; memoisation is simpler to code from a recursive solution.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 4. NETWORKING  (slug: networking)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

-- Tier 1
('networking','Networking',4,
 'How many layers does the OSI model have?',
 '4','5','7','9',
 'c','The OSI model has 7 layers: Physical, Data Link, Network, Transport, Session, Presentation, Application.','easy',1,10),

('networking','Networking',4,
 'What protocol translates domain names to IP addresses?',
 'DHCP','FTP','DNS','SMTP',
 'c','DNS (Domain Name System) resolves human-readable names like example.com to IP addresses. It operates on UDP/TCP port 53.','easy',1,10),

('networking','Networking',4,
 'What is the default port for HTTPS?',
 '80','443','8080','22',
 'b','HTTPS uses port 443. HTTP uses port 80. SSH uses 22. Alternate HTTP is often 8080.','easy',1,10),

('networking','Networking',4,
 'What class of IP address does 192.168.1.1 belong to?',
 'Class A','Class B','Class C','Class D',
 'c','Class C: 192.0.0.0–223.255.255.255, /24 default mask. 192.168.x.x is private Class C range (RFC 1918).','easy',1,10),

('networking','Networking',4,
 'What does ARP do?',
 'Assigns IP addresses dynamically',
 'Resolves an IP address to a MAC address on the local network',
 'Encrypts layer 2 traffic',
 'Routes packets between subnets',
 'b','ARP (Address Resolution Protocol) broadcasts "Who has IP x.x.x.x?" and receives the MAC address of the owner, enabling layer 2 frame delivery.','easy',1,10),

('networking','Networking',4,
 'What is the purpose of a default gateway?',
 'Assign local IP addresses','Act as the exit point for traffic destined outside the local subnet','Resolve hostnames to IPs','Encrypt network traffic',
 'b','The default gateway (typically the router) forwards packets whose destination IP is outside the local network. Without it, hosts can only communicate locally.','easy',1,10),

('networking','Networking',4,
 'What is a MAC address?',
 'A logical address assigned by DHCP',
 'A 48-bit hardware identifier burned into a network interface card',
 'A domain name alias',
 'An IPv6 address format',
 'b','MAC (Media Access Control) addresses are 48-bit hardware identifiers (e.g. AA:BB:CC:DD:EE:FF). They operate at Layer 2. The first 24 bits (OUI) identify the manufacturer.','easy',1,10),

('networking','Networking',4,
 'Which protocol is used to send email?',
 'IMAP','POP3','SMTP','FTP',
 'c','SMTP (Simple Mail Transfer Protocol, port 25/587/465) sends email between servers and from clients to servers. IMAP/POP3 retrieve email.','easy',1,10),

('networking','Networking',4,
 'What does NAT do?',
 'Assigns MAC addresses',
 'Translates private IP addresses to a public IP for internet communication',
 'Filters firewall rules',
 'Encrypts LAN traffic',
 'b','NAT (Network Address Translation) lets many private IPs share one public IP. The router rewrites source IPs of outbound packets and tracks the mappings to route replies back.','easy',1,10),

('networking','Networking',4,
 'What is a VLAN?',
 'A type of wireless network','A virtual LAN that logically segments a physical network into isolated broadcast domains',
 'A VPN protocol','A DHCP reservation',
 'b','VLANs (tagged with 802.1Q) create isolated broadcast domains on the same physical switches. Traffic between VLANs requires routing (inter-VLAN routing).','easy',1,10),

-- Tier 2
('networking','Networking',4,
 'What is the TCP 3-way handshake sequence?',
 'SYN → ACK → SYN-ACK','ACK → SYN → FIN','SYN → SYN-ACK → ACK','FIN → ACK → RST',
 'c','TCP connection establishment: client sends SYN, server responds SYN-ACK, client confirms with ACK. This establishes sequence numbers for reliable delivery.','medium',2,20),

('networking','Networking',4,
 'What is BGP and what is it used for?',
 'A LAN routing protocol for small networks',
 'The Border Gateway Protocol — the routing protocol of the internet that exchanges routes between autonomous systems',
 'A link-layer protocol for Ethernet frames',
 'A DNS security extension',
 'b','BGP (port 179) is the internet''s path-vector routing protocol. ISPs and large organisations use it to announce their IP prefixes and control traffic flow between autonomous systems.','medium',2,20),

('networking','Networking',4,
 'What is the difference between a hub, switch, and router?',
 'They are identical devices with different names',
 'Hub: broadcasts to all ports (Layer 1). Switch: forwards to specific MAC (Layer 2). Router: routes between networks using IP (Layer 3).',
 'Routers operate at Layer 2; switches at Layer 3',
 'Switches broadcast to all ports like hubs',
 'b','Hubs broadcast everything — creates collision domains. Switches use MAC address tables to forward frames only to the correct port. Routers use IP routing tables.','medium',2,20),

('networking','Networking',4,
 'What is a subnet? Calculate usable hosts in /24.',
 'A VLAN tag','A logical division of an IP network; /24 has 254 usable host addresses',
 '/24 has 256 usable hosts','A subnet is only used for IPv6',
 'b','/24 = 256 addresses - 1 network address - 1 broadcast = 254 usable hosts. Formula: 2^(32-prefix) - 2.','medium',2,20),

('networking','Networking',4,
 'What is ICMP and what is it used for?',
 'A protocol for transferring files','Internet Control Message Protocol — used for diagnostic tools like ping and traceroute',
 'A protocol for encrypting IP packets','A transport protocol like TCP',
 'b','ICMP sends control messages: echo request/reply (ping), destination unreachable, TTL exceeded (traceroute). Not used for data transport.','medium',2,20),

('networking','Networking',4,
 'What is a CDN (Content Delivery Network)?',
 'A type of VPN','A distributed network of servers that caches content near users to reduce latency and origin load',
 'A DNS server cluster','A cloud storage service',
 'b','CDNs (e.g. Cloudflare, Akamai) cache static content at edge nodes globally. Users are served from the nearest PoP, reducing latency from 200ms to 10ms.','medium',2,20),

('networking','Networking',4,
 'What is the difference between IPv4 and IPv6?',
 'IPv6 uses dotted decimal notation; IPv4 uses hex',
 'IPv4 is 32 bits (~4.3B addresses); IPv6 is 128 bits (340 undecillion addresses) with improved auto-configuration and no NAT needed',
 'IPv6 is slower than IPv4',
 'IPv4 supports multicast; IPv6 does not',
 'b','IPv4 address exhaustion drove IPv6 adoption. IPv6 uses 128-bit hex notation, includes SLAAC for auto-configuration, and has built-in IPSec support.','medium',2,20),

('networking','Networking',4,
 'What is DNS poisoning (cache poisoning)?',
 'Overloading a DNS server with requests',
 'Injecting malicious DNS records into a resolver cache so that domain names resolve to attacker-controlled IPs',
 'Brute-forcing DNS subdomain names',
 'Blocking all DNS traffic at the firewall',
 'b','DNS cache poisoning injects forged responses into resolvers. Clients then get the fake IP (e.g. for banking). Mitigations: DNSSEC, randomised source ports, 0x20 encoding.','medium',2,20),

('networking','Networking',4,
 'What port does SSH use by default?',
 '21','23','22','443',
 'c','SSH (Secure Shell) uses TCP port 22. Telnet (insecure) uses port 23. FTP uses 21.','medium',2,20),

('networking','Networking',4,
 'What is a firewall and what are its types?',
 'A device that assigns IP addresses',
 'A security system that filters network traffic; types include packet filter, stateful, proxy, and NGFW',
 'A load balancer for web traffic',
 'A DNS resolver with blocking',
 'b','Packet filter: rules based on IP/port. Stateful: tracks connection state. Proxy: deep inspection at application layer. NGFW: includes IDS/IPS, DPI, and application awareness.','medium',2,20),

-- Tier 3
('networking','Networking',4,
 'Explain how traceroute works at the IP level.',
 'It sends TCP SYN packets to each hop',
 'It sends packets with increasing TTL values; each router decrements TTL, and when it reaches 0, returns ICMP Time Exceeded, revealing the router IP',
 'It uses SNMP to query each router',
 'It sends UDP packets directly to the destination multiple times',
 'b','traceroute starts with TTL=1. First router decrements to 0 and returns ICMP TTL Exceeded, revealing its IP. TTL increments each round until destination replies with ICMP Port Unreachable.','hard',3,30),

('networking','Networking',4,
 'What is BGP hijacking and how does it affect routing?',
 'Blocking BGP updates with a firewall',
 'Announcing false route prefixes to attract traffic meant for other ASes, enabling interception or black-holing',
 'Encrypting BGP sessions with TLS',
 'A misconfigured OSPF metric',
 'b','BGP relies on trust — any AS can announce any prefix. Hijacking announces a more-specific route for victim IP space, diverting traffic. Example: 2010 China Telecom, 2018 Amazon Route 53.','hard',3,30),

('networking','Networking',4,
 'What is a TCP SYN flood and how do SYN cookies mitigate it?',
 'A SYN flood sends RST packets; SYN cookies block them',
 'A SYN flood exhausts connection state by sending SYNs without completing handshakes; SYN cookies encode state into the SYN-ACK sequence number, requiring no memory until ACK arrives',
 'SYN floods are only possible on UDP',
 'SYN cookies encrypt the SYN packet payload',
 'b','SYN flood: attacker sends many SYNs (often spoofed), server allocates state for each. SYN cookies: server encodes (src/dst IP, port, timestamp) as initial sequence number, allocates state only when valid ACK arrives.','hard',3,30),

('networking','Networking',4,
 'What is OSPF and how does it calculate the best path?',
 'A distance-vector protocol using hop count',
 'A link-state protocol where each router builds a full topology map using LSAs, then runs Dijkstra''s shortest path algorithm based on interface cost',
 'A path-vector protocol like BGP',
 'A proprietary Cisco routing protocol',
 'b','OSPF (Open Shortest Path First): routers flood Link State Advertisements to build an identical topology database, then each independently runs Dijkstra to find lowest-cost paths.','hard',3,30),

('networking','Networking',4,
 'What is the difference between symmetric and asymmetric NAT, and why does it matter for VoIP/WebRTC?',
 'There is no difference',
 'Symmetric NAT assigns a new external port for every unique destination; asymmetric (full-cone) reuses the same mapping. Symmetric NAT breaks peer-to-peer protocols that need stable external ports.',
 'Asymmetric NAT is more secure',
 'Symmetric NAT only works with IPv6',
 'b','Symmetric NAT breaks WebRTC/STUN because the external port changes per destination. ICE requires TURN relay servers to traverse symmetric NAT for direct media.','hard',3,30),

('networking','Networking',4,
 'What is VXLAN and why is it used in data centres?',
 'A VLAN type for wireless networks',
 'A tunnelling protocol that encapsulates Layer 2 frames inside UDP packets, extending virtual LANs across Layer 3 boundaries with up to 16 million VNIs',
 'A replacement for the OSI model',
 'A BGP extension for MPLS',
 'b','VXLAN (Virtual Extensible LAN) overcomes the 4094 VLAN limit with 24-bit VNI (16M segments). Used in SDN and cloud environments (VMware NSX, AWS VPC) to extend L2 across L3 infrastructure.','hard',3,30),

('networking','Networking',4,
 'How does HTTPS prevent man-in-the-middle attacks?',
 'By encrypting DNS queries','Through TLS certificate validation — the client verifies the server certificate is signed by a trusted CA and matches the domain, ensuring it is talking to the genuine server',
 'By using a VPN tunnel','By checking the MAC address of the server',
 'b','TLS: server presents certificate. Client checks: valid CA signature, not revoked (OCSP/CRL), domain matches. Certificate pinning adds extra assurance. Without this, an MitM can present a fake cert.','hard',3,30),

('networking','Networking',4,
 'What is anycast routing and where is it used?',
 'Broadcasting packets to all hosts on a subnet',
 'Assigning the same IP to multiple servers worldwide; routers forward packets to the topologically nearest instance',
 'A multicast protocol for video streaming',
 'A failover mechanism for DNS servers',
 'b','Anycast: same IP on multiple PoPs. BGP routes clients to the nearest one. Used by DNS root servers (all 13 root server IPs are anycast), Cloudflare, and CDNs for low-latency, DDoS resilience.','hard',3,30),

('networking','Networking',4,
 'What is QoS (Quality of Service) and how is DSCP used to implement it?',
 'A protocol for measuring network speed',
 'Mechanisms to prioritise traffic types; DSCP marks packets with a 6-bit value in the IP header so routers can queue and forward high-priority traffic (e.g. VoIP) ahead of bulk transfers',
 'A firewall rule type',
 'A load-balancing algorithm',
 'b','DSCP (Differentiated Services Code Point) in the IP TOS field marks packets with PHB (Per-Hop Behaviour). EF (Expedited Forwarding) for real-time; AF classes for assured data; BE (Best Effort) default.','hard',3,30),

('networking','Networking',4,
 'What is the spanning tree protocol (STP) and what problem does it solve?',
 'A routing protocol for layer 3 loops',
 'A layer 2 protocol that prevents switching loops by electing a root bridge and blocking redundant paths, activating them only on failure',
 'An encryption protocol for VLAN traffic',
 'A port security mechanism',
 'b','Without STP, redundant switch links cause broadcast storms and MAC table instability. STP (802.1D) elects root bridge, computes shortest paths, blocks redundant ports. RSTP (802.1w) converges faster.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 5. CYBER AWARENESS  (slug: cyber-awareness)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

('cyber-awareness','Cybersecurity Awareness',5,'What is phishing?','A network scanning technique','A fraudulent attempt to obtain sensitive info by disguising as a trustworthy entity via email or website','A type of DDoS attack','Port scanning with nmap','b','Phishing tricks users into revealing credentials or installing malware. Spear phishing targets specific individuals; whaling targets executives.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What does MFA stand for?','Multi-Function Authentication','Multi-Factor Authentication','Managed Firewall Access','Malware Filter Application','b','MFA requires two or more of: something you know (password), something you have (token), something you are (biometric). Significantly reduces account compromise risk.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What is a strong password characteristic?','Short and easy to remember','Contains only letters','At least 12 characters with mixed case, numbers, and symbols','Uses your name and birthdate','c','NIST recommends long passphrases. Avoid dictionary words, personal info, and reuse. Use a password manager to generate and store unique complex passwords.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What is ransomware?','Software that monitors network traffic','Malware that encrypts victim files and demands payment for the decryption key','A type of adware that shows pop-ups','A remote administration tool','b','Ransomware (e.g. WannaCry, LockBit) encrypts files and demands cryptocurrency. Prevention: offline backups, patching, email filtering, endpoint protection.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What should you do if you receive a suspicious email with a link?','Click the link to see if it is safe','Reply asking who sent it','Hover over the link to inspect the URL and report to IT without clicking','Forward it to your team','c','Always inspect URLs before clicking. Report phishing to IT/security teams. Most corporate email clients support phishing report buttons.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What is a VPN?','A virtual private network that encrypts traffic between your device and a remote server','A type of antivirus','A network monitoring tool','A firewall product','a','A VPN creates an encrypted tunnel. Useful on public Wi-Fi to prevent eavesdropping. Corporate VPNs route employee traffic through secure gateways.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What does software patching prevent?','Slower computers','Exploitation of known vulnerabilities that vendors have already fixed','New zero-day attacks','Data loss from hardware failure','b','Unpatched systems are primary targets. Most breaches exploit known CVEs with available patches. Enable automatic updates and establish a patch management cycle.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What is the principle of least privilege?','Give every user admin rights for efficiency','Grant users only the minimum access necessary to perform their job','Allow all network traffic by default','Share passwords across team members','b','Least privilege limits blast radius — a compromised account can only damage what it has access to. Applies to users, services, and applications.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What is social engineering in cybersecurity?','Hacking via social media APIs','Manipulating people into performing actions or divulging information through psychological tactics','Writing malware in Python','Network traffic analysis','b','Social engineering bypasses technical controls by targeting humans. Tactics: phishing, pretexting, baiting, tailgating, vishing. Training and verification processes are the primary defences.','easy',1,10),

('cyber-awareness','Cybersecurity Awareness',5,'What is the 3-2-1 backup rule?','3 passwords, 2 MFA methods, 1 VPN','3 copies of data, 2 different media types, 1 stored offsite','Back up 3 times per day to 2 servers','3 users, 2 backups, 1 test restore','b','3-2-1: keep 3 copies (original + 2 backups), on 2 different media types (e.g. disk + cloud), with 1 copy offsite. Protects against ransomware, hardware failure, and disaster.','easy',1,10),

-- Tier 2
('cyber-awareness','Cybersecurity Awareness',5,'What is the difference between a vulnerability, a threat, and a risk?','They are synonyms','Vulnerability: weakness. Threat: potential harm source. Risk: likelihood × impact of a threat exploiting a vulnerability.','Risk is a subset of vulnerability','Threat and risk are the same','b','Security risk management: identify vulnerabilities (flaws), threats (actors or events), and calculate risk = likelihood × impact. Controls reduce likelihood or impact.','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What is a zero-day vulnerability?','A vulnerability patched on the same day it was found','A vulnerability unknown to the vendor with no available patch, allowing immediate exploitation','A vulnerability in version 0.0 of software','A bug that only works on day 0 of deployment','b','Zero-days are highly valuable because defenders cannot patch what is unknown. Vendors have zero days to respond. Often sold in exploit markets or used by nation-state actors.','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What is GDPR and why does it matter for cybersecurity?','A US law for government data','EU regulation requiring organisations to protect personal data, report breaches within 72 hours, and face fines up to 4% of global revenue','An ISO security standard','A PCI compliance framework','b','GDPR (General Data Protection Regulation) mandates data protection by design, user consent, breach notification, and data minimisation. Non-compliance fines can be €20M or 4% of annual turnover.','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What is a SIEM system?','Secure Identity and Email Manager','Security Information and Event Management — a platform that aggregates and correlates logs from multiple sources to detect security incidents','A software inventory tool','A patch management system','b','SIEM (e.g. Splunk, IBM QRadar) ingests logs from firewalls, endpoints, and servers. Correlation rules detect patterns like multiple failed logins followed by success (brute force + compromise).','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What is defence in depth?','Using the strongest possible firewall','Layering multiple security controls so that if one fails, others continue to protect the asset','Only protecting the network perimeter','Encrypting all data at rest','b','Defence in depth applies controls at multiple layers: perimeter (firewall), network (IDS), endpoint (AV/EDR), application (WAF), data (encryption). Attackers must defeat every layer.','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What makes a phishing email hard to detect?','Poor grammar always gives it away','Attackers may use convincing branding, legitimate-looking domains (homograph attacks), and urgency tactics to bypass suspicion','Phishing emails always come from .ru domains','Phishing only targets non-technical users','b','Modern phishing: lookalike domains (paypa1.com), email spoofing (forged From headers), legitimate services (Google Forms), and contextual pretexting make detection difficult even for technical users.','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What is an incident response plan?','A disaster recovery plan for hardware failure','A documented process defining how an organisation detects, contains, eradicates, and recovers from security incidents','A software testing methodology','A compliance audit checklist','b','IR plan phases (NIST): Preparation, Detection/Analysis, Containment, Eradication, Recovery, Post-Incident. Having a plan before incidents occur dramatically reduces breach costs.','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What is data classification and why is it important?','Sorting files alphabetically','Categorising data by sensitivity (e.g. public, internal, confidential, restricted) to apply appropriate controls and handling procedures','Backing up data to multiple locations','Encrypting all company files','b','Classification enables proportional protection: public data needs no special handling; restricted (PII, trade secrets) needs encryption, access controls, and audit logging.','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What is a business email compromise (BEC) attack?','Hacking into email servers','A scam where attackers impersonate executives or vendors via email to trick employees into transferring funds or revealing sensitive data','A mass phishing campaign','Email malware delivery','b','BEC causes billions in losses annually. Attackers spoof or compromise real email accounts and request urgent wire transfers. Controls: out-of-band verification for financial requests, DMARC, email security gateways.','medium',2,20),

('cyber-awareness','Cybersecurity Awareness',5,'What is the cyber kill chain?','A type of ransomware attack','A 7-phase framework describing the stages of a cyber attack from reconnaissance to actions on objectives','A network monitoring methodology','A patch prioritisation framework','b','Lockheed Martin kill chain: Reconnaissance → Weaponisation → Delivery → Exploitation → Installation → C2 → Actions on Objectives. Defenders aim to break the chain at any stage.','medium',2,20),

-- Tier 3
('cyber-awareness','Cybersecurity Awareness',5,'What is the MITRE ATT&CK framework?','A vulnerability scoring system','A knowledge base of real-world adversary tactics, techniques, and procedures (TTPs) used by threat actors, organised by attack phase','An encryption standard','A network monitoring tool','b','ATT&CK maps attacker behaviour (not tools) to phases like Initial Access, Execution, Persistence. Blue teams use it to assess detection coverage; red teams to plan realistic simulations.','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What is the difference between a tabletop exercise and a penetration test?','They are the same','A tabletop is a discussion-based simulation where participants walk through a scenario verbally; a pen test involves actually attempting to exploit systems','Tabletop tests are automated; pen tests are manual','Pen tests are cheaper than tabletops','b','Tabletops test decision-making and IR plan gaps. Pen tests test technical controls. Both should occur regularly; tabletops are lower cost and can include executives and legal teams.','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What is threat modelling and how is STRIDE used?','A network scanning technique','A structured process to identify threats; STRIDE categorises: Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege','A patch management methodology','A compliance framework','b','Threat modelling (done during design): STRIDE maps attacker goals to system components. Each category suggests mitigations: authentication (spoofing), integrity checks (tampering), audit logs (repudiation).','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What is supply chain security and why is it a growing concern?','Securing physical goods in transit','Ensuring third-party software, hardware, and services used in your environment are not compromised — as attackers increasingly target trusted vendors to reach their actual targets','Only relevant to manufacturing companies','A compliance requirement for retailers','b','SolarWinds (2020): attackers compromised the build pipeline, signing malicious updates that went to 18,000+ organisations including US government agencies. Mitigations: SBOM, code signing, vendor risk assessments.','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What is the difference between vulnerability management and patch management?','They are identical','Vulnerability management continuously identifies, prioritises, and tracks all vulnerabilities; patch management is the specific process of applying vendor patches (a subset of VM)','Patch management is more comprehensive','Vulnerability management only applies to web apps','b','VM uses scanners (Nessus, Qualys) to find and CVSS-score all vulnerabilities, including configuration issues and unpatched CVEs. PM specifically tracks and deploys OS/app patches on a schedule.','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What does CVSS score measure and what does a score of 9.8 indicate?','Network speed; 9.8 = extremely fast','Common Vulnerability Scoring System — measures vulnerability severity on 0–10 scale; 9.8 is Critical, indicating high exploitability and impact, typically requiring immediate patching','Compliance level; 9.8 = nearly compliant','Encryption strength; 9.8 = strong','b','CVSS v3 factors: attack vector, complexity, privileges required, user interaction, scope, confidentiality/integrity/availability impact. 9.0–10.0 = Critical. Log4Shell was CVSS 10.0.','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What is a honeypot and how is it used defensively?','A type of IDS signature','A decoy system designed to attract attackers, detect intrusion attempts, and gather threat intelligence without exposing real assets','A patch management system','A two-factor authentication method','b','Honeypots waste attacker time, reveal TTPs, and alert on intrusion. High-interaction honeypots (full OS) provide rich intelligence; low-interaction simulate services. Honeynet = network of honeypots.','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What is data exfiltration and what are common techniques attackers use?','Deleting data from servers','Unauthorised transfer of data from a target; techniques include DNS tunnelling, steganography, HTTPS to attacker-controlled servers, and encrypted C2 channels','Encrypting data in place','Moving data between internal servers','b','Exfil often occurs after dwell (average 200+ days). Attackers stage data, then exfiltrate slowly to avoid detection. DLP (Data Loss Prevention) tools, egress filtering, and anomaly detection help detect it.','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What is the difference between a red team, blue team, and purple team?','Different network zones','Red team = offensive (attacks systems). Blue team = defensive (monitors, detects, responds). Purple team = collaborative red+blue improving both detection and offensive capability','Different compliance levels','Different patch management teams','b','Red teams simulate real adversaries to test detection and response. Blue teams defend and operate security tools. Purple teams facilitate knowledge sharing — red shows techniques while blue improves detections in real time.','hard',3,30),

('cyber-awareness','Cybersecurity Awareness',5,'What is security awareness training and why is human error still the #1 cause of breaches?','Optional training for IT staff only','Ongoing education for all staff on recognising and responding to threats; humans remain the weakest link because attackers find it easier to manipulate people than exploit technical controls','Annual compliance checkbox','Only relevant for customer-facing staff','b','Verizon DBIR consistently shows 82%+ of breaches involve human element. Simulated phishing campaigns + training reduce click rates from ~30% to <5%. Culture > one-time training.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 6. WEB SECURITY  (slug: web-security)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

('web-security','Web Security',6,'What is SQL injection?','Inserting JavaScript into a web page','Injecting malicious SQL statements into input fields to manipulate a database query','A type of brute-force attack','Encrypting SQL traffic','b','SQLi exploits unsanitised input. Classic: `'' OR ''1''=''1` bypasses login. Mitigations: parameterised queries (prepared statements), ORMs, WAFs, least-privilege DB accounts.','easy',1,10),

('web-security','Web Security',6,'What is XSS (Cross-Site Scripting)?','SQL injection via XML','Injecting malicious scripts into web pages that execute in other users'' browsers','A network scanning technique','An email phishing attack','b','Reflected XSS: injected via URL. Stored XSS: saved in DB. DOM-based XSS: manipulates DOM. Impact: cookie theft, keylogging, defacement. Mitigation: output encoding, CSP.','easy',1,10),

('web-security','Web Security',6,'What does HTTPS protect against?','Malware on endpoints','Eavesdropping and tampering of data in transit via TLS encryption','DDoS attacks','Server-side vulnerabilities','b','HTTPS (TLS) encrypts traffic between browser and server. Protects against passive sniffing and active MitM. Does not protect against server-side vulnerabilities like SQLi.','easy',1,10),

('web-security','Web Security',6,'What is CSRF?','Cross-Site Resource Forgery — stealing files from servers','Cross-Site Request Forgery — tricking an authenticated user into making unintended requests to a site where they are logged in','A type of DDoS attack','SQL injection variant','b','CSRF exploits the browser''s automatic cookie attachment. Attacker crafts a malicious form that submits to victim.com. User''s cookies go along. Mitigation: CSRF tokens, SameSite cookies.','easy',1,10),

('web-security','Web Security',6,'What is the OWASP Top 10?','Top 10 hacking tools','A list of the 10 most critical web application security risks, updated periodically','Top 10 programming languages','Top 10 secure coding practices','b','OWASP Top 10 (2021): Broken Access Control, Cryptographic Failures, Injection, Insecure Design, Security Misconfiguration, Vulnerable Components, Auth Failures, Software Integrity, Logging Failures, SSRF.','easy',1,10),

('web-security','Web Security',6,'What is a WAF?','Web Application Framework','Web Application Firewall — a security layer that filters HTTP traffic and blocks common web attacks','Windows Authentication Framework','Wireless Access Facility','b','A WAF (e.g. ModSecurity, Cloudflare WAF) inspects HTTP requests and blocks those matching attack patterns (SQLi, XSS, path traversal). Complements but does not replace secure coding.','easy',1,10),

('web-security','Web Security',6,'What is broken access control?','Failing to use HTTPS','When users can access resources or perform actions beyond their authorised permissions (e.g. accessing another user''s data by changing an ID in the URL)','A weak encryption algorithm','An unpatched server','b','Broken access control (#1 OWASP 2021): IDOR, privilege escalation, missing function-level access control. Fix: server-side authorisation checks on every request.','easy',1,10),

('web-security','Web Security',6,'What is a cookie and what attributes secure it?','A type of session file stored on the server','A small piece of data stored in the browser; secured with Secure (HTTPS only), HttpOnly (no JS access), and SameSite (CSRF protection) flags','An HTTP header','A type of SQL query','b','Secure: only sent over HTTPS. HttpOnly: JavaScript cannot read it (prevents XSS cookie theft). SameSite=Strict/Lax: prevents CSRF by restricting cross-site submission.','easy',1,10),

('web-security','Web Security',6,'What is directory traversal?','Moving files between web directories','An attack that accesses files outside the web root by using `../` sequences in URLs (e.g. `../../etc/passwd`)','A type of XSS','A broken authentication issue','b','Path traversal: `https://site.com/file?name=../../etc/passwd`. Mitigation: validate and sanitise file path inputs, use an allow-list, run the web server with minimal filesystem permissions.','easy',1,10),

('web-security','Web Security',6,'What is an insecure direct object reference (IDOR)?','A broken link in a web page','When an application exposes internal object references (e.g. user IDs in URLs) without authorisation checks, allowing access to other users'' data','A missing HTTPS redirect','A JavaScript injection','b','IDOR example: `GET /api/orders?id=1001` — change to 1002 to see another user''s order. Fix: authorisation check server-side verifying the requester owns the resource.','easy',1,10),

-- Tier 2
('web-security','Web Security',6,'What is the difference between stored and reflected XSS?','They are identical','Reflected XSS: payload in URL, executed immediately in victim''s browser when clicking a malicious link; Stored XSS: payload saved in database and executed for every visitor','Stored XSS is less dangerous','Reflected XSS requires server-side storage','b','Stored XSS (e.g. malicious script in a comment) is more dangerous because it executes for all users without requiring them to click a link. Both are mitigated by output encoding and CSP.','medium',2,20),

('web-security','Web Security',6,'How does a Content Security Policy (CSP) mitigate XSS?','By encrypting all JavaScript','By declaring which sources are allowed to load scripts, blocking inline scripts and untrusted origins — so even injected scripts will not execute','By blocking all form submissions','By enforcing HTTPS','b','CSP header (e.g. `Content-Security-Policy: script-src ''self''`) blocks inline JS and restricts script sources. A stolen script injection cannot execute if it violates the policy. Nonces/hashes allow specific inline scripts.','medium',2,20),

('web-security','Web Security',6,'What is SSRF (Server-Side Request Forgery)?','The server forging client requests','An attack that makes the server perform HTTP requests to internal resources on behalf of the attacker, bypassing firewall rules','A session fixation attack','A form of CSRF targeting servers','b','SSRF: attacker controls a URL the server fetches. Can reach internal metadata APIs (AWS 169.254.169.254), internal services, and scan internal networks. Capital One breach involved SSRF to EC2 metadata.','medium',2,20),

('web-security','Web Security',6,'What is JWT and what are common vulnerabilities?','JavaScript Utility Token — for bundling JS files','JSON Web Token — a signed token for auth; vulnerabilities include algorithm confusion (alg:none), weak secret, no expiry, and unverified signature','A PHP session mechanism','An HTTP cookie format','b','JWT: header.payload.signature. Attacks: accepting `alg:none`, using weak HS256 secrets (brute-forceable), RS256→HS256 confusion (server verifies with public key as HMAC secret). Always validate: algorithm, signature, expiry, audience.','medium',2,20),

('web-security','Web Security',6,'What is HTTP request smuggling?','Sending HTTP requests through a proxy','Exploiting discrepancies in how front-end and back-end servers parse HTTP request boundaries, allowing injection of requests from one user session into another','A type of MitM attack','A redirect vulnerability','b','Smuggling exploits disagreements on Content-Length vs Transfer-Encoding parsing. Affects reverse proxy + origin combos (HAProxy + Node.js, Nginx + Apache). Enables cache poisoning, bypassing security controls, session hijacking.','medium',2,20),

('web-security','Web Security',6,'What is mass assignment vulnerability?','Assigning too many variables','When an app automatically binds HTTP parameters to model attributes without filtering, allowing attackers to set privileged fields like isAdmin=true','A type of SQL injection','Insufficient input validation on forms','b','Mass assignment (Rails, Spring, Node): `User.create(params[:user])` with `params={name:"x",admin:true}`. Attacker sends extra params to elevate privileges. Fix: whitelist permitted attributes explicitly.','medium',2,20),

('web-security','Web Security',6,'What is the difference between authentication and authorisation?','They are identical','Authentication: verifying who you are. Authorisation: verifying what you are allowed to do.','Authorisation happens before authentication','Authentication only applies to APIs','b','AuthN: prove identity (password, MFA). AuthZ: check permissions (RBAC, ABAC). A system can authenticate correctly but have broken authorisation (IDOR, privilege escalation).','medium',2,20),

('web-security','Web Security',6,'What is HSTS and why is it important?','HTTP State Transfer Standard','HTTP Strict Transport Security — a header telling browsers to only use HTTPS for a domain for a set period, preventing SSL stripping attacks','A session security header','A cookie flag','b','HSTS (Strict-Transport-Security: max-age=31536000) means browsers refuse to downgrade to HTTP. Without it, an MitM can strip TLS on the first request. HSTS preloading adds the domain to browser lists.','medium',2,20),

('web-security','Web Security',6,'What is XML External Entity (XXE) injection?','SQL injection via XML fields','An attack on XML parsers that tricks them into processing external entity references to read files, perform SSRF, or cause DoS','XSS via XML content','A CSRF attack via XML forms','b','XXE: `<!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]>`. The parser fetches and returns the file contents. Mitigation: disable external entity processing in XML parsers (DTD processing).','medium',2,20),

('web-security','Web Security',6,'What is security misconfiguration and give two common examples?','Not using a WAF','Improperly configured systems exposing vulnerabilities; examples: debug mode enabled in production, default credentials, verbose error messages revealing stack traces, unnecessary services running','Only affects databases','Only a cloud security issue','b','Security misconfiguration is #5 OWASP. Common: PHP `display_errors=On` in production, default admin/admin credentials, S3 buckets with public read, unnecessary HTTP methods (TRACE, DELETE) enabled.','medium',2,20),

-- Tier 3
('web-security','Web Security',6,'Explain the mechanics of a blind SQL injection attack and how to detect it.',
 'SQLi that only works on databases without a GUI',
 'SQLi where no data is returned directly; attackers infer data from boolean (true/false page differences) or time-based (sleep() delays) responses',
 'SQLi exploiting stored procedures',
 'SQLi that bypasses WAF rules',
 'b','Boolean blind: `'' AND 1=1 --` (normal page) vs `'' AND 1=2 --` (altered page). Time-based: `'' AND SLEEP(5) --` delays response. Automate with sqlmap. Exploit is slow but effective on any SQLi.','hard',3,30),

('web-security','Web Security',6,'What is prototype pollution and what is its impact in JavaScript?',
 'Corrupting class prototypes in Java',
 'Injecting properties into Object.prototype so that all objects in the application inherit the malicious property, enabling XSS, privilege escalation, or RCE in Node.js',
 'A type of memory corruption in C++',
 'An attack on Python class inheritance',
 'b','JS prototype pollution: `obj.__proto__.isAdmin = true` affects every object. In Express.js + template engines, can lead to XSS or RCE via `req.query.__proto__.toString`. Found in lodash merge, jQuery extend, etc.','hard',3,30),

('web-security','Web Security',6,'What is OAuth 2.0 and what are common implementation vulnerabilities?',
 'A password hashing standard',
 'An authorisation framework allowing third-party apps limited access to user accounts; vulnerabilities include open redirect in redirect_uri, CSRF on the state parameter, and token leakage via Referer header',
 'A session management protocol',
 'A two-factor authentication standard',
 'b','OAuth 2.0: client requests auth code at /authorize, exchanges for access token at /token. Attacks: missing state CSRF → account takeover, open redirect_uri → code theft, implicit flow token in URL leaked via Referer.','hard',3,30),

('web-security','Web Security',6,'What is cache poisoning and how does it differ from cache deception?',
 'They are identical attacks',
 'Poisoning: attacker stores malicious content in a cache to serve to other users. Deception: attacker tricks cache into storing private user data that the attacker then retrieves.',
 'Both require SQLi',
 'Cache deception poisons the origin; cache poisoning deceives the CDN',
 'b','Poisoning exploits unkeyed inputs (X-Forwarded-Host) to inject malicious response into shared cache → affects all users. Deception: `GET /account/settings.css` tricks cache to store private API response, then attacker fetches it.','hard',3,30),

('web-security','Web Security',6,'What is a race condition vulnerability in web apps?','A load balancing issue','When time-of-check to time-of-use (TOCTOU) gaps allow concurrent requests to bypass single-use controls (e.g. redeeming a coupon multiple times simultaneously)','A JavaScript threading bug','A database indexing problem','b','Race conditions: send 50 simultaneous requests to redeem a $100 gift card → each thread checks balance before deducting → all 50 succeed. Fix: atomic database operations, optimistic locking, idempotency keys.','hard',3,30),

('web-security','Web Security',6,'What is subdomain takeover and how does it occur?','Registering someone else''s domain name','When a subdomain''s DNS CNAME points to an external service (e.g. GitHub Pages, S3) that has been deprovisioned, allowing an attacker to claim that service and serve content under the original subdomain','A type of DNS poisoning','A clickjacking attack variant','b','If `blog.company.com` CNAMEs to `company.github.io` but the GitHub Pages repo is deleted, an attacker creates `company.github.io` repo and serves phishing content under `blog.company.com`.','hard',3,30),

('web-security','Web Security',6,'How does a deserialization attack work and what makes it dangerous?','Decrypting serialised objects','When an application deserialises untrusted data, allowing attackers to supply malicious serialised objects that trigger code execution via gadget chains in the application''s dependencies','A type of XML injection','A binary format SQL injection','b','Insecure deserialisation (OWASP A08): Java deserialization gadget chains (Apache Commons Collections), Python pickle, PHP unserialize. Attacker crafts serialised object invoking system() during deserialisation → RCE.','hard',3,30),

('web-security','Web Security',6,'What is the same-origin policy (SOP) and when does CORS relax it?','A policy enforcing HTTPS on same-domain resources','A browser security mechanism preventing scripts on one origin from reading responses from a different origin; CORS headers (Access-Control-Allow-Origin) explicitly permit cross-origin reads for approved domains','A server-side authentication policy','A cookie partitioning mechanism','b','SOP: `origin = scheme + host + port`. `evil.com` JS cannot read `bank.com` responses. CORS relaxes this with server-sent headers. Misconfigured `Access-Control-Allow-Origin: *` with credentials enabled = data theft.','hard',3,30),

('web-security','Web Security',6,'What is a second-order SQL injection?','SQL injection via a secondary form field','SQLi where malicious data is stored safely but injected unsafely when later retrieved and used in another SQL query without sanitisation','A time-based blind SQLi variant','SQL injection through stored procedures only','b','Second-order: attacker registers username `admin''--`. App stores it safely. Later, a password change query does `WHERE user=''$stored_username''` without parameterisation → injection fires when the stored value is read.','hard',3,30),

('web-security','Web Security',6,'What is server-side template injection (SSTI) and how does it lead to RCE?','Injecting HTML templates into emails','When user input is embedded in a server-side template without sanitisation, allowing execution of template expressions that can call OS commands','A type of XSS in template engines','Client-side template injection in Angular','b','SSTI: Jinja2 `{{7*7}}` → 49 in output confirms injection. `{{self._TemplateReference__context.cycler.__init__.__globals__.os.popen(''id'').read()}}` achieves RCE. Affects Flask/Jinja2, Twig, Freemarker.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 7. CRYPTOGRAPHY  (slug: cryptography)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

('cryptography','Cryptography',7,'What is the difference between symmetric and asymmetric encryption?','Symmetric uses two keys; asymmetric uses one','Symmetric uses one shared key for both encryption and decryption; asymmetric uses a public/private key pair','Symmetric is slower','Asymmetric is only for hashing','b','Symmetric (AES): fast, but key distribution is a problem. Asymmetric (RSA, ECC): public key encrypts, private key decrypts. In practice TLS uses asymmetric for key exchange, symmetric for bulk data.','easy',1,10),

('cryptography','Cryptography',7,'What is a hash function?','A function that encrypts data with a key','A one-way function that maps input to a fixed-size digest; same input always produces same output; infeasible to reverse','A type of symmetric cipher','A key exchange protocol','b','Hash functions (SHA-256, SHA-3): one-way, deterministic, collision-resistant. Used for password storage (with salt), data integrity checks, digital signatures, and Merkle trees.','easy',1,10),

('cryptography','Cryptography',7,'What is AES?','Asymmetric Encryption Standard','Advanced Encryption Standard — a symmetric block cipher operating on 128-bit blocks with 128/192/256-bit keys','A hash function','A key exchange algorithm','b','AES replaced DES in 2001 (NIST). Block size = 128 bits. Key sizes: 128, 192, 256. Rounds: 10/12/14. Modes: CBC, GCM, CTR. Currently no practical breaks — the gold standard symmetric cipher.','easy',1,10),

('cryptography','Cryptography',7,'What is RSA?','A symmetric cipher','An asymmetric algorithm based on the difficulty of factoring large integers, used for key exchange and digital signatures','A hash function','A stream cipher','b','RSA: public key = (e, n), private key = (d, n), where n = p×q (two large primes). Security relies on factoring n. RSA-2048 is current standard. Vulnerable to quantum computers (Shor''s algorithm).','easy',1,10),

('cryptography','Cryptography',7,'What is a digital signature?','An electronic version of a handwritten signature image','A cryptographic mechanism where the sender signs data with their private key; anyone with the public key can verify authenticity and integrity','A type of symmetric encryption','An email encryption standard','b','Digital signatures (RSA, ECDSA): sign = hash(data) encrypted with private key. Verify = decrypt with public key, compare to hash. Provides: authentication (non-repudiation) and integrity.','easy',1,10),

('cryptography','Cryptography',7,'What is a certificate authority (CA)?','An encryption algorithm','A trusted organisation that issues digital certificates binding a public key to an entity identity','A type of firewall','A password manager','b','CAs (e.g. DigiCert, Let''s Encrypt) verify domain/identity ownership and issue X.509 certificates. Browsers ship with a list of trusted root CAs. The certificate chain links end-entity cert → intermediate → root.','easy',1,10),

('cryptography','Cryptography',7,'What is salting in password storage?','Adding flavour to hash outputs','Adding a random unique value to each password before hashing to prevent rainbow table attacks and ensure identical passwords produce different hashes','Encrypting passwords with a symmetric key','A brute-force protection mechanism','b','Without salt: same password = same hash → pre-computed rainbow tables crack millions at once. With salt: `hash(password + random_salt)` — each hash is unique. Salt is stored alongside the hash (not secret).','easy',1,10),

('cryptography','Cryptography',7,'What is the purpose of TLS?','Transfer Large Streams protocol for video','Transport Layer Security — encrypts communication between client and server, providing confidentiality, integrity, and authentication','A hash function standard','An asymmetric key storage format','b','TLS (successor to SSL) uses asymmetric cryptography for handshake/key exchange, symmetric (AES-GCM) for bulk data, and HMAC for integrity. Current: TLS 1.3. Deprecated: SSL, TLS 1.0, TLS 1.1.','easy',1,10),

('cryptography','Cryptography',7,'What is the difference between encoding, encryption, and hashing?','They all hide data in the same way','Encoding: transforms data for interoperability (no secret, reversible). Encryption: protects data with a key (reversible with key). Hashing: one-way digest (irreversible).','Encoding is most secure','Hashing is the same as encryption','b','Base64 is encoding — anyone can decode it. AES is encryption — need key. SHA-256 is hashing — cannot reverse. Critical to understand these are not interchangeable for security.','easy',1,10),

('cryptography','Cryptography',7,'What is a man-in-the-middle (MitM) attack on encrypted traffic?','Physical interception of cables','An attacker positions between client and server, impersonating both sides to intercept and potentially modify encrypted communication — defeated by proper certificate validation','Decrypting all HTTPS traffic','A brute-force attack on TLS','b','MitM: client → attacker (forged cert) ← → server. If client skips cert validation (or trusts attacker''s CA), encryption exists but the attacker reads all traffic. Certificate pinning adds protection.','easy',1,10),

-- Tier 2
('cryptography','Cryptography',7,'What is the difference between CBC and GCM modes of AES?','GCM is asymmetric; CBC is symmetric','CBC (Cipher Block Chaining): encrypts but provides no authentication, vulnerable to padding oracle attacks. GCM (Galois/Counter Mode): authenticated encryption — provides both confidentiality and integrity in one pass.','CBC is faster','GCM does not use AES','b','AES-CBC + HMAC was standard. AES-GCM is AEAD (Authenticated Encryption with Associated Data) — one algorithm provides encryption and authentication, used in TLS 1.3. Padding oracle attacks break CBC (POODLE).','medium',2,20),

('cryptography','Cryptography',7,'What is Diffie-Hellman key exchange and why is it important?','An asymmetric encryption algorithm','A protocol allowing two parties to establish a shared secret over an insecure channel without prior shared secret — the foundation of forward secrecy in TLS','A digital signature scheme','A hash function for key derivation','b','DH: both parties agree on public parameters (g, p), exchange public values, compute the same shared secret. An eavesdropper cannot derive the secret. ECDH uses elliptic curves for smaller keys.','medium',2,20),

('cryptography','Cryptography',7,'What is perfect forward secrecy (PFS)?','Encrypting data twice','Using ephemeral key exchange (DHE/ECDHE) so that each session has a unique key — compromise of the server''s private key does not expose past sessions','A certificate renewal mechanism','Storing encryption keys in hardware','b','Without PFS: record all TLS traffic, later obtain server private key, decrypt everything. With PFS (ephemeral DH keys): each session''s symmetric key is never stored; past sessions remain encrypted even if private key is compromised.','medium',2,20),

('cryptography','Cryptography',7,'What is a birthday attack in cryptography?','An attack on password hashes using birthdays','Exploiting the birthday paradox to find two inputs with the same hash output (collision); relevant to hash function security — SHA-1 was broken this way','A timing attack on RSA','A brute-force attack on AES','b','Birthday paradox: in a group of 23 people, 50% chance two share a birthday. Collision probability approaches 50% after ~√(2^n) tries for an n-bit hash. SHA-1 (160-bit) effective collision = 2^80 → Google SHA-1 collision (2017).','medium',2,20),

('cryptography','Cryptography',7,'What is HMAC and how does it differ from a plain hash?','HMAC is a hash of the hash','A Hash-based Message Authentication Code that uses a secret key with the hash function — provides both integrity and authentication that a plain hash (without key) cannot provide','They are identical','HMAC is an asymmetric signature','b','Plain hash: anyone can compute it → no authentication. HMAC = hash(key XOR opad || hash(key XOR ipad || message)). Only parties with the key can verify. Used in JWT signatures, API request signing.','medium',2,20),

('cryptography','Cryptography',7,'What is key stretching and why is it used for passwords?','Stretching RSA key size','Deliberately making a hash function slow (PBKDF2, bcrypt, Argon2) to resist brute-force and GPU attacks on stolen password hashes','Extending TLS session duration','A method to reduce key storage size','b','GPU can compute billions of SHA-256 hashes/sec. bcrypt/Argon2 are intentionally slow (configurable work factor). 10ms per hash = 100/sec max brute force vs billions/sec for plain SHA-256.','medium',2,20),

('cryptography','Cryptography',7,'What is an IV (Initialisation Vector) and why must it be random?','A key rotation mechanism','A random value used with a cipher key to ensure identical plaintexts produce different ciphertexts — must never be reused with the same key','The initial encryption key','A certificate revocation mechanism','b','IV reuse (especially with CTR/GCM mode) is catastrophic: two ciphertexts with same IV/key can be XOR''d to eliminate the keystream, revealing both plaintexts. TLS generates a fresh random IV per record.','medium',2,20),

('cryptography','Cryptography',7,'What is X.509 and what fields does a certificate contain?','An encryption algorithm','A standard format for public key certificates; key fields: Subject, Issuer, Valid From/To, Public Key, Serial Number, Extensions (SANs), Signature','A key exchange protocol','A hash function standard','b','X.509 v3 certificates: DER/PEM encoded. SANs (Subject Alternative Names) list covered domains. Extensions: Key Usage (Digital Signature, Key Encipherment), Extended Key Usage (TLS Web Server Auth), OCSP URL.','medium',2,20),

('cryptography','Cryptography',7,'What is certificate pinning and what are its risks?','Requiring SHA-256 certificates only','Hard-coding the expected certificate or public key hash in an application so it only trusts that specific cert — prevents MitM even with rogue CAs; risk: pinned cert expiry breaks the app','Only using EV certificates','Using the same certificate across all domains','b','Pinning (HPKP header or app-level) prevents rogue CA attacks. Risk: if pinned cert expires or is rotated without updating the pin, users lose access. Apps should pin the CA intermediate, not the leaf cert.','medium',2,20),

('cryptography','Cryptography',7,'What is the difference between stream ciphers and block ciphers?','Stream ciphers are more secure','Stream ciphers encrypt one bit/byte at a time (XOR with keystream); block ciphers encrypt fixed-size blocks. Stream: fast, suited for real-time. Block (with modes): general purpose.','Block ciphers use less memory','Stream ciphers require larger keys','b','RC4 (now broken) and ChaCha20 are stream ciphers. AES is a block cipher. ChaCha20-Poly1305 is used in TLS 1.3 for mobile/IoT (faster than AES on devices without hardware acceleration).','medium',2,20),

-- Tier 3
('cryptography','Cryptography',7,'Explain how elliptic curve cryptography (ECC) achieves smaller key sizes than RSA.',
 'ECC uses smaller prime numbers','ECC bases security on the elliptic curve discrete logarithm problem (ECDLP), which is harder to solve than integer factorisation, giving equivalent security with much smaller keys (256-bit ECC ≈ 3072-bit RSA)','ECC uses shorter hash functions','ECC is faster because it skips key validation','b','ECDLP: given P and Q=kP on a curve, find k. No sub-exponential algorithm exists (unlike factoring). 256-bit ECC provides ~128-bit security. Used in ECDH (key exchange), ECDSA (signatures), TLS 1.3.','hard',3,30),

('cryptography','Cryptography',7,'What is a padding oracle attack and what cipher mode does it affect?','An attack on RSA key padding','An attack on CBC mode where an oracle (error message, timing) reveals whether decrypted padding is valid, allowing decryption of ciphertext byte-by-byte without the key','An attack on AES-GCM','A side-channel on hash functions','b','Bleichenbacher (RSA PKCS#1 v1.5), POODLE (SSL 3.0 CBC), BEAST all exploit padding oracles. Tool: padbuster. Mitigation: AES-GCM (no padding), constant-time padding validation, TLS 1.3 which removed CBC.','hard',3,30),

('cryptography','Cryptography',7,'What is a length extension attack and which hash functions are vulnerable?','An attack extending hash key length','An attack where an attacker can compute hash(secret || message || extension) given hash(secret || message) and the message length, without knowing the secret — affects MD5, SHA-1, SHA-2 (Merkle-Damgård construction)','An attack on Merkle trees','Only affects HMAC','b','Merkle-Damgård: the internal state after hashing is the output. Attacker uses it as the starting state for further hashing. Fix: use HMAC (immune by construction) or SHA-3 (sponge construction). Used to forge API signatures.','hard',3,30),

('cryptography','Cryptography',7,'How does the TLS 1.3 handshake differ from TLS 1.2?','TLS 1.3 is slower','TLS 1.3: 1-RTT (vs 2-RTT), removed RSA key exchange and CBC cipher suites, mandatory PFS (ECDHE only), 0-RTT resumption, and the entire handshake is encrypted earlier','TLS 1.3 does not support certificates','TLS 1.3 uses symmetric keys throughout','b','TLS 1.3 removed: RSA key exchange (no PFS), SHA-1, RC4, DES, static DH, renegotiation. Added: 0-RTT session resumption (replay risk), encrypt-then-MAC replaced by AEAD-only, early application data.','hard',3,30),

('cryptography','Cryptography',7,'What is a chosen-plaintext attack (CPA) and what security level does it require?','Attacker chooses ciphertext to decrypt','Attacker can encrypt arbitrary plaintexts of their choice and observe ciphertexts; modern ciphers must be IND-CPA secure (indistinguishable ciphertexts even given chosen plaintext access)','An attack only on asymmetric ciphers','A brute-force attack on AES','b','IND-CPA security: given two plaintexts and a ciphertext, attacker cannot determine which was encrypted with better than 50% probability. AES-GCM achieves IND-CPA. ECB mode fails IND-CPA (identical blocks → identical ciphertexts).','hard',3,30),

('cryptography','Cryptography',7,'What is quantum computing''s threat to current cryptography and what is post-quantum cryptography?','Quantum computers break all encryption instantly','Shor''s algorithm breaks RSA/ECC in polynomial time. Grover''s algorithm halves symmetric key security. Post-quantum cryptography (NIST finalised 2024) includes lattice-based (CRYSTALS-Kyber, Dilithium) algorithms resistant to quantum attack.','Quantum computers only affect hashing','Only affects keys shorter than 2048 bits','b','Shor''s: factors RSA-2048 in hours on a large quantum computer. Grover''s: AES-128 security drops to 64-bit equivalent → use AES-256. NIST PQC: ML-KEM (Kyber) for key encapsulation, ML-DSA (Dilithium) for signatures.','hard',3,30),

('cryptography','Cryptography',7,'What is zero-knowledge proof and what is it used for?','A proof that reveals all data','A cryptographic protocol where one party proves knowledge of a secret to another without revealing the secret itself — used in anonymous credentials, blockchain privacy, and authentication','A password hashing technique','A digital signature scheme','b','ZKP example: proving you know a password without sending it. zk-SNARKs power Zcash privacy. Used in: blockchain anonymous transactions, verifiable computation, passwordless authentication (FIDO2 uses ZKP concepts).','hard',3,30),

('cryptography','Cryptography',7,'What is the difference between a KDF (Key Derivation Function) and a password hash function?','They are identical','KDFs (HKDF, PBKDF2) derive cryptographic keys from key material or passwords with defined output length for specific purposes; password hash functions (bcrypt, Argon2) are specifically tuned to be slow and memory-hard for storing passwords','KDFs are faster','Argon2 is a KDF, not a password hash','b','HKDF: derive AES key from DH shared secret. PBKDF2: derive key from password (but not memory-hard). Argon2id: memory-hard password hash (wins PHC). Use the right tool: Argon2 for passwords, HKDF for key material.','hard',3,30),

('cryptography','Cryptography',7,'What is the random oracle model and why do cryptographers use it?','A true random number generator','A theoretical construct treating a hash function as a perfectly random function; used in security proofs to reason about schemes like RSA-OAEP; real hash functions are not random oracles but are practical approximations','A hardware RNG specification','A key generation model','b','In the ROM, hash outputs are uniformly random and independent. Security proofs in the ROM show: if you can break the scheme, you can distinguish the hash from random (computationally infeasible). RSA-OAEP is proven secure in ROM; plain RSA-PKCS1 is not.','hard',3,30),

('cryptography','Cryptography',7,'What is deniable encryption?','Encryption that can be decrypted by anyone','Encryption designed so that multiple valid plaintexts can be produced from the same ciphertext with different keys, making it impossible to prove which was the intended message — used to resist compelled decryption','Encryption with no key','A type of symmetric cipher','b','Deniable (plausibly deniable) encryption: VeraCrypt hidden volumes. Two correct passphrases decrypt different content. If compelled to reveal a passphrase, reveal the "decoy" one. Used by activists and journalists in hostile environments.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 8. MALWARE & THREATS  (slug: malware)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

('malware','Malware & Threats',8,'What is the difference between a virus and a worm?','A virus spreads via networks; a worm needs a host file','A virus attaches to a host file and spreads when executed; a worm is self-replicating and spreads automatically across networks without human interaction','They are identical','Worms encrypt files; viruses delete them','b','Virus: requires host file and user execution. Worm: self-propagates via network vulnerabilities (e.g. WannaCry via SMB EternalBlue). Worms can spread in minutes globally; viruses spread more slowly.','easy',1,10),

('malware','Malware & Threats',8,'What is a Trojan horse?','Malware that replicates itself','Malicious software disguised as legitimate software that performs hidden harmful actions when run','A network worm','Ransomware that demands cryptocurrency','b','Trojans rely on social engineering. Examples: fake antivirus, cracked software, malicious email attachments. Once installed, they may install backdoors, steal credentials, or join a botnet.','easy',1,10),

('malware','Malware & Threats',8,'What is ransomware?','Software that shows unwanted ads','Malware that encrypts victim files and demands payment (usually cryptocurrency) for the decryption key','A type of spyware','A network scanner','b','Ransomware (CryptoLocker, WannaCry, REvil): encrypts documents, demands ransom. Prevention: offline backups, email filtering, patch management, endpoint protection with behavioural detection.','easy',1,10),

('malware','Malware & Threats',8,'What is a botnet?','A single infected machine','A network of malware-infected machines (bots) controlled by a threat actor for DDoS, spam, credential stuffing, or crypto mining','A type of firewall','A secure remote access tool','b','Botnets: Mirai (IoT devices → DDoS), Zeus (credential theft), Emotet (banking → loader). Controlled via C2 (Command and Control) servers. Takedowns require coordinated global law enforcement.','easy',1,10),

('malware','Malware & Threats',8,'What is a rootkit?','A kernel update tool','Malware designed to hide its presence and other malware from the OS and security tools, often by operating at kernel or hypervisor level','A type of adware','A remote backup tool','b','Rootkits modify the OS kernel, bootloader (bootkit), or hypervisor to hide processes and files. Detected via integrity checking (AIDE), boot-time scanning, or hardware-based attestation (TPM).','easy',1,10),

('malware','Malware & Threats',8,'What is spyware?','A network monitoring tool for admins','Software that secretly collects user information (keystrokes, browsing, credentials) and sends it to the attacker','A type of ransomware','A backup software','b','Spyware includes keyloggers, screen recorders, and credential stealers. Examples: Pegasus (nation-state mobile spyware), Agent Tesla (commodity keylogger), FIN7 banking malware.','easy',1,10),

('malware','Malware & Threats',8,'What are indicators of compromise (IOCs)?','Security policies','Forensic artefacts (IP addresses, file hashes, domain names, registry keys) indicating a system has likely been compromised','Firewall log entries','Software licence violations','b','IOCs shared via STIX/TAXII formats. Examples: malware hash (MD5/SHA256), C2 IP, mutex name, registry persistence key. Security tools ingest IOCs to detect and block known threats.','easy',1,10),

('malware','Malware & Threats',8,'What is the Cyber Kill Chain?','A malware family','A 7-stage model of a cyber attack: Reconnaissance, Weaponisation, Delivery, Exploitation, Installation, Command & Control, Actions on Objectives','A forensic investigation process','A network defence framework','b','Lockheed Martin kill chain helps defenders identify which stage an attacker is in and apply controls. Breaking the chain at any stage prevents the attacker achieving their objective.','easy',1,10),

('malware','Malware & Threats',8,'What is a zero-day exploit?','A vulnerability discovered on day 0 of software release','A working exploit for a vulnerability that the software vendor is unaware of and has not patched, giving defenders zero days to respond','An exploit that only works once','A brute-force attack','b','Zero-days are highly valuable (sold for millions). Used by APTs and nation-states. Mitigations: defence in depth, exploit mitigations (ASLR, DEP), sandboxing, network segmentation — since patching is impossible.','easy',1,10),

('malware','Malware & Threats',8,'What is adware?','A type of ransomware','Software that automatically displays or downloads advertising material, often bundled with legitimate free software, and may track browsing behaviour','Malware that deletes files','A keylogger','b','Adware monetises through ad impressions. Most is annoying not destructive, but some variants are surveillance tools. Detected and removed by most modern AV/anti-malware tools.','easy',1,10),

-- Tier 2
('malware','Malware & Threats',8,'What is the difference between static and dynamic malware analysis?','They produce identical results','Static: examining malware code/structure without running it (disassembly, strings, hashes). Dynamic: running malware in a sandbox to observe behaviour (network calls, file changes, registry modifications).','Dynamic analysis is less accurate','Static analysis requires running the malware','b','Static: fast, safe, identifies known malware (hash matching), reveals strings and imports. Dynamic (sandbox like Cuckoo): reveals obfuscated behaviour, network IOCs, persistence mechanisms. Combined: complete picture.','medium',2,20),

('malware','Malware & Threats',8,'What techniques do malware authors use for obfuscation?','Removing all code comments','Packing (compression/encryption of code), polymorphism (mutating code on each infection), metamorphism (rewriting code structure), and code virtualisation — all to evade signature-based detection','Using longer variable names','Adding extra functions','b','Packer (UPX): compresses binary, stub unpacks at runtime. Polymorphic: encrypted payload with mutating decryptor. Metamorphic: entire code rewrites. Virtualisation: custom bytecode VM (VMP). Defeats hash-based AV.','medium',2,20),

('malware','Malware & Threats',8,'What is a fileless attack and why is it harder to detect?','An attack with no network traffic','Malware that lives entirely in memory, using legitimate tools (PowerShell, WMI, LOLBins) to execute payloads without writing malicious files to disk — evades file-based AV','An attack that deletes all files','A network scanning technique','b','Fileless: PowerShell empire, CobaltStrike in-memory payloads. No disk artifact → no hash to scan. Detection: memory scanning (EDR), behavioural analysis, process injection detection, PowerShell script block logging.','medium',2,20),

('malware','Malware & Threats',8,'What is a command and control (C2) server?','A legitimate system management server','A server controlled by an attacker that sends instructions to compromised hosts (bots) and receives exfiltrated data — the communication backbone of malware operations','A backup server','An authentication server','b','C2 channels: HTTP(S) to blend with normal traffic, DNS tunnelling, social media APIs, Tor. Detection: analyse outbound connections for beaconing patterns, unusual DNS queries, encrypted traffic to unknown hosts.','medium',2,20),

('malware','Malware & Threats',8,'What is the MITRE ATT&CK framework''s relationship to malware analysis?','A malware development tool','A structured knowledge base mapping adversary techniques (TTPs) used by malware to phases of an attack, enabling detection engineering and threat hunting','An antivirus product','A malware sandbox','b','ATT&CK: each technique (e.g. T1059.001 PowerShell) maps to detection opportunities. Malware analysts identify techniques used and map to ATT&CK to understand actor capability and build detection rules.','medium',2,20),

('malware','Malware & Threats',8,'What is a supply chain attack? Give a real-world example.','Attacking delivery trucks','Compromising software or hardware before it reaches the target — e.g. SolarWinds 2020: attackers injected backdoor into the build pipeline affecting 18,000+ organisations including US government agencies','A physical break-in','A DDoS attack on a vendor','b','SolarWinds Orion: SUNBURST backdoor signed with valid certificate injected into update. Other examples: XZ Utils backdoor (2024), NotPetya via Ukrainian accounting software, CCleaner compromise.','medium',2,20),

('malware','Malware & Threats',8,'What is credential dumping and which tools are commonly used?','Cracking passwords via brute force','Extracting password hashes or plaintext credentials from memory or credential stores (LSASS, SAM, NTDS.dit) on compromised Windows systems','Phishing for credentials','Network packet capture for credentials','b','Mimikatz: sekurlsa::logonpasswords dumps LSASS credentials. Volatility: memory forensics. Protections: Credential Guard (Hyper-V isolates LSASS), Protected Users group, WDigest disabled, PPL for LSASS.','medium',2,20),

('malware','Malware & Threats',8,'What is lateral movement and what techniques do attackers use?','Moving data between storage devices','Techniques used after initial compromise to move through a network to reach target systems — includes pass-the-hash, pass-the-ticket, RDP, WMI, SMB, and Kerberoasting','Network traffic monitoring','Log file deletion','b','Lateral movement (ATT&CK TA0008): attacker uses stolen credentials or exploits to access more systems. Pass-the-hash: use NTLM hash without knowing password. Pass-the-ticket: forge Kerberos tickets.','medium',2,20),

('malware','Malware & Threats',8,'What is persistence and common techniques attackers use to maintain access?','Keeping a database connection open','Mechanisms to survive reboots and re-access compromised systems — registry run keys, scheduled tasks, startup folders, WMI subscriptions, and modified boot sectors (bootkits)','Data backup techniques','Session management in web apps','b','ATT&CK TA0003. Common: HKCU\Software\Microsoft\Windows\CurrentVersion\Run registry key, Task Scheduler, DLL hijacking, service installation, bootkit. Detection: monitor registry, scheduled tasks, new services.','medium',2,20),

('malware','Malware & Threats',8,'What is a watering hole attack?','Infecting a water utility','Compromising websites frequented by a specific target group, then infecting visitors with malware when they visit the trusted site','Poisoning DHCP servers','A DDoS attack variant','b','Watering hole: attacker compromises a niche forum or industry site their targets visit. Example: dissidents reading specific news sites served browser exploits. Harder to detect than spear phishing.','medium',2,20),

-- Tier 3
('malware','Malware & Threats',8,'Explain how process injection works (e.g. DLL injection, process hollowing).','Running two processes simultaneously','Techniques to execute malicious code within the address space of a legitimate process: DLL injection forces a process to load a malicious DLL; process hollowing creates a suspended process, unmaps its code, and replaces it with malware','Memory allocation techniques','A type of buffer overflow','b','DLL inject: OpenProcess → VirtualAllocEx → WriteProcessMemory → CreateRemoteThread(LoadLibrary). Process hollowing: CREATE_SUSPENDED, ZwUnmapViewOfSection, WriteProcessMemory(shellcode), SetThreadContext, ResumeThread. Both evade process-based detection.','hard',3,30),

('malware','Malware & Threats',8,'What is the difference between a RAT and a backdoor?','They are identical','A RAT (Remote Access Trojan) provides interactive control with features like webcam access, keylogging, and file management; a backdoor is simpler, providing remote shell or persistent access without the full feature set','RATs are legal admin tools; backdoors are not','Backdoors are network-level; RATs are host-level','b','RAT features: screen capture, keylogger, webcam, mic, file browser, reverse shell, lateral movement staging. Examples: DarkComet, NjRAT, CobaltStrike Beacon. Backdoors: simple persistent remote shell, netcat listener.','hard',3,30),

('malware','Malware & Threats',8,'How does anti-analysis detection work in malware, and how do analysts bypass it?','Malware checks for internet connectivity','Malware detects sandbox environments via timing (sleep bypasses), sandbox artefacts (VMware registry keys, Cuckoo files, suspicious process lists, mouse movement), then behaves benignly — analysts bypass with custom sandbox environments, patching sleep calls, and environmental mimicry','Encryption prevents all analysis','Malware blocks debuggers by crashing the system','b','Anti-debug: IsDebuggerPresent, NtQueryInformationProcess, timing checks. Anti-VM: CPUID hypervisor bit, VMware files/processes, abnormal disk sizes. Bypass: user-mode instrumentation, custom VMs, FLARE VM, patching the checks.','hard',3,30),

('malware','Malware & Threats',8,'What is a kernel rootkit and how does it subvert OS security?','A user-mode privacy tool','Malware running in kernel space (ring 0) that hooks OS system calls (SSDT hooking), manipulates kernel structures (DKOM), or loads malicious kernel drivers to hide processes and files from user-mode tools','A BIOS-level firmware modification','A hypervisor vulnerability','b','DKOM (Direct Kernel Object Manipulation): unlinks a process from the EPROCESS list → invisible to tasklist/ps. SSDT hook: intercept NtQuerySystemInformation to hide processes. Detected by: kernel integrity checking, comparing in-memory vs on-disk driver signatures.','hard',3,30),

('malware','Malware & Threats',8,'What is a polymorphic virus and how does an AV detect it?','A virus affecting multiple OS types','A virus that mutates its code (encryption key, decryptor stub) on each infection while preserving functionality, evading static signature detection — detected via emulation, heuristics, and behavioural analysis','A multi-stage worm','A Trojan with multiple payloads','b','Polymorphic: encrypted payload with mutating decryptor. AV emulates execution in a sandbox until decryptor reveals payload, then scans. Heuristics flag suspicious behaviours (self-modification, API call patterns) without needing exact signatures.','hard',3,30),

('malware','Malware & Threats',8,'What is Kerberoasting and how does it compromise Active Directory?','A network scanning attack','An offline attack where any authenticated domain user requests Kerberos service tickets (TGS) for service accounts, then cracks the ticket offline to recover the service account password','A password spray attack','A pass-the-hash technique','b','Kerberoasting: SPNs (Service Principal Names) → request TGS encrypted with service account NTLM hash → extract encrypted ticket → hashcat/john → crack offline. Mitigation: long random service account passwords (AES encryption for tickets), tiered admin model.','hard',3,30),

('malware','Malware & Threats',8,'What is the difference between APT and commodity malware?','APT is more expensive','APT (Advanced Persistent Threat) involves sophisticated, targeted, long-term campaigns by well-resourced threat actors (nation-states) using custom tools, zero-days, and living-off-the-land; commodity malware uses mass-market tools widely sold on criminal forums','APT only targets governments','They use the same techniques','b','Commodity: Emotet, Ryuk ransomware, readily available RATs. APT: Lazarus Group (DPRK), APT28/Fancy Bear (Russia), APT41 (China). APTs use custom implants, avoid reuse of IOCs, and maintain access for months to years.','hard',3,30),

('malware','Malware & Threats',8,'What is the role of a memory forensics tool like Volatility in malware analysis?','Running malware safely in a sandbox','Analysing a physical memory dump to extract running processes, network connections, loaded modules, injected code, encryption keys, and artefacts that are invisible to the OS because they''re hidden by rootkits','Disassembling malware binaries','Analysing network packet captures','b','Volatility plugins: pslist (process list), dlllist (loaded DLLs), malfind (injected code), netscan (network connections), hashdump (SAM hashes), cmdscan (command history). Bypasses DKOM rootkits by scanning memory structures directly.','hard',3,30),

('malware','Malware & Threats',8,'What is a logic bomb and how does it differ from other malware?','A DoS attack bomb payload','Code that executes a malicious payload only when specific conditions are met (date, user action, event) — often planted by insiders and dormant until triggered','A polymorphic virus variant','A type of adware','b','Logic bombs: used by disgruntled employees to cause damage (file deletion, ransomware) if they are fired (checking if their username still exists). Detected by code review, change management, and insider threat monitoring programs.','hard',3,30),

('malware','Malware & Threats',8,'What is DNS tunnelling and how is it used for C2?','Using DNS for DDoS amplification','Encoding data inside DNS queries/responses (e.g. base64 data as subdomain labels) to create a covert communication channel through firewalls that allow DNS traffic','Poisoning DNS cache entries','Brute-forcing DNS zone transfers','b','DNS tunnel: attacker controls nameserver for eviltunnel.com. Bot sends: `base64data.eviltunnel.com` DNS query. Attacker''s NS receives it, decodes command, sends base64 response in DNS TXT/CNAME record. Bypasses HTTP proxies. Detection: high DNS query volume, unusual subdomain lengths, NX domain rates.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 9. SOCIAL ENGINEERING  (slug: social-engineering)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

('social-engineering','Social Engineering',9,'What is pretexting?','Sending phishing emails','Creating a fabricated scenario (pretext) to manipulate a target into revealing information or taking an action they otherwise would not','A type of DDoS attack','Network scanning','b','Pretexting: impersonating IT support ("I need your password to fix your account"), auditors, or vendors. The attacker researches the target and builds a convincing cover story.','easy',1,10),

('social-engineering','Social Engineering',9,'What is tailgating (piggybacking)?','Following someone online','Physically following an authorised person into a restricted area without using your own credentials','Monitoring network traffic','An email phishing technique','b','Tailgating bypasses physical security by exploiting people''s natural tendency to hold doors open. Mitigation: mantraps, security training to challenge strangers, turnstiles.','easy',1,10),

('social-engineering','Social Engineering',9,'What is vishing?','A type of phishing email','Voice phishing — using phone calls to manipulate targets into revealing sensitive information or taking actions','A network scanning technique','A type of malware','b','Vishing: attackers call claiming to be IT support, bank fraud teams, or government agencies, creating urgency. Example: "Your account has been compromised, verify your SSN now." Always verify via official callback numbers.','easy',1,10),

('social-engineering','Social Engineering',9,'What is smishing?','SMS spam','Phishing via SMS/text messages containing malicious links or requests for sensitive information','A type of network attack','Email phishing','b','Smishing exploits SMS trust. Examples: fake package delivery links, bank fraud alerts, prize notifications. Mobile users click links more readily. Mitigation: verify sender via official channels before clicking.','easy',1,10),

('social-engineering','Social Engineering',9,'What is baiting?','A DDoS technique','Leaving physical media (USB drives) or digital lures to entice victims into plugging in or clicking something malicious','Network packet injection','An email spoofing technique','b','Baiting: USB drops in car parks with labels like "Payroll Q4" or "Private." Studies show 48%+ of people plug in found USBs. Mitigation: disable autorun, training, endpoint controls preventing unknown USB devices.','easy',1,10),

('social-engineering','Social Engineering',9,'What is spear phishing?','Mass phishing emails sent to millions','Highly targeted phishing attack tailored to a specific individual or organisation using personal information gathered from OSINT','A type of network attack','A phone-based scam','b','Spear phishing uses the target''s name, role, colleagues, and current projects to craft convincing messages. Far more effective than generic phishing. BEC attacks start with spear phishing.','easy',1,10),

('social-engineering','Social Engineering',9,'What is whaling?','A type of network DDoS','Spear phishing attacks specifically targeting senior executives (CEOs, CFOs) to gain access to high-value accounts or authorise large financial transfers','A social media hacking technique','A type of malware','b','Whaling: targeting C-suite. CEO fraud: impersonate CEO to CFO requesting urgent wire transfer. High-value targets justify extensive research and sophisticated attacks.','easy',1,10),

('social-engineering','Social Engineering',9,'Why is social engineering often more effective than technical hacking?','Technical exploits are always patched quickly','Humans are the weakest security link — they can be manipulated through emotions like urgency, fear, authority, and trust, bypassing even the most sophisticated technical controls','Social engineering only works on non-technical people','Technical hacking requires no skill','b','Human psychological vulnerabilities (Cialdini: authority, urgency, reciprocity, social proof, scarcity) are harder to patch than software. 74-82% of breaches involve the human element (Verizon DBIR).','easy',1,10),

('social-engineering','Social Engineering',9,'What is OSINT and how is it used in social engineering?','A network scanning tool','Open Source Intelligence — gathering publicly available information (LinkedIn, social media, company websites, WHOIS) to research targets and craft convincing attacks','A type of malware','A firewall configuration','b','OSINT tools: Maltego, theHarvester, Shodan, LinkedIn, Google dorking. Attackers build detailed target profiles: job role, colleagues, recent projects, travel — enabling convincing pretexts.','easy',1,10),

('social-engineering','Social Engineering',9,'What is a quid pro quo attack?','Attacking exchange servers','Offering something of value (free tech support, prizes) in exchange for information or access','A network MitM attack','Impersonating a colleague via email','b','Quid pro quo ("something for something"): attacker calls offering free IT help, "security upgrade," or gift in exchange for login credentials or executing a file. Exploits reciprocity principle.','easy',1,10),

-- Tier 2
('social-engineering','Social Engineering',9,'What psychological principles make social engineering so effective?','Memory and logic','Cialdini''s six principles: Authority (obey experts), Urgency/Scarcity (act fast), Reciprocity (return favours), Social Proof (others do it), Commitment (stay consistent), and Liking (comply with people we like)','Technical knowledge gaps','Weak passwords','b','These principles are exploited systematically: "Your CEO just called urgently" (authority + urgency), "50% of your colleagues already signed up" (social proof), "I fixed your computer last month" (reciprocity, liking).','medium',2,20),

('social-engineering','Social Engineering',9,'What is a watering hole attack and how does it use social engineering?','Poisoning a physical water supply','Compromising websites frequently visited by the target group, turning a trusted site into an attack vector — targets are socially engineered by their own browsing habits','A direct phishing email','An attack on DNS resolvers','b','Watering hole: attacker identifies sites visited by targets (industry forums, vendor portals), compromises them with browser exploits or credential harvesting forms. Targets are not suspicious of sites they regularly trust.','medium',2,20),

('social-engineering','Social Engineering',9,'What is business email compromise (BEC) and what makes it hard to detect?','Mass phishing campaigns','A targeted attack using compromised or spoofed executive email accounts to authorise fraudulent wire transfers or data disclosure — lacks malware so bypasses AV','A ransomware delivery method','A network intrusion technique','b','BEC losses: $43B+ reported to FBI IC3 (2016-2021). No malware = no AV detection. Attacker may monitor email for weeks before striking. Verification: call the requester on a known number; implement dual approval for wire transfers.','medium',2,20),

('social-engineering','Social Engineering',9,'What is a phishing simulation and why do organisations run them?','Sending real phishing attacks to test users','Controlled, safe phishing exercises run by security teams to measure employee susceptibility and identify training needs without real harm','A type of penetration test','A firewall testing technique','b','Phishing simulations (KnowBe4, Proofpoint): click rates, report rates, credential submission rates measured. Users who fail get targeted training. Industry goal: <5% click rate vs 30%+ baseline. Test regularly — training decays.','medium',2,20),

('social-engineering','Social Engineering',9,'How do attackers use LinkedIn and social media for reconnaissance?','They hack LinkedIn''s servers','Gathering target names, roles, relationships, recent projects, and technology stacks to craft convincing pretexts and spear phishing emails','By posting malware on LinkedIn','Only useful for finding email addresses','b','LinkedIn reveals org structure, tech stack (job postings mention "must know AWS, Palo Alto"), employee names (for spoofing), and recent news (for timely pretexts). Job ads reveal security tools attackers must evade.','medium',2,20),

('social-engineering','Social Engineering',9,'What is the difference between impersonation and identity spoofing?','They are identical','Impersonation: physically or verbally pretending to be someone (IT, vendor, auditor). Identity spoofing: technically forging email headers, caller ID, or websites to appear as a trusted entity','Spoofing is less effective','Impersonation only works in person','b','Both exploit trust. Email spoofing: forge From header or use lookalike domain (paypa1.com). Caller ID spoofing: software changes displayed number. Physical impersonation: fake ID/uniform. Countermeasures differ for each.','medium',2,20),

('social-engineering','Social Engineering',9,'What is a deepfake and how is it used in social engineering?','A type of database attack','AI-generated synthetic audio or video that realistically impersonates a person, used to create fake executive voice calls or video to authorise transactions or spread disinformation','A type of phishing email','A network scanning tool','b','Deepfake SE: a CFO received a WhatsApp voice note from the "CEO" authorising $35M transfer (Hong Kong, 2023). Detection: anomalies in blinking/lighting, verification out-of-band via established channels.','medium',2,20),

('social-engineering','Social Engineering',9,'What security controls most effectively reduce social engineering risk?','Technical firewalls alone','Multi-layered defence: security awareness training, simulated phishing, clear verification procedures, technical controls (MFA, DMARC, email security), and a culture where employees feel safe challenging suspicious requests','Monitoring all emails','Restricting internet access','b','No single control works. Training + simulation + clear procedures (verify via phone for sensitive requests) + technical controls + culture (no blame for reporting) + zero-trust architecture provides layered defence.','medium',2,20),

('social-engineering','Social Engineering',9,'What is tailgating prevention and what does a mantrap do?','A firewall for wireless networks','A mantrap is a physical security control with two doors: only one can open at a time, forcing one person through at a time and preventing tailgating','A VPN configuration','An email filter','b','Mantrap (airlock): entrance chamber with two interlocked doors. Security verifies identity before second door opens. Prevents both tailgating and piggybacking. Used in data centres, banks, and high-security facilities.','medium',2,20),

('social-engineering','Social Engineering',9,'What is the "pretexting" technique used against Hewlett-Packard''s board in 2006?','SQL injection against HP''s database','HP investigators used false pretences (pretexting) to obtain phone records of board members and journalists by impersonating targets to their phone carriers — led to US federal pretexting legislation','A physical break-in','Email hacking','b','HP pretexting scandal: investigators called phone companies pretending to be board members to obtain call records. Exposed surveillance of board members and journalists. Led to CPNI (Customer Proprietary Network Information) regulations.','medium',2,20),

-- Tier 3
('social-engineering','Social Engineering',9,'How does the Milgram obedience experiment relate to social engineering attacks?','It demonstrates phishing effectiveness','It showed that ordinary people will follow authority figures even against their own judgment — explaining why attackers impersonating IT, executives, or government officials so effectively compel compliance','It only applies to military contexts','It shows people resist manipulation','b','Milgram: 65% of participants administered maximum electric shocks when instructed by an authority figure. SE exploits this — "This is IT security. We need your credentials immediately or your account will be suspended."','hard',3,30),

('social-engineering','Social Engineering',9,'What is a sophisticated multi-stage social engineering campaign (APT-level)?','A single phishing email','A long-running operation combining OSINT (weeks of research), spear phishing to establish initial access, pretexting calls to expand access, and insider relationship building — all before any technical exploitation','A mass spam campaign','A DDoS attack followed by phishing','b','APT SE: research target for months (LinkedIn, public filings, former employees), compromise a trusted vendor, use vendor access to enter target. RSA 2011: spear phish to engineer → pivot to RSA systems → steal SecurID data → use to attack Lockheed.','hard',3,30),

('social-engineering','Social Engineering',9,'What is MICE (Money, Ideology, Coercion, Ego) and its relevance to insider threats?','A network attack acronym','A framework from intelligence tradecraft describing motivations for recruiting insiders; used in insider threat programs to identify employees vulnerable to social engineering or recruitment by adversaries','A malware category','A password policy framework','b','MICE motivations: Money (financial stress), Ideology (political/religious beliefs), Coercion (blackmail, threats), Ego (disgruntlement, need for recognition). Insider threat programs monitor behavioural indicators correlated with these factors.','hard',3,30),

('social-engineering','Social Engineering',9,'How do sophisticated attackers use pretexting to pass two-factor authentication?','2FA is impossible to bypass','Real-time phishing: victim enters credentials on fake site → attacker immediately logs in to real site with stolen creds → attacker triggers MFA → fake site prompts victim for OTP → attacker enters it in real-time before expiry','Social engineering bypasses 2FA always','Using SIM swapping before the call','b','Evilginx, Modlishka: reverse proxy MitM captures credentials AND session cookies in real time. SIM swap: socially engineer mobile carrier to port victim number → receive OTP SMS. Account recovery: "lost phone" pretext resets MFA.','hard',3,30),

('social-engineering','Social Engineering',9,'What is social engineering in the context of physical security assessments (red team)?','Hacking into physical security systems','Red teamers physically impersonate vendors, contractors, or employees using forged credentials, tailgating, pretext calls, and social engineering to gain physical access to restricted areas and plant rogue devices','Digital-only security assessments','Network penetration testing','b','Physical social engineering: dressing as IT (shirt+badge), calling ahead ("I''m coming for the server room maintenance"), exploiting politeness culture, leaving malicious USB in reception. Physical access = game over for most security controls.','hard',3,30),

('social-engineering','Social Engineering',9,'What is the relationship between SE and the OODA loop in attack/defence?','OODA is only for military','OODA (Observe-Orient-Decide-Act) describes how both attackers and defenders process and respond to information; attackers use SE to disrupt defenders'' OODA loop by feeding false information (deception) or overwhelming it (urgency)','OODA is a type of malware','OODA only applies to nation-state actors','b','Attacker OODA: observe target (OSINT), orient (pretext), decide (attack vector), act (SE call/email). Defenders use OODA for incident response. SE attacks disrupt defender OODA by creating urgency (no time to verify) or providing false observations.','hard',3,30),

('social-engineering','Social Engineering',9,'What are the key elements of a security awareness program that actually changes behaviour?','Annual compliance training video','Continuous micro-learning, simulated phishing with immediate targeted feedback, clear simple reporting procedures, leadership modelling, and psychological safety to report suspicious activity without fear','One-time classroom training','Technical email filtering alone','b','Verizon DBIR: well-trained organisations achieve <1% click rates. Elements: engaging content (not compliance-focused), frequent simulations, just-in-time training post-fail, gamification, phishing report button, positive reinforcement for reporting.','hard',3,30),

('social-engineering','Social Engineering',9,'How does SE differ at nation-state level compared to criminal SE?','Nation-states only use technical attacks','Nation-state SE involves long-term relationship building (years), complex pretexts, use of intelligence community resources to research targets, and is embedded within broader intelligence collection operations — criminal SE is typically opportunistic and short-term','Nation-states are less skilled','Criminal SE is more sophisticated','b','APT28/Cozy Bear: months building relationships before attempting extraction. Intelligence agencies recruit insiders at security conferences (Honey trap, ideological recruitment). Criminal groups: rapid, volume-based, financially motivated.','hard',3,30),

('social-engineering','Social Engineering',9,'What is clone phishing and how does it differ from standard phishing?','Cloning entire websites','An attack where a legitimate, previously delivered email is duplicated with its links/attachments replaced by malicious versions, and re-sent appearing to come from the original sender','Creating fake login pages','A type of watering hole attack','b','Clone phishing exploits trust in legitimate emails: "Resending invoice as the previous link expired." The cloned email looks identical but links point to malicious sites. Harder to detect because the email content is genuine except for the payload.','hard',3,30),

('social-engineering','Social Engineering',9,'What is cognitive biases exploitation in SE and give three examples used by attackers?','Logical reasoning about targets','Deliberate exploitation of mental shortcuts: Authority bias (comply with perceived experts), Scarcity bias (act before it''s too late), Confirmation bias (mark suspicious emails as legitimate when they match expectations)','Technical vulnerability exploitation','Database query manipulation','b','Anchoring: first number/fact skews perception. Availability heuristic: vivid threats feel more likely. Framing: "This will protect you" vs "Failure to act will expose you." Social proof: "Your colleagues have already verified their accounts." All exploited systematically in SE.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 10. CLOUD SECURITY  (slug: cloud-security)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

('cloud-security','Cloud Security',10,'What is the shared responsibility model in cloud security?','The cloud provider handles all security','Security responsibilities are divided: cloud provider secures the underlying infrastructure; customer secures what they deploy on it (OS, apps, data, IAM depending on service model)','Customer handles only networking','There is no shared model in cloud','b','IaaS: customer manages OS+apps. PaaS: customer manages apps+data. SaaS: customer manages only data and access. Misunderstanding this model is a leading cause of cloud breaches.','easy',1,10),

('cloud-security','Cloud Security',10,'What does IAM stand for in cloud security?','Internet Access Management','Identity and Access Management — controlling who can access what cloud resources through roles, policies, and permissions','IP Address Management','Incident and Alert Management','b','Cloud IAM (AWS IAM, Azure AD, GCP IAM): users, groups, roles, and policies define what actions are permitted on which resources. Principle of least privilege is critical — over-permissioned roles are a primary attack vector.','easy',1,10),

('cloud-security','Cloud Security',10,'What is an S3 bucket and what makes it a security risk if misconfigured?','A storage unit in a data centre','An AWS Simple Storage Service container for objects; if set to public read, anyone on the internet can access all stored data, including sensitive files','A database service','A compute instance type','b','S3 misconfigurations have exposed billions of records (Capital One, Facebook data). Check: S3 Block Public Access settings, bucket policies, ACLs. Use AWS Config and Security Hub to detect public buckets.','easy',1,10),

('cloud-security','Cloud Security',10,'What is multi-tenancy and its security implications in cloud?','A multi-region deployment strategy','Multiple customers sharing the same physical infrastructure; security risk: a vulnerability in the hypervisor or container runtime could allow tenant isolation breakout','A type of load balancing','A database partitioning technique','b','Multi-tenancy: one physical server hosts VMs for many customers. Hypervisor vulnerabilities (VM escape), container escapes (runc CVE-2019-5736), and side-channel attacks (Spectre/Meltdown) can break tenant isolation.','easy',1,10),

('cloud-security','Cloud Security',10,'What is a cloud access security broker (CASB)?','A cloud load balancer','A security tool acting as an intermediary between users and cloud services to enforce policies, provide visibility, and protect data across multiple cloud applications','A DNS resolver for cloud','A type of web application firewall','b','CASB provides: discovery of shadow IT, DLP (block upload of sensitive data to personal Dropbox), threat protection, compliance reporting. Can be API-mode (post-action) or inline proxy (real-time).','easy',1,10),

('cloud-security','Cloud Security',10,'What is DevSecOps?','A development methodology ignoring security','Integrating security practices into the DevOps pipeline — shifting security left so vulnerabilities are found during development, not after deployment','A cloud deployment model','A compliance framework','b','DevSecOps: SAST (static analysis) in CI, SCA (dependency scanning), secrets detection (GitLeaks), DAST in staging, container image scanning, IaC security scanning (Checkov) — security gates at every pipeline stage.','easy',1,10),

('cloud-security','Cloud Security',10,'What is a security group in AWS?','A team responsible for security','A virtual firewall controlling inbound and outbound traffic for EC2 instances using allow rules (deny is implicit for anything not allowed)','A type of IAM role','A VPC routing table','b','AWS Security Groups are stateful: if you allow inbound traffic, the response is automatically allowed. Bad practice: `0.0.0.0/0` (anywhere) on port 22 (SSH) or 3389 (RDP) — exposes instances to brute force globally.','easy',1,10),

('cloud-security','Cloud Security',10,'What is Infrastructure as Code (IaC) and why does it matter for security?','Code that manages physical hardware','Defining and provisioning cloud infrastructure via code (Terraform, CloudFormation, Pulumi) enabling version control, automated scanning for misconfigurations, and reproducible secure baselines','A type of PaaS service','Containerisation technology','b','IaC: Terraform HCL or CloudFormation YAML defines cloud resources as code. Security benefit: scan with Checkov/tfsec before deployment to catch misconfigurations (public S3, open security groups) in the PR.','easy',1,10),

('cloud-security','Cloud Security',10,'What is the principle of least privilege in cloud IAM?','Giving admin to all users for speed','Granting users, services, and applications only the minimum permissions required to perform their specific function, and no more','Using strong passwords','Enabling MFA','b','Over-permissioned IAM is #1 cloud risk. Wildcard policies (`*`) are dangerous. AWS IAM Access Analyzer, GCP IAM Recommender, and Azure AD Access Reviews identify and reduce excess permissions.','easy',1,10),

('cloud-security','Cloud Security',10,'What is a VPC (Virtual Private Cloud)?','A type of virtual machine','An isolated private network within a public cloud where you control IP ranges, subnets, route tables, and network gateways','A container orchestration service','A CDN service','b','VPCs provide network isolation. Subnets: public (internet-accessible) vs private (no direct internet access). Internet Gateway: outbound internet. NAT Gateway: private subnet internet via NAT. Security groups + NACLs control traffic.','easy',1,10),

-- Tier 2
('cloud-security','Cloud Security',10,'What is the SSRF vulnerability specific to cloud environments and how was it used in the Capital One breach?','SSRF does not affect cloud','An SSRF attack on a cloud instance that hits the instance metadata endpoint (169.254.169.254 for AWS) to steal IAM credentials, which was used to access S3 buckets containing 100M+ customer records','An SQL injection in AWS RDS','A DDoS attack on cloud APIs','b','Capital One 2019: WAF misconfiguration allowed SSRF → fetched `http://169.254.169.254/latest/meta-data/iam/security-credentials/` → retrieved temporary IAM credentials → accessed S3 data. IMDSv2 (token-required) mitigates this.','medium',2,20),

('cloud-security','Cloud Security',10,'What is the difference between CSPM and CWPP?','They are identical tools','CSPM (Cloud Security Posture Management): continuously monitors cloud configuration for misconfigurations and compliance. CWPP (Cloud Workload Protection Platform): secures workloads at runtime (VMs, containers, serverless) from threats.','CSPM is for AWS only','CWPP only scans code','b','CSPM: detects "this S3 bucket is public" or "this EC2 instance has no MFA". CWPP: detects "this container is running crypto mining malware" or "this process is attempting privilege escalation." Both needed for comprehensive cloud security.','medium',2,20),

('cloud-security','Cloud Security',10,'What are the main attack techniques against Kubernetes clusters?','Kubernetes has no attack surface','Attacks include: compromised container escaping to host node, exploiting exposed kubeapi (no auth), abusing overprivileged service account tokens, using misconfigured RBAC, and compromising the etcd database','Kubernetes is only deployed on-premises','Container attacks are not a concern','b','K8s attacks (Tesla 2018): exposed kubelet API → run crypto miner pod. Overprivileged service accounts: if compromised, attacker can create privileged pods → escape to host. etcd: stores all cluster secrets unencrypted → encrypt at rest.','medium',2,20),

('cloud-security','Cloud Security',10,'What is secrets management in cloud and what tools address it?','Storing passwords in code','The practice of securely storing, rotating, and auditing credentials, API keys, and certificates used by applications — addressed by AWS Secrets Manager, HashiCorp Vault, Azure Key Vault','Encrypting S3 buckets','Using strong IAM passwords','b','Hardcoded secrets in source code (GitLeaks finds these) are a critical risk. Secrets managers: inject credentials at runtime, auto-rotate, audit access. Never store secrets in environment variables committed to Git.','medium',2,20),

('cloud-security','Cloud Security',10,'What is cloud logging and monitoring and which services provide it?','Turning on debug mode','Capturing API calls, resource changes, and network flows for security monitoring — AWS CloudTrail (API calls), VPC Flow Logs (network), GuardDuty (threat detection), CloudWatch (metrics/logs), AWS Config (config changes)','Only relevant for compliance','Only monitoring CPU usage','b','CloudTrail: every AWS API call logged. GuardDuty: ML-based threat detection (unusual IAM activity, crypto mining, C2 communication). Without logging, you cannot detect or investigate incidents. Enable in all regions.','medium',2,20),

('cloud-security','Cloud Security',10,'What is a container escape attack?','A pod being deleted','A vulnerability exploitation allowing code running in a container to break out of its isolation and gain access to the host OS or other containers — examples: runc CVE-2019-5736, dirty cow in containers','An Kubernetes upgrade process','A type of DDoS','b','Container escape techniques: writable host path mounts, privileged container mode, kernel exploits (runC), volume mounts exposing host filesystem, socket mounts (docker.sock). Prevention: non-root containers, seccomp, AppArmor, no privileged mode.','medium',2,20),

('cloud-security','Cloud Security',10,'What is Zero Trust security architecture?','Trusting users inside the network perimeter','A security model where no user, device, or network location is implicitly trusted; every access request is authenticated, authorised, and continuously validated regardless of network location','Enabling MFA only','A cloud-specific framework','b','Zero Trust: "never trust, always verify." Microsegmentation: per-service access. Continuous verification: re-evaluate trust based on device posture, location, behaviour. Eliminates the concept of a trusted internal network.','medium',2,20),

('cloud-security','Cloud Security',10,'What is data sovereignty and why is it relevant for cloud?','Encrypting data in transit','The concept that data is subject to the laws and regulations of the country where it physically resides — relevant because cloud data may be stored in multiple countries without explicit customer awareness','A type of backup policy','A cloud networking concept','b','GDPR requires EU personal data to stay within EEA (or countries with adequacy decisions). Cloud providers offer regional data residency controls. Organisations must understand where data actually resides in multi-region cloud setups.','medium',2,20),

('cloud-security','Cloud Security',10,'What is cloud native application protection platform (CNAPP)?','A cloud database service','A unified security platform converging CSPM, CWPP, container security, IaC scanning, and software supply chain security to provide comprehensive cloud native security from development to runtime','A type of WAF','An IAM solution','b','CNAPP (Palo Alto Prisma Cloud, Wiz, Lacework) provides: code scanning (IaC, SCA), cloud posture (CSPM), workload protection (CWPP), data security (DSPM), and runtime protection in a single platform. Emerging standard for cloud security.','medium',2,20),

('cloud-security','Cloud Security',10,'What is the difference between encryption at rest and in transit in cloud, and what is client-side encryption?','They are identical','At-rest: data encrypted when stored (AES-256, managed by cloud or customer KMS key). In-transit: TLS between services. Client-side: data encrypted before sending to cloud so provider never sees plaintext.','Client-side encryption is less secure','In-transit encryption stores keys on the client','b','AWS KMS manages envelope encryption. Client-side: customer controls the key entirely — even a subpoena to AWS cannot produce plaintext. Critical for ultra-sensitive data. Trade-off: customer manages key lifecycle and rotation.','medium',2,20),

-- Tier 3
('cloud-security','Cloud Security',10,'What is the attack path in a cloud environment from initial access to data exfiltration?','A single-step database dump','Initial access (phishing/public API → EC2/Lambda compromise) → IMDS credential theft or IAM key compromise → lateral movement via assumed roles → privilege escalation via privilege escalation policies → data access → S3 exfiltration or RDS dump','Only possible with physical access','Cloud attacks always require zero-days','b','AWS attack path: compromise worker node → steal pod service account token → list IAM policies → find assumable role with S3 read → exfiltrate data to attacker-controlled bucket. CloudTrail and GuardDuty should detect each step.','hard',3,30),

('cloud-security','Cloud Security',10,'What is the confused deputy problem in cloud IAM and how is it exploited?','A misdirected network route','When a service (the deputy) with high privileges is tricked by a less-privileged principal into performing actions on their behalf — in cloud, cross-account resource access without ExternalId can lead to cross-account privilege escalation','A typo in IAM policies','A networking misconfiguration','b','Confused deputy: attacker knows ARN of role in victim account → calls AWS STS AssumeRole from their account (if trust policy allows *) → gets victim account permissions. Mitigation: require ExternalId in trust policies for cross-account roles.','hard',3,30),

('cloud-security','Cloud Security',10,'How does Spectre/Meltdown affect cloud multi-tenant security?','These are network attacks','Side-channel vulnerabilities in CPU speculative execution that allow a process to read memory of other processes on the same physical host — in cloud, a compromised VM could potentially read data from a neighbouring tenant''s VM','They only affect older hardware','These were fully patched with no performance impact','b','Meltdown (CVE-2017-5754): any process reads kernel memory. Spectre (CVE-2017-5753/5715): bypass bounds checking. Cloud providers patched hypervisors (KPTI, retpoline) with 5-30% performance impact on I/O-heavy workloads. Risk: in multi-tenant cloud, VM isolation weakness.','hard',3,30),

('cloud-security','Cloud Security',10,'What is policy-as-code and how does it enforce cloud security?','Writing cloud policies in any language','Expressing security and compliance policies as machine-readable code (OPA/Rego, AWS SCPs, Sentinel) that is automatically enforced in pipelines and at runtime, preventing non-compliant resources from being deployed','Storing policies in S3','Using YAML for documentation','b','OPA (Open Policy Agent): policy engine that evaluates Rego rules. Use in: K8s admission controller (block privileged pods), Terraform plan evaluation (block public S3), API gateway authorisation. Shifts policy left from runtime remediation to pre-deployment prevention.','hard',3,30),

('cloud-security','Cloud Security',10,'What is cloud detection and response (CDR) and how does it differ from EDR?','They are identical','CDR monitors cloud control plane (API calls, IAM changes, resource creation) and data plane (network flows, workload behaviour) for threats at cloud scale; EDR monitors endpoint processes and files on individual hosts','CDR is less effective','CDR only works with AWS','b','CDR (AWS GuardDuty, Microsoft Defender for Cloud, Wiz Runtime) uses ML on CloudTrail to detect: impossible travel logins, credential stuffing, unusual API patterns, crypto mining. EDR catches endpoint-level malware; CDR catches cloud-level attacker TTP.','hard',3,30),

('cloud-security','Cloud Security',10,'What is shadow IT in cloud and how do CASB/CSPM tools address it?','Outdated IT systems','Unauthorised cloud services used by employees outside IT oversight — creating unmonitored attack surfaces; CASB discovers shadow SaaS via network traffic analysis and blocks non-approved services','Deprecated cloud APIs','Test environments left running','b','Shadow IT: developer creates personal AWS account for testing, stores production data. CASB: monitors egress traffic to unknown cloud services. CSPM: discovers all AWS accounts in the organisation via Organisations API. Shadow IT = biggest cloud risk most orgs underestimate.','hard',3,30),

('cloud-security','Cloud Security',10,'What is the supply chain risk in cloud-native applications and how does an SBOM help?','Only affects physical supply chains','Cloud apps use thousands of open source dependencies; a compromised package (XZ utils, left-pad) can affect all consuming apps. An SBOM (Software Bill of Materials) lists all components, enabling rapid identification of affected systems when a new CVE is published','Only relevant to compiled languages','SBOM is a compliance document only','b','SBOM (SPDX, CycloneDX format): machine-readable inventory of all components and versions. When log4shell dropped, organisations with SBOMs identified affected systems in hours vs days. Executive Order 14028 mandates SBOMs for US government software suppliers.','hard',3,30),

('cloud-security','Cloud Security',10,'How does workload identity federation work and why is it better than static credentials?','Federation requires more credentials','Instead of issuing static API keys, cloud providers allow workloads (GitHub Actions, K8s pods) to authenticate using short-lived tokens based on their verified identity, eliminating the need for long-lived secrets','Static credentials are more secure','Federation is only for user accounts','b','GitHub Actions OIDC: GH issues short-lived JWT → AWS STS exchanges for 1h IAM credential → pipeline accesses AWS without stored secrets. K8s: pod binds to service account → projected service account token → cloud IAM. No secret rotation needed; compromise limited to token lifetime.','hard',3,30),

('cloud-security','Cloud Security',10,'What is blast radius reduction in cloud and what techniques implement it?','Reducing DDoS damage','Architectural principle of limiting the damage a compromised component can cause: techniques include IAM least privilege, VPC microsegmentation, separate AWS accounts per environment, and short-lived credentials','Reducing server costs','Network bandwidth management','b','Blast radius: if one Lambda is compromised, can it read all S3 buckets? Techniques: separate prod/dev/staging AWS accounts (AWS Organisations), service control policies (SCPs), VPC endpoint policies restricting S3 to specific buckets, per-service IAM roles.','hard',3,30);

-- ════════════════════════════════════════════════════════
-- 11. CEH DOMAINS  (slug: ceh-domains)
-- ════════════════════════════════════════════════════════

INSERT IGNORE INTO quiz_questions
  (category, domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty, tier, points) VALUES

-- Tier 1 (easy)
('ceh-domains','Footprinting & Reconnaissance',1,'Which of the following is a passive footprinting technique?','Port scanning with nmap','Sending ICMP echo requests to the target','Searching WHOIS records online','Banner grabbing via Telnet','c','Passive footprinting collects information without directly interacting with the target system. WHOIS queries go to third-party registrar databases, leaving no trace on the target.','easy',1,10),

('ceh-domains','Scanning Networks',3,'Which scan type sends a SYN packet and sends RST on receiving SYN-ACK, without completing the handshake?','Full connect scan','SYN stealth (half-open) scan','XMAS scan','FIN scan','b','SYN stealth scan (nmap -sS) never completes the 3-way handshake, avoiding logging on many systems. It sends SYN → receives SYN-ACK → immediately sends RST.','easy',1,10),

('ceh-domains','Enumeration',4,'Which protocol is used to enumerate Windows network shares and user information?','SMTP','FTP','NetBIOS/SMB','HTTP','c','NetBIOS (port 139) and SMB (port 445) expose shares, usernames, and group memberships. Tools: enum4linux, smbclient, net use.','easy',1,10),

('ceh-domains','Vulnerability Analysis',5,'What does a vulnerability scanner like Nessus do?','Exploit vulnerabilities automatically','Identify known vulnerabilities in systems by comparing them against a database of CVEs','Patch operating systems remotely','Monitor network traffic','b','Nessus, OpenVAS, and Qualys scan targets for known CVEs, misconfigurations, and weak credentials. They report findings with CVSS scores and remediation guidance.','easy',1,10),

('ceh-domains','System Hacking',6,'What is the correct order of CEH system hacking phases?','Escalate → Gain access → Scan','Gain access → Escalate privileges → Maintain access → Cover tracks','Cover tracks → Gain access → Escalate','Scan → Gain access → Maintain access','b','CEH system hacking methodology: 1) Gain access, 2) Escalate privileges, 3) Maintain access, 4) Cover tracks. Each phase builds on the previous.','easy',1,10),

('ceh-domains','Malware Threats',7,'A Trojan differs from a virus because:','It replicates itself via email','It appears as legitimate software but carries a hidden malicious payload','It only targets Windows systems','It requires root access to install','b','Trojans masquerade as benign programs. Users voluntarily execute them. Unlike viruses, they do not self-replicate. Examples: fake antivirus, cracked software with embedded RATs.','easy',1,10),

('ceh-domains','Sniffing',8,'Which tool is the industry standard for packet capture and protocol analysis?','Metasploit','Nmap','Wireshark','Burp Suite','c','Wireshark is the GUI packet analyser that captures live traffic and decodes protocols across all OSI layers. Used by both defenders and attackers for traffic analysis.','easy',1,10),

('ceh-domains','Social Engineering',9,'What is the most common delivery method for social engineering attacks?','Physical break-in','Email phishing','USB drops','Phone calls','b','Email phishing accounts for over 90% of social engineering attacks. It is scalable, requires no physical presence, and can target millions simultaneously.','easy',1,10),

('ceh-domains','Denial of Service',10,'A SYN flood attack exploits which characteristic of the TCP protocol?','The UDP checksum verification','The 3-way handshake — the server allocates resources for each SYN, which is exhausted when the attacker sends massive SYNs without completing the handshake','The ICMP echo protocol','The FTP passive mode','b','SYN flood: attacker sends many SYN packets (often with spoofed IPs). Server allocates memory for each half-open connection. When resources are exhausted, legitimate connections fail.','easy',1,10),

('ceh-domains','Session Hijacking',9,'Session fixation attacks differ from session stealing because:','Fixation steals existing tokens','Fixation forces the victim to use an attacker-chosen session ID before login, so after authentication the attacker already knows the valid token','Fixation requires network access','They are identical','b','Session fixation: attacker sets a known session ID before authentication (via URL parameter or cookie injection). After victim logs in, the attacker uses the same ID to hijack the authenticated session.','easy',1,10),

-- Tier 2 (medium)
('ceh-domains','Evading IDS/Firewalls',12,'Which nmap technique is used to evade firewalls by fragmenting packets?','nmap -sV','nmap -f (fragment packets into 8-byte chunks)','nmap -O','nmap -sU','b','`nmap -f` splits packets into tiny fragments. Some packet-inspection firewalls/IDS cannot reassemble fragments fast enough to analyse them, allowing scans to bypass detection.','medium',2,20),

('ceh-domains','Web Application Hacking',13,'What does the OWASP Top 10 #1 (2021) vulnerability represent?','SQL Injection','Broken Access Control — when users can access resources beyond their authorised permissions','Cross-Site Scripting','Insecure Deserialization','b','Broken Access Control became #1 in 2021, appearing in 94% of tested apps. Includes IDOR, privilege escalation, missing function-level access control. Previous #1 (Injection) dropped to #3.','medium',2,20),

('ceh-domains','SQL Injection',13,'What is the difference between error-based and blind SQL injection?','They are identical','Error-based: database errors reveal information in the response. Blind: no output — attacker infers data from boolean page differences or time delays (SLEEP)','Error-based uses time delays','Blind SQLi only works with MySQL','b','Error-based: `1'' AND EXTRACTVALUE(1,CONCAT(0x7e,(SELECT version())))--` returns error with DB version. Boolean blind: check if page changes with `AND 1=1` vs `AND 1=2`. Time-based: `AND SLEEP(5)`.','medium',2,20),

('ceh-domains','Cryptography',18,'What is the difference between a stream cipher and a block cipher?','Block ciphers are more secure','Stream ciphers encrypt bit-by-bit against a keystream; block ciphers encrypt fixed-size blocks (e.g. 128-bit for AES) using substitution-permutation networks','Stream ciphers use AES','Block ciphers are faster','b','RC4 (now broken) is a stream cipher — fast, suited for real-time. AES (block) used with modes (GCM, CBC). ChaCha20 (modern stream cipher) used in TLS 1.3 for devices without AES hardware acceleration.','medium',2,20),

('ceh-domains','Wireless Security',16,'What vulnerability does WEP have that makes it insecure?','It uses no encryption','It reuses IVs (Initialisation Vectors) leading to keystream reuse, allowing the RC4 key to be recovered from sufficient captured packets','It uses 128-bit encryption only','It requires physical access','b','WEP uses RC4 with a 24-bit IV. The IV space is small enough that IVs repeat. Tools like aircrack-ng collect IVs passively, then statistically recover the key. WEP was deprecated in 2004; WPA3 is current standard.','medium',2,20),

('ceh-domains','Hacking Web Servers',11,'What is a directory traversal attack?','Scanning web server directories','Using `../` sequences in URL parameters to access files outside the web root (e.g. `../../etc/passwd`)','A DDoS attack on web servers','SQL injection via URL parameters','b','Path traversal: if the app constructs file paths from user input without validation, `?file=../../etc/passwd` reads the passwd file. Mitigation: canonicalise paths and validate they are within the allowed directory.','medium',2,20),

('ceh-domains','Cloud Computing',19,'What is the SSRF vulnerability specific to cloud environments?','SSRF does not occur in cloud','Exploiting server-side requests to hit the instance metadata endpoint (169.254.169.254) and steal IAM credentials','A SQL injection in cloud databases','A DDoS targeting cloud APIs','b','AWS metadata at 169.254.169.254 exposes IAM credentials if an EC2 can be tricked into fetching it. Used in Capital One breach. IMDSv2 requires a PUT/token request first, mitigating SSRF.','medium',2,20),

('ceh-domains','IoT Hacking',20,'Which of the following is the most common IoT security vulnerability?','Physical tampering','Default or hardcoded credentials that are never changed, allowing trivial authentication bypass','Insufficient processing power','Lack of display screen','b','Mirai botnet (2016) compromised 600,000+ IoT devices using a list of 61 default credentials. Default credentials are the #1 IoT vulnerability. Remediation: change defaults, device inventory, network segmentation.','medium',2,20),

('ceh-domains','Penetration Testing',20,'What is the correct order of a penetration test engagement?','Exploitation → Reporting → Planning','Planning/Scoping → Reconnaissance → Scanning → Exploitation → Post-exploitation → Reporting','Reporting → Planning → Exploitation','Scanning → Reporting → Post-exploitation','b','Pentest phases: 1) Planning (scope, rules of engagement, legal auth), 2) Reconnaissance, 3) Scanning/enumeration, 4) Exploitation, 5) Post-exploitation (pivot, persist), 6) Reporting with findings and remediation.','medium',2,20),

('ceh-domains','Mobile Hacking',17,'What does jailbreaking (iOS) or rooting (Android) do from a security perspective?','Increases device security','Removes OS-level security restrictions and sandboxing, allowing apps to access the full filesystem and system resources — making the device far more vulnerable to malware and data theft','Only affects app performance','Only relevant for enterprise devices','b','Jailbreaking/rooting: bypasses App Store restrictions, removes sandbox, allows root-level access. Attackers target jailbroken devices knowing security controls are absent. Enterprise MDM can detect and block rooted devices.','medium',2,20),

-- Tier 3 (hard)
('ceh-domains','Advanced Exploitation',6,'What is a heap spray attack and what vulnerability does it typically exploit?','A DDoS against heap memory','Filling the heap with NOP sleds and shellcode at multiple addresses so that a use-after-free or heap overflow vulnerability, when triggered, reliably jumps into attacker-controlled code','A stack overflow technique','A kernel memory allocation attack','b','Heap spray: allocate many objects containing shellcode preceded by NOP sleds. When a dangling pointer is used (UAF) or heap overflow occurs, the corrupted pointer lands in the NOP sled and executes shellcode. Mitigated by ASLR.','hard',3,30),

('ceh-domains','Post-Exploitation',6,'What is Pass-the-Hash (PtH) and how does it differ from Pass-the-Ticket (PtT)?','Both require knowing the plaintext password','PtH uses stolen NTLM hashes to authenticate to Windows services without cracking the hash. PtT uses stolen Kerberos tickets (TGT/TGS) to access services without knowing passwords.','PtT uses NTLM hashes','PtH only works on Linux','b','PtH: use mimikatz to dump NTLM hash → authenticate via SMB/WMI with hash directly (no cracking needed). PtT (Golden/Silver Ticket): forge Kerberos tickets using krbtgt hash (Golden) or service account hash (Silver).','hard',3,30),

('ceh-domains','Advanced Cryptography',18,'What is a golden ticket attack against Kerberos?','A brute force against Kerberos','Forging a TGT using the compromised krbtgt account NTLM hash, granting an attacker persistent access to all resources in the domain — even after password resets — until the krbtgt password is changed twice','A Kerberoasting technique','A silver ticket variant','b','Golden ticket: attacker extracts krbtgt hash (domain controller compromise required) → forges TGT for any user, any lifetime → validates against all KDCs. Mitigation: change krbtgt password twice, monitor for anomalous ticket lifetimes.','hard',3,30),

('ceh-domains','Advanced Scanning',3,'Explain how an attacker uses nmap scripts (NSE) for exploitation, not just scanning.','NSE is read-only','NSE scripts can: exploit known vulnerabilities (nmap --script exploit/), brute-force credentials (ssh-brute, ftp-brute), enumerate sensitive data (http-git, smb-enum-shares), and execute DoS attacks against vulnerable services','NSE only works for version detection','NSE requires root privileges for all scripts','b','NSE library: discovery, auth (brute force), exploit scripts. `nmap -sV --script vuln target` runs all vulnerability checks. `nmap --script smb-vuln-ms17-010` checks for EternalBlue. Some scripts actively exploit; others just identify.','hard',3,30),

('ceh-domains','Advanced Evasion',12,'How do attackers use DNS over HTTPS (DoH) and domain fronting to evade security controls?','These techniques are detectable by all firewalls','DoH: encrypts DNS queries inside HTTPS making them indistinguishable from normal web traffic, bypassing DNS monitoring. Domain fronting: routes traffic through a trusted CDN (Cloudflare, Google) with attacker C2 as the actual destination in the encrypted SNI.','DoH requires special hardware','Domain fronting only works with Tor','b','DoH bypasses DNS inspection. Domain fronting: HTTP Host header = attacker.com, SNI = cloudflare.com → CDN decrypts and forwards to attacker.com. Firewall sees traffic to cloudflare.com (trusted). Cloudflare/Google now block fronting for their infrastructure.','hard',3,30),

('ceh-domains','Advanced Web Hacking',13,'What is HTTP response splitting and how does it enable cache poisoning?','An HTTP protocol error','Injecting CRLF (\\r\\n) sequences into HTTP headers to split a server response into two, allowing an attacker to control the second response and potentially poison caches with malicious content','A TLS vulnerability','A JavaScript injection technique','b','If user input is reflected in a redirect Location header without sanitisation, `%0d%0a%0d%0a<html>...` (CRLF injection) terminates the first response and injects a second. Proxy/CDN caches the injected response. Mitigation: sanitise all input placed in HTTP headers.','hard',3,30),

('ceh-domains','Advanced Wireless',16,'What is KRACK and which Wi-Fi protocol does it affect?','A WEP attack','Key Reinstallation Attack against WPA2 — manipulating the 4-way handshake to force nonce reuse in the encryption cipher, allowing decryption of traffic and potential injection','A WPA3 vulnerability','A wireless DoS attack','b','KRACK (2017, CVE-2017-13077): by retransmitting handshake message 3, attacker forces reinstallation of the encryption key, resetting the nonce. Nonce reuse in TKIP/CCMP allows replay and decryption. Patched by OS vendors; WPA3 uses SAE to prevent.','hard',3,30),

('ceh-domains','Advanced IoT',20,'Explain firmware analysis as an attack technique against IoT devices.','Reading the device documentation','Extracting the firmware binary (via UART, JTAG, or flash chip reading), unpacking with binwalk, and analysing with Ghidra/IDA to find hardcoded credentials, private keys, memory corruption vulnerabilities, and debugging interfaces','A network-based IoT attack','Physical destruction of the device','b','Firmware analysis: `binwalk -e firmware.bin` extracts filesystem → `grep -r password` finds hardcoded creds → Ghidra analysis finds command injection in web interface. UART console often gives root shell for physical testing. Foundational technique for IoT security research.','hard',3,30),

('ceh-domains','Advanced Cloud Hacking',19,'What is IAM privilege escalation in AWS and how does an attacker find escalation paths?','Bypassing cloud encryption','Using legitimately-granted IAM permissions (iam:CreatePolicyVersion, iam:AttachUserPolicy, lambda:InvokeFunction with high-privilege role) to obtain admin access beyond intended permissions — tools like Pacu and enumerate-iam map escalation paths','A DDoS attack against IAM APIs','Stealing root account credentials','b','AWS privesc: if user has iam:CreatePolicyVersion, can add AdministratorAccess version. If has iam:PassRole + lambda:CreateFunction, can create Lambda with high-privilege role → invoke → escalate. Rhino Security published 21 IAM privesc paths.','hard',3,30),

('ceh-domains','Advanced Penetration Testing',20,'What is the difference between a white box, grey box, and black box penetration test?','Only the scope differs','White box: full knowledge (source code, architecture diagrams, credentials). Grey box: partial info (credential, some network diagrams). Black box: no prior knowledge, simulates an external attacker','Black box provides more coverage','Grey box tests are less valuable','b','White box: efficient, deep code review. Black box: realistic attacker simulation but may miss business logic. Grey box: best balance for most engagements. Rules of engagement define which box model and what''s in scope.','hard',3,30);
