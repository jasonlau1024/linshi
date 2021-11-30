# Kubernetes kubeadm 高可用集群自动部署
### 安装条件
```
环境： Centos 7.x, ansible2
适用k8s版本: v1.16.x,v1.17.x,v1.18.x
可以使用下列项目一键部署ansible堡垒机
https://gitee.com/hulu20/ansible-bastion
```

### 1、下载所需文件

下载Ansible部署文件：

```
# git clone https://gitee.com/hulu20/ansible-k8s-kubeadm.git
# cd ansible-k8s-kubeadm
```

NIC Calico 自定义
```
# -- 新k8s版本可能需要更新, v1.18.4 以下版本不用更新此项
# -- https://docs.projectcalico.org/getting-started/kubernetes/quickstart
# -- 修改custom-resources网段与group_vars/all.yml 中 pod_cidr 一致 
# wget https://docs.projectcalico.org/manifests/tigera-operator.yaml -O roles/master/files/tigera-operator.yaml
# wget https://docs.projectcalico.org/manifests/custom-resources.yaml -O roles/master/files/custom-resources.yaml
---
    ipPools:
    - blockSize: 26
      cidr: 10.10.0.0/16  #new add
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()
---
```

Dashboard 地址, v1.17.x 版本不需要更改
```
# -- 选择与k8s对应版本下载，并添加nodeport选项
# -- https://github.com/kubernetes/dashboard/releases
# wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc7/aio/deploy/recommended.yaml -O roles/addons/files/kubernetes-dashboard.yaml
---
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort  #new add
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30001   #new add
  selector:
    k8s-app: kubernetes-dashboard
---
# -- 获取令牌信息
# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') |grep '^token' |awk '{print $2}'
```


### 2、修改Ansible文件

2.1 修改hosts文件，根据规划修改对应IP和名称
```
# vi hosts.ini
...
```

2.2 修改group_vars/all.yml文件, 修改k8s版本等信息
```
# vim group_vars/all.yml
...
```
## 3、一键部署

### 部署命令
测试ansible是否能连接服务器, 显示root权限即可

```
# ansible -i hosts.ini all -m shell -a "whoami"

# 如果ansible配置有问题，可以使用此项目一键部署ansible堡垒机 
# https://gitee.com/hulu20/ansible-bastion
```

单Master版：
```
# ansible-playbook -i hosts.ini single-master-deploy.yml
```

多Master-HA 版：
```
# ansible-playbook -i hosts.ini multi-master-ha-deploy.yml
```

多Master-LVS 版：
```
# ansible-playbook -i hosts.ini multi-master-lvs-deploy.yml
```

## 4、部署控制
如果安装某个阶段失败，可针对性测试.

例如：只运行部署插件
```
# ansible-playbook -i hosts.ini single-master-deploy.yml -t master,node
```

## 5、节点扩容
5.1 修改hosts，添加新节点ip到[newnode]标签
```
# vim hosts.ini
[all]
node02 ansible_host=192.168.80.35 ip=192.168.80.35 ansible_port=43999 ansible_user=yunwei

[node]
node02

[newnode]
node02
...
```

5.2 执行部署
```
ansible-playbook -i hosts.ini add-node.yml
```

## 6、移除k8s集群
```
ansible-playbook -i hosts.ini remove-k8s.yml
```