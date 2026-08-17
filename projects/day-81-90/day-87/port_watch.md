# `port_watch.sh` — Live Port Watcher

## Objective

Create a Bash script that continuously monitors the system for **new TCP or UDP listening ports**.

The script:

- Captures the current listening ports.
- Stores a previous snapshot.
- Compares the current state with the previous state.
- Reports only newly opened listeners.
- Displays the detection time.
- Shows protocol, local address, and process information.
- Cleans up temporary files when stopped.

---

## Source Code

Save the following script as `port_watch.sh`:

```bash
#!/usr/bin/env bash

# port_watch.sh
# Detect newly opened listening ports in real time.

INTERVAL=2

OLD=$(mktemp)
NEW=$(mktemp)

cleanup() {
    rm -f "$OLD" "$NEW"
}

trap cleanup EXIT INT TERM

get_ports() {
    ss -lntupH 2>/dev/null |
    awk '{
        proto=$1
        addr=$5
        process=$7

        if (process == "")
            process="unknown"

        print proto, addr, process
    }' |
    sort -u
}

echo "======================================"
echo "      LIVE PORT WATCHER"
echo "======================================"
echo "Watching for new listening ports..."
echo "Press Ctrl+C to stop."
echo

get_ports > "$OLD"

while true; do
    sleep "$INTERVAL"

    get_ports > "$NEW"

    comm -13 "$OLD" "$NEW" |
    while read -r line; do
        echo "NEW LISTENER DETECTED"
        echo "Time : $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Info : $line"
        echo "--------------------------------------"
    done

    cp "$NEW" "$OLD"
done
```

---

## Make the Script Executable

```bash
chmod +x port_watch.sh
```

---

## Run the Script

Process information may require elevated privileges:

```bash
sudo ./port_watch.sh
```

---

## Test It

Open another terminal and start a temporary HTTP server:

```bash
python3 -m http.server 8080
```

The script should detect the newly opened listener.

Example:

```text
NEW LISTENER DETECTED
Time : 2026-08-17 22:18:42
Info : tcp 0.0.0.0:8080 users:(("python3",pid=8241,fd=3))
--------------------------------------
```

Stop the HTTP server with:

```text
Ctrl+C
```

---

## How It Works

### 1. Monitoring Interval

```bash
INTERVAL=2
```

The script checks the listening-port state every two seconds.

---

### 2. Temporary Snapshot Files

```bash
OLD=$(mktemp)
NEW=$(mktemp)
```

Two temporary files are created:

- `OLD` stores the previous snapshot.
- `NEW` stores the latest snapshot.

This allows the script to compare the system state over time.

---

### 3. Cleanup Handler

```bash
cleanup() {
    rm -f "$OLD" "$NEW"
}
```

Temporary files are removed when the script exits.

The cleanup function is registered using:

```bash
trap cleanup EXIT INT TERM
```

This means cleanup occurs on:

- Normal exit
- `Ctrl+C`
- Termination signal

---

## Listening Port Collection

The main collection command is:

```bash
ss -lntupH
```

### Options

| Option | Meaning |
|---|---|
| `-l` | Show listening sockets |
| `-n` | Do not resolve service names |
| `-t` | Show TCP sockets |
| `-u` | Show UDP sockets |
| `-p` | Show process information |
| `-H` | Hide the header |

---

## Extracting Important Fields

The output is passed to `awk`:

```bash
awk '{
    proto=$1
    addr=$5
    process=$7

    if (process == "")
        process="unknown"

    print proto, addr, process
}'
```

The script keeps:

- Protocol
- Listening address and port
- Associated process information

Example:

```text
tcp 0.0.0.0:8080 users:(("python3",pid=8241,fd=3))
```

---

## Removing Duplicate Entries

```bash
sort -u
```

This:

- Sorts the snapshot.
- Removes duplicate lines.

Sorting is also required for reliable use of `comm`.

---

## Initial Snapshot

Before monitoring starts:

```bash
get_ports > "$OLD"
```

The script records all currently active listeners.

These are treated as the baseline.

---

## Detecting New Listeners

Every two seconds:

```bash
get_ports > "$NEW"
```

The current state is compared against the previous state using:

```bash
comm -13 "$OLD" "$NEW"
```

### `comm` Behavior

`comm` compares two sorted files.

It normally produces three columns:

1. Lines unique to the first file
2. Lines unique to the second file
3. Lines present in both

The options:

```text
-1
```

hide entries unique to the old snapshot.

```text
-3
```

hide entries common to both snapshots.

Therefore:

```bash
comm -13 "$OLD" "$NEW"
```

shows only entries that exist in the **new snapshot but not the old snapshot**.

These represent newly opened listeners.

---

## Updating the Baseline

After each comparison:

```bash
cp "$NEW" "$OLD"
```

The latest state becomes the baseline for the next monitoring cycle.

The process becomes:

```text
Snapshot A
    ↓
Wait 2 seconds
    ↓
Snapshot B
    ↓
Compare A → B
    ↓
Report new listeners
    ↓
B becomes new baseline
    ↓
Repeat
```

---

## Main Commands Used

| Command | Purpose |
|---|---|
| `ss` | Displays network sockets |
| `awk` | Extracts useful fields |
| `sort -u` | Sorts and removes duplicates |
| `comm` | Compares previous and current snapshots |
| `mktemp` | Creates temporary files |
| `trap` | Runs cleanup when the script exits |
| `date` | Adds detection timestamps |
| `cp` | Updates the previous snapshot |
| `sleep` | Controls monitoring frequency |

---

## Security Use Case

A listening port represents a service waiting for incoming connections.

If an unexpected process suddenly starts listening on a port, it may indicate:

- A newly started legitimate service.
- A development server.
- A misconfigured application.
- Malware opening a backdoor.
- A reverse-shell listener.
- An unauthorized service.
- A persistence mechanism.
- A newly exposed management interface.

This script provides a lightweight way to notice those changes.

---

## Simple Monitoring Flow

```text
System Listening Ports
        ↓
ss -lntup
        ↓
Normalize Output
        ↓
Save Snapshot
        ↓
Wait
        ↓
Capture New Snapshot
        ↓
comm -13 OLD NEW
        ↓
New Listener?
     /      \
   No        Yes
   ↓          ↓
Repeat     Generate Alert
```

---

## Possible Improvements

The script can later be extended to:

- Write alerts to a log file.
- Detect closed ports as well as new ports.
- Record usernames and process IDs.
- Calculate hashes of listening executables.
- Send email or webhook notifications.
- Query process reputation services.
- Track the parent process.
- Maintain a historical event log.
- Compare against an approved-port allowlist.
- Trigger firewall rules after manual approval.

---

## Example Logging Extension

To save detections to a file:

```bash
LOG_FILE="port_watch.log"
```

Then inside the detection loop:

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S') $line" >> "$LOG_FILE"
```

---

## Important Notes

- Running with `sudo` provides better visibility into process information.
- This script only reports **new listeners** compared with the immediately previous snapshot.
- It does not automatically block or terminate processes.
- Automatic firewall blocking should not be added without careful validation because legitimate services could be disrupted.

---

## Interview Explanation

A concise explanation:

> This script acts as a lightweight host network monitor. It periodically captures listening TCP and UDP sockets using `ss`, normalizes and sorts the output, then compares the current snapshot with the previous one using `comm`. Any line present only in the new snapshot represents a newly opened listening socket, which is reported with a timestamp and associated process information.

It demonstrates Bash concepts such as:

- Functions
- Infinite monitoring loops
- Process inspection
- Temporary files
- Signal handling
- Pipelines
- Text processing
- State comparison
- Basic security monitoring
