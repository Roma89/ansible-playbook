# Deploy progetto symfony + importazione database in locale
## Directory Layout

```
├── deploy.yml
├── hosts
├── import_remote_db.yml
├── Readme.md
└── roles
    ├── deploy
    │   ├── defaults
    │   ├── tasks
    │   ├── templates
    │   └── vars
    └── import_remote_db
        ├── local.yml
        ├── remote.yml
        └── roles

```
## Esecuzione del playbook
```
ansible-playbook -l serverweb01 -i Resources/ansible/hosts Resources/ansible/deploy.yml -v -e 'app_remote_env=dist'
ansible-playbook -l serverdemo -i Resources/ansible/hosts Resources/ansible/deploy.yml -v -e 'app_remote_env=demo'
ansible-playbook -l serverdemo -i Resources/ansible/hosts Resources/ansible/deploy.yml -v -e 'app_remote_env=dev'
```


