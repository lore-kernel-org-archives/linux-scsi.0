From: Serge Blondin <sblondin@abacom.com>
Subject: aacraid  EXT3 errors
Date: Tue, 04 Oct 2005 17:34:08 -0400
Message-ID: <4342F550.9030908@abacom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic2.abacom.com ([66.129.128.4]:19142 "EHLO mrtg.abacom.com")
	by vger.kernel.org with ESMTP id S964979AbVJDVeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 17:34:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mark_salyzyn@adaptec.com

First some system info

Dual Xeon 2.8ghz
Motherboard Intel SE7320SP2
2 gig DDR ECC
Adaptec 2410sa card firmware 2348
aacraid driver 1.1.5-2391
RedHat Enterprise 3 / w kernel2.4.21-27.ELsmp running Plesk 7.5.4

Executing: container list
Num          Total  Oth Stripe          Scsi   Partition
Label Type   Size   Ctr Size   Usage   C:ID:L Offset:Size
----- ------ ------ --- ------ ------- ------ -------------
 0    RAID-5  698GB      256KB Open    0:00:0 64.0KB: 232GB
 /dev/sda                              0:01:0 64.0KB: 232GB
                                       0:02:0 64.0KB: 232GB
                                       0:03:0 64.0KB: 232GB


Here is the error I got with dmesg

EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory 
#10256387: rec_len % 4 !=
 0 - offset=0, inode=825303089, rec_len=13618, name_len=54


-- 
Serge Blondin
Technicien Informatique
Les Services Internet Abacom
sblondin@abacom.com
tel: (819) 820-2929 ext226
fax: (819) 820-8866

