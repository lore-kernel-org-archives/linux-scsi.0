From: Alex <devel@qnet.ro>
Subject: HOT SWAP feature is not working! Help!
Date: Tue, 24 Sep 2002 15:20:06 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209241520.06841.devel@qnet.ro>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.masini.ro ([172.16.34.250])
	by ns.crescendo.ro (8.11.2/8.11.2) with ESMTP id g8OCEjP27711
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2002 15:14:45 +0300
Received: from rudolf (scalex.qnet.ro [172.16.31.37])
	by mail.masini.ro (8.12.2/8.12.2) with ESMTP id g8OC1w4Z010421
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2002 15:01:58 +0300
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello linux experts,

I hope if i come to the right place

I have a HP 4100 server with LSI 53c1010R SCSI controller. I use 
RedHat7.3 os with default kernel 2.4.18-3. Also i have 3 scsi drives 
36G Ultra3 firmware HP. All thins are ok till here.

I need some help to test HOT SWAP feature for this drives. I read some 
documentation and i saw that HOT SWAP may work on linux if my driver for 
scsi-controller support re-scanning the bus!

[snip]
Normal SCSI hardware is not hot-swappable either. It may however work. 
If your SCSI driver supports re-scanning the bus, and removing and 
appending devices, you may be able to hot-swap devices.
[snip]

I try to check if this feature works for me and don`t. If i remove any 
scsi drive, this device remain in /proc until will be removed manually, 
or using a script named rescan-scsi-bus.sh which i found it on google.

I tried to obtain some additional info and i saw that for my 
scsi-controller has 2 active drivers: one older named sym53cxx.o and 
one newer named sym53cxx_2.o!
I don`t have for the moment access to this computer but i remember that 
on default installation, redhat assigned the old driver to my 
scsi-controller.

I want to know if i change the driver with this new one, i can use the 
HOT SWAP feature!

Are necessary additional settings to be made when i load the new driver 
or on the system configuration?

Any success story will be appreciated.

Regards,

Alex

