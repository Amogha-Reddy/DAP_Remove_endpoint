import paramiko
import os

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

#DAPO_Details
dapo_hostname='100.96.54.171'
dapo_ssh_port='22'
dapo_username='dell'
dapo_password='Sigsaly@123'

#node_details
svc_tag='DRN3R04'

#vars
local="delete_endpoint.sh"
remote="/home/dell/delete_endpoint.sh"
new_cmd= f"bash {remote} {svc_tag}"

try:
    ssh.connect(hostname=dapo_hostname, port=dapo_ssh_port, username=dapo_username, password=dapo_password)
    sftp = ssh.open_sftp()
    sftp.put(local, remote)
    sftp.close()
    stdin, stdout, stderr =ssh.exec_command(new_cmd)
    stdout.channel.recv_exit_status()
except Exception as e:
    print(f"Failed to connect to {dapo_hostname}: {e}")
ssh.close()

