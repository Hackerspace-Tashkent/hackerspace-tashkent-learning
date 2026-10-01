# Lesson 8. Networking

A server is just a program that listens on a port. Once you can start one and talk to it, the network stops being magic.

## Addresses and ports

```bash
ip addr              # addresses of every interface
ip route             # where the traffic goes
hostname -I          # your own address
ss -tlnp             # who is listening on ports
```

`127.0.0.1` is `localhost` — you talking to yourself. A port is a number from 1 to 65535 that picks one program among the ones listening.

## Starting a server

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

Pick a port above 1024 — those below need root. `--bind 127.0.0.1` keeps it reachable only from the same machine, which is the safe default.

## Talking to a server

```bash
curl -I http://127.0.0.1:8000     # headers only
curl -s http://127.0.0.1:8000 | head    # first lines
curl -o page.html http://127.0.0.1:8000 # save to a file
echo $?                                # code: 0 — reachable
```

- `200` OK
- `301` or `302` moved
- `404` not found
- `403` forbidden
- `000` connection failed

## Names instead of addresses

A host is a name that points to an address. `/etc/hosts` is the small local list, checked before DNS is asked.

```bash
echo "127.0.0.1  mysite.local" | sudo tee -a /etc/hosts
curl -I http://mysite.local:8000
```

## If `ip` and `ss` are not found

The commands `ip` and `ss` live in the `iproute2` package. Some Codespaces
builds do not have it, and you will see:

```bash
ip: command not found
```

That is not a broken lesson. There is a way around it:

```bash
hostname -I          # your own address — always present
cat /proc/net/tcp    # open ports — also always present
```

Reading `/proc/net/tcp` is harder than reading `ss`, so the exercise stays
with `hostname -I`. To install the missing piece:

```bash
sudo apt-get install -y iproute2
```

## Practice

1. Create the directory `lab-work` and put a file `index.html` with any text inside it.
2. Write `serve.sh` that starts `python3 -m http.server` on port 8000 in the background and writes the PID into `server.pid`.
3. Run it, then save the answer code into `status.txt`: `curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8000 > status.txt`.
4. Confirm the port appears in the output of `ss -tlnp` (or `netstat -tlnp`) and save that line into `ports.txt`.
5. Write `check_site.sh`: it curls a given port and exits 0 only when the status is 200, and exits 1 otherwise. It must give 1 for a wrong port.
6. Stop the server with `kill` using the PID from `server.pid` and confirm nothing listens on 8000 any more.

```bash
cd labs/level-1/04-networking
./check.sh
```
