+++
date = "2016-11-08T18:35:06+09:00"
title = "ansibleでEC2インスタンスを作成する"
slug = "how-to-create-ec2-instance-use-ansible"
tagx = ["ansible", "aws"]
+++

やったこと
==========

ansibleを使って、aws ec2インスタンスを作成する。

実行環境
========

* Mac OS X El Capitan 10.11.6
* python 2.7.12
* ansible 2.2.0.0
* boto 2.43.0

事前に必要なこと、及び必要なツール
==================

* aws上のVPCの構築
* IAMユーザ、及びアクセスキー・シークレットキーの入手
* [pyenv](https://github.com/yyuu/pyenv)
* [direnv](https://github.com/direnv/direnv)

ディレクトリ構成
================

```
.
├── .envrc
├── .python-version
├── hosts
│   └── development
│       ├── ec2.ini
│       ├── ec2.py
│       ├── inventry
│       └── group_vars
│           └── all.yml
├── roles
│   └── ec2
│       └── tasks
│           ├── instance.yml
│           ├── keypair.yml
│           ├── main.yml
│           └── security_group.yml
└── ec2.yml(プレイブック)
```

direnv
======

適用なディレクトリを作って、下記を実行し、環境変数にAWSのAPI用の接続情報を設定する。

    $ (
    echo 'export AWS_ACCESS_KEY_ID=<アクセスキー>'
    echo 'export AWS_SECRET_ACCESS_KEY=<シークレットキー>'
    ) > .envrc
    $ direnv allow


python
======

pyenv使ってpythonのインストール、2.7系ならなんでも良い。

    $ pyenv install 2.7.12

上記で作ったディレクトリに移動した時に、特定のpython環境を使うように設定する。

    $ pyenv virtualenv 2.7.12 example_cm_py_27_12
    $ echo 'example_cm_py_27_12' > .python-version

boto と ansibleをインストールする。

    $ pip install boto==2.43.0
    $ pip install ansible==2.2.0.0


EC2用のdynamic inventory ファイルを入手する
===========================================

「[Example: AWS EC2 External Inventory Script](http://docs.ansible.com/ansible/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script)」から[ec2.py](https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py)と[ec2.ini](https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini)を入手して、「hosts/development」配下に配置する。

「ec2.py」には、実行権限を付与する。

プレイブックを作成する
======================

「ec2.yml」というファイル名でプレイブックを作成する。※ファイル名はなんでも良い。

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: False
  roles:
    - role: ec2

- hosts: launched_{group_name}
  remote_user: ec2-user
  gather_facts: no
```


イベントリファイルを作成する
============================

「hosts/development」配下に「inventry」というファイルを作成する。

```
[localhost]
localhost ansible_python_interpreter=~/.pyenv/shims/python
```

イベントリ用の変数定義を行うために、「hosts/development/group_vars」というディレクトリを作成し、「hosts/development/group_vars/all.yml」に下記の変数定義を行う。

```
aws:
  # key pair to use on the instance
  keypair_name: example_development
  # security group name, and instance tag name.
  group_name: example_development
  # リージョン
  region: ap-northeast-1
  # Amazon linux の最新のディスクイメージ
  ec2_image: ami-cbf90ecb
  # EC2 のインスタンスタイプ
  ec2_instance_type: t2.micro
```

EC2ロールの作成
===============

roles/ec2/tasks/main.yml

```
---
- include: keypair.yml
- include: security_group.yml
- include: instance.yml
```

roles/ec2/tasks/kyepair.yml

```
---
- name: Create EC2 keypair.
  ec2_key:
    # Name of the key pair.
    name: "{{ aws.keypair_name }}"
    # The AWS region to use.
    region: "{{ aws.region }}"
  register: ec2_keypair

- name: Create keypair file.
  file:
    path=~/.ssh/{{ ec2_keypair.key.name }}.pem
    state=touch
    mode=0600
  when: ec2_keypair.key.private_key is defined

- name: Write keypair to file.
  local_action: shell echo "{{ ec2_keypair.key.private_key }}" > ~/.ssh/{{ ec2_keypair.key.name }}.pem
  when: ec2_keypair.key.private_key is defined
```

roles/ec2/tasks/security_group.yml

```
---
- name: Create EC2 Security Group.
  ec2_group:
    # Name of the security group.
    name: "{{ aws.group_name }}"
    # Description of the security group.
    description: "{{ aws.group_name }} server security group"
    # The AWS region to use.
    region: "{{ aws.region }}"

    # Inbound.
    rules:
      - proto: tcp
        from_port: 80
        to_port: 80
        cidr_ip: 0.0.0.0/0
      - proto: tcp
        from_port: 443
        to_port: 443
        cidr_ip: 0.0.0.0/0
      - proto: tcp
        from_port: 22
        to_port: 22
        cidr_ip: 0.0.0.0/0
      - proto: icmp
        from_port: -1 # icmp type, -1 = any type
        to_port: -1 # icmp subtype, -1 = any subtype
        cidr_ip: 10.0.0.0/0

    # Outbound.
    rules_egress:
      - proto: all
        from_port: 0
        to_port: 65535
        cidr_ip: 0.0.0.0/0
```

roles/ec2/tasks/instance.yml

```
---
- name: Create EC2 instance.
  ec2:
    # ami ID to use for the instance.
    image: "{{ aws.ec2_image }}"
    # instance type to use for the instance.
    instance_type: "{{ aws.ec2_instance_type }}"
    # The AWS region to use.
    region: "{{ aws.region }}"
    # key pair to use on the instance
    key_name: "{{ aws.keypair_name }}"
    # security group (or list of groups) to use with the instance.
    group: "{{ aws.group_name }}"
    instance_tags:
      Name: "{{ aws.group_name }}"
    wait: yes
    wait_timeout: 300
  register: ec2

- name: Add new instance to host group
  add_host: hostname={{ item.public_ip }} groupname="launched_{{aws.group_name}}"
  with_items: '{{ec2.instances}}'

- name: Wait for SSH to come up
  wait_for: host={{ item.public_dns_name }} port=22 delay=60 timeout=320 state=started
  with_items: '{{ec2.instances}}'
```

実行
====

    $ ansible-playbook -i hosts/development ec2.yml

参考にしたサイト
================

* [ec2 - create, terminate, start or stop an instance in ec2](http://docs.ansible.com/ansible/ec2_module.html)
* [ec2_group - maintain an ec2 VPC security group.](http://docs.ansible.com/ansible/ec2_group_module.html)
* [ec2_key - maintain an ec2 key pair.](http://docs.ansible.com/ansible/ec2_key_module.html)
