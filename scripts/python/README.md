# Python

Stuff that I can do in Python.

## bin.py

A script that returns a CIDR range for a given CIDR block. Useful for calculating network CIDRs for k8s clusters.

Usage:
```bash
python3 bin.py 10.240.0.0/21
```

Output:
```bash
CIDR > 21 : 10.240.0.0 - 10.240.7.255
```

Please note - no error handling was added.
The script also demonstrates the use of recursion to translate binary to decimal and vice versa.

