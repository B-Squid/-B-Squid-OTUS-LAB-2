Перенос системы на RAID1 (#спасибо третьей домашке)

xfsdump -J - /dev/sda1 | xfsrestore -J - /mnt/nr                              # создадим структуру в новой т. монтирования

for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/nr$i; done

chroot /mnt/nr

vi /etc/fstab                                                                 #правим корень. UUID берем из вывода blkid, убираем монтирование раздела на md0
UUUID=f7f28770-5264-4c51-a42c-7eda284a9124 /                       xfs     defaults        0 0
/swapfile none swap defaults 0 0

cd /boot

for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;s/.img//g"` --force; done

vi /etc/default/grub #добавим в GRUB_CMDLINE_LINUX параметр rd.md.uuid=(UUID из /etc/mdadm/mdadm.conf)

grub2-mkconfig -o /boot/grub2/grub.cfg

===========================================================================================
ИТОГ

Вывод lsblk на системе в исходном состоянии:
[root@lab2 ~]# lsblk
NAME      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda         8:0    0   41G  0 disk  
└─sda1      8:1    0   40G  0 part  /
sdb         8:16   0  4.4G  0 disk  
├─sdb1      8:17   0  4.4G  0 part  
└─md0       9:0    0  4.4G  0 raid1 
  └─md0p1 259:0    0  4.4G  0 md    /mnt/nr
sdc         8:32   0  4.4G  0 disk  
├─sdc1      8:33   0  4.4G  0 part  
└─md0       9:0    0  4.4G  0 raid1 
  └─md0p1 259:0    0  4.4G  0 md    /mnt/nr

Вывод lsblk на системе c / на RAID1
[root@lab2 ~]# lsblk
NAME      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda         8:0    0   41G  0 disk  
└─sda1      8:1    0   40G  0 part  
sdb         8:16   0  4.4G  0 disk  
└─md0       9:0    0  4.4G  0 raid1 
  └─md0p1 259:0    0  4.4G  0 md    /
sdc         8:32   0  4.4G  0 disk  
└─md0       9:0    0  4.4G  0 raid1 
  └─md0p1 259:0    0  4.4G  0 md    /
