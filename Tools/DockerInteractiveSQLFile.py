#! /usr/bin/env python3

import sys
import json
import os
import subprocess
import random
import signal
import time

print("[*] Powered by @Manesec")

def is_root():
    """Check if the script is running as root"""
    return os.geteuid() == 0

def check_docker_exists():
    """Check if docker command exists"""
    try:
        subprocess.run(['docker', '--version'], capture_output=True, check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def is_docker_running():
    """Check if docker service is running"""
    try:
        result = subprocess.run(['systemctl', 'is-active', 'docker'],
                              capture_output=True, text=True)
        return result.stdout.strip() == 'active'
    except subprocess.CalledProcessError:
        return False

def start_docker():
    """Start docker service using systemctl"""
    try:
        subprocess.run(['systemctl', 'start', 'docker'], check=True)
        # Wait a few seconds for docker to fully start
        time.sleep(3)
        return True
    except subprocess.CalledProcessError:
        return False

def is_port_in_use(port):
    """Check if a port is in use"""
    result = subprocess.run(['netstat', '-tuln'], capture_output=True, text=True)
    return f':{port}' in result.stdout

def get_random_port():
    """Get a random available port"""
    while True:
        port = random.randint(1024, 65535)
        if not is_port_in_use(port):
            return port

def run_docker(port, file):
    """Run docker container with the specified port"""
    docker_cmd = [
        'docker', 'run',
        '-p', f'{port}:3306',
        '-e', 'MYSQL_ROOT_PASSWORD=manesec',
        '-v', file + ":/docker-entrypoint-initdb.d/init.sql",
        '--rm',
        '-d', 'mysql:latest'
    ]
    print("[$] " + " ".join(docker_cmd))
    process = subprocess.Popen(docker_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    container_id = process.stdout.read().decode().strip()
    return container_id

def stop_docker(container_id):
    """Stop and remove the docker container"""
    print("[*] Stopping ...")
    subprocess.run(['docker', 'stop', container_id], capture_output=True)
    subprocess.run(['docker', 'rm', container_id], capture_output=True)

def signal_handler(sig, frame):
    """Handle Ctrl+C signal"""
    global container_id
    if container_id:
        print("\n [*] Stopping Docker container...")
        stop_docker(container_id)
    sys.exit(0)

# Main execution
if __name__ == "__main__":
    # 1. Check if file argument is provided
    if len(sys.argv) < 2:
        print("Error: Please provide a SQL file. Usage: python run.py <file.sql>")
        sys.exit(1)

    sql_file = os.path.abspath(sys.argv[1])
    if not os.path.isfile(sql_file):
        print(f"Error: File {sql_file} does not exist")
        sys.exit(1)


    os.system("unix2dos " + sql_file)

    # 2. Check if running as root
    if not is_root():
        print("Error: This script must be run as root")
        sys.exit(1)

    # 3. Check if docker exists
    if not check_docker_exists():
        print("Error: Docker is not installed or not accessible")
        sys.exit(1)

    if not is_docker_running():
        print("[!] Docker service is not running. Attempting to start it...")
        if start_docker():
            print("[!] Docker service started successfully")
        else:
            print("Error: Failed to start Docker service")
            sys.exit(1)
    else:
        print("Docker service is already running")

    # 4. Get random available port
    random_port = get_random_port()
    print(f"[*] Using random port: {random_port}")
    print(f"    - First time till need to wait for download mysql image.")

    # 5. Run docker and handle Ctrl+C
    container_id = None
    try:
        # Register signal handler for Ctrl+C
        signal.signal(signal.SIGINT, signal_handler)

        # Start docker container
        container_id = run_docker(random_port, sql_file)
        print(f"[*] Docker container started with ID: {container_id}")
        print("[!] Connection credit = root : manesec")
        print("[*] Press Ctrl+C to stop the container")

        # Keep script running until Ctrl+C
        while True:
            docker_cmd = ['docker', 'inspect', container_id]
            process = subprocess.Popen(docker_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            output = process.stdout.read().decode().strip()
            if (json.loads(output) == []):
                print("[!] Docker container was stopped.")
                sys.exit(1)

            time.sleep(3)

    except Exception as e:
        print(f"An error occurred: {e}")
        if container_id:
            stop_docker(container_id)
        sys.exit(1)
