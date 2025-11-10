#!/bin/bash
svc_tag=$1
DAPO_psql_pass=$(sudo kubectl -n dapo get secret postgres-secret -o jsonpath="{.data.hzp_inventory-password}" | base64 --decode)
hzp_inventory_ip=$(sudo kubectl -n dapo get po postgres-0 -o wide | awk 'NR==2{print $6}')
DAPP_psql_pass=$(sudo kubectl -n dapp get secret postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode)
echo "Connecting to PostgreSQL at $hzp_inventory_ip with user hzp_inventory..."
echo $svc_tag
sudo kubectl exec -i -n dapo postgres-0 -- /bin/sh -c "PGPASSWORD='${DAPO_psql_pass}' psql -U hzp_inventory -h ${hzp_inventory_ip}  -c \"DELETE FROM endpoint WHERE external_id='${svc_tag}';\""

sudo kubectl exec -i -n dapp postgresql-0 -- sh -c "PGPASSWORD='${DAPP_psql_pass}' psql -U postgres -d dsp_portal_infra_svc  -c \"delete from infra where name='${svc_tag}';\""

