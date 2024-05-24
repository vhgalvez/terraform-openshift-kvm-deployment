
[victory@server system-connections]$ sudo nmcli connection show
NAME                   UUID                                  TYPE      DEVICE
enp4s0f0               f24a4c04-2094-4617-8e1d-62a429a53b5f  ethernet  enp4s0f0
br0                    0b0d401a-55c3-433c-a081-261d6204d89f  bridge    br0
enp3s0f1               8a98ecd0-be84-4f60-9119-cf921e6c26f2  ethernet  enp3s0f1
enp4s0f1               5f22d25b-6f79-4be7-b25a-94f1de0eb1aa  ethernet  enp4s0f1
bridge-slave-enp3s0f0  b303ba1d-efce-49f1-a66a-bc091c68829c  ethernet  enp3s0f0
lo                     e84ab0a7-c033-481f-80af-5e262b225f2c  loopback  lo
virbr0                 a3838bb6-89b0-4af2-8463-fd35092696ec  bridge    virbr0
virbr1                 bd03546f-8507-44b8-90f6-0a5d37267e88  bridge    virbr1
vnet0                  bbf02091-cf63-405d-8069-244d5040256b  tun       vnet0
vnet1                  28389c9b-27e3-4f05-8282-c9e0598c3a15  tun       vnet1
vnet10                 b53b3b08-ae81-455f-a6a0-dc78be26dfa9  tun       vnet10
vnet2                  933cb80b-7439-401d-a0b0-a2bfb124c4bf  tun       vnet2
vnet3                  bc4f33d2-023c-465b-8a0e-1d28a6d9f8a3  tun       vnet3
vnet4                  5b479c28-59c8-4a26-9156-bc841f9deb47  tun       vnet4
vnet5                  11990604-bc6c-49ed-b55d-2d72e473356b  tun       vnet5
vnet6                  18d83168-0190-4859-ba5a-837d0fd4d2c9  tun       vnet6
vnet7                  01aea58c-0b8d-4fa7-ad93-0e31b77f165b  tun       vnet7
vnet8                  52555e82-e248-46a8-a902-973f9d4a2e8b  tun       vnet8
vnet9                  5b4d7f94-52d1-491d-a480-d42aa6db75a4  tun       vnet9
enp3s0f0               a2e3a36a-7367-4e83-892e-8bbb06258164  ethernet  --
[victory@server system-connections]$


[victory@server ~]$ ip route show
default via 192.168.0.1 dev enp4s0f0 proto dhcp src 192.168.0.18 metric 100
default via 192.168.0.1 dev enp4s0f1 proto dhcp src 192.168.0.35 metric 101
default via 192.168.0.1 dev enp3s0f1 proto dhcp src 192.168.0.52 metric 103
default via 192.168.0.1 dev br0 proto dhcp src 192.168.0.42 metric 425
10.17.3.0/24 dev virbr0 proto kernel scope link src 10.17.3.1
10.17.4.0/24 dev virbr1 proto kernel scope link src 10.17.4.1
192.168.0.0/24 dev enp4s0f0 proto kernel scope link src 192.168.0.18 metric 100
192.168.0.0/24 dev enp4s0f1 proto kernel scope link src 192.168.0.35 metric 101
192.168.0.0/24 dev enp3s0f1 proto kernel scope link src 192.168.0.52 metric 103
192.168.0.0/24 dev br0 proto kernel scope link src 192.168.0.42 metric 425
[victory@server ~]$