# Gestione server in produzione con Ansible
## Directory Layout

```
.
├── hosts
├── mysqlserver.yml
├── Readme.md
├── roles
│   ├── common
│   │   ├── files
│   │   ├── handlers
│   │   └── tasks
│   ├── mysqlserver
│   │   ├── files
│   │   ├── handlers
│   │   └── tasks
│   └── webserver
│       ├── files
│       ├── handlers
│       └── tasks
└── webserver.yml

```

## Test
Esegue un ping a tutte le macchine dell'inventory hosts e controlla che le chiavi siano ok

`ansible -i hosts all -m ping`

## Esecuzione del playbook
```
ansible-playbook webserver.yml -i hosts Configura un server in questo caso web 
ansible-playbook mysqlserver.yml -i hosts Configura un server in questo caso mysql
```