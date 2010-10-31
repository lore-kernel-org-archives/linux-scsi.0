From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Sun, 31 Oct 2010 09:11:45 -0600
Message-ID: <201010310911.45738.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomasu.net ([64.85.170.234]:40933 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab0JaPLv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Oct 2010 11:11:51 -0400
In-Reply-To: <201010290650.32892.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

On October 29, 2010, Thomas Fjellstrom wrote:
> Good news and bad news, the current mvsas driver in 2.6.36 seems to work
> better than older kernels with my setup (2 port sas + 5 SATA disks). But I
> gotten the following messages so far:
> 
> [  213.856050] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
> mvi=ffff880123200000 task=ffff880122545a40 slot=ffff880123226628
> slot_idx=x3 [  213.856064] drivers/scsi/mvsas/mv_sas.c
> 1632:mvs_query_task:rc= 5 [  213.856094] drivers/scsi/mvsas/mv_sas.c
> 2083:port 0 ctrl sts=0x89800. [  213.856100] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 0 irq sts = 0x1001 [  213.856111] drivers/scsi/mvsas/mv_sas.c
> 2111:phy0 Unplug Notice [  213.866069] drivers/scsi/mvsas/mv_sas.c
> 2083:port 0 ctrl sts=0x199800. [  213.866078] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 0 irq sts = 0x1081 [  213.887617] drivers/scsi/mvsas/mv_sas.c
> 2083:port 0 ctrl sts=0x199800. [  213.887625] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 0 irq sts = 0x10000 [  213.887632] drivers/scsi/mvsas/mv_sas.c
> 2138:notify plug in on phy[0] [  213.991191] drivers/scsi/mvsas/mv_sas.c
> 1224:port 0 attach dev info is 0 [  213.991191]
> drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 0 [ 
> 213.995701] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
> [  216.064032] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
> device[0]:rc= 0 [  216.064049] ata9: translated ATA stat/err 0x01/04 to
> SCSI SK/ASC/ASCQ 0xb/00/00 [  216.064647] ata9.00: device reported invalid
> CHS sector 0
> [  216.065226] ata9: status=0x01 { Error }
> [  216.065815] ata9: error=0x04 { DriveStatusError }
> [ 1519.840061] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
> mvi=ffff880123200000 task=ffff88011f944700 slot=ffff880123226680
> slot_idx=x4 [ 1519.840075] drivers/scsi/mvsas/mv_sas.c
> 1632:mvs_query_task:rc= 5 [ 1519.840107] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x89800. [ 1519.840113] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x1001 [ 1519.840124] drivers/scsi/mvsas/mv_sas.c
> 2111:phy3 Unplug Notice [ 1519.850080] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x199800. [ 1519.850086] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x1081 [ 1519.854247] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x199800. [ 1519.854250] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x10000 [ 1519.854252] drivers/scsi/mvsas/mv_sas.c
> 2138:notify plug in on phy[3] [ 1519.951698] drivers/scsi/mvsas/mv_sas.c
> 1224:port 3 attach dev info is 2000000 [ 1519.951698]
> drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas addr is 3 [
> 1519.963251] drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
> [ 1522.048039] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
> device[3]:rc= 0 [ 1522.048056] ata12: translated ATA stat/err 0x01/04 to
> SCSI SK/ASC/ASCQ 0xb/00/00 [ 1522.048679] ata12.00: device reported
> invalid CHS sector 0
> [ 1522.049268] ata12: status=0x01 { Error }
> [ 1522.049856] ata12: error=0x04 { DriveStatusError }
> [ 1558.816044] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
> mvi=ffff880123200000 task=ffff880124d89500 slot=ffff880123226680
> slot_idx=x4 [ 1558.816058] drivers/scsi/mvsas/mv_sas.c
> 1632:mvs_query_task:rc= 5 [ 1558.816086] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x89800. [ 1558.816092] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x1001 [ 1558.816103] drivers/scsi/mvsas/mv_sas.c
> 2111:phy3 Unplug Notice [ 1558.826059] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x199800. [ 1558.826066] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x1081 [ 1558.829663] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x199800. [ 1558.829670] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x10000 [ 1558.829677] drivers/scsi/mvsas/mv_sas.c
> 2138:notify plug in on phy[3] [ 1558.904494] drivers/scsi/mvsas/mv_sas.c
> 1224:port 3 attach dev info is 2000000 [ 1558.904494]
> drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas addr is 3 [
> 1558.938424] drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
> [ 1561.024027] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
> device[3]:rc= 0 [ 1561.024044] ata12: translated ATA stat/err 0x01/04 to
> SCSI SK/ASC/ASCQ 0xb/00/00 [ 1561.024652] ata12.00: device reported
> invalid CHS sector 0
> [ 1561.025242] ata12: status=0x01 { Error }
> [ 1561.025834] ata12: error=0x04 { DriveStatusError }
> [ 1594.800036] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
> mvi=ffff880123200000 task=ffff88011f945a40 slot=ffff880123226680
> slot_idx=x4 [ 1594.800051] drivers/scsi/mvsas/mv_sas.c
> 1632:mvs_query_task:rc= 5 [ 1594.800077] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x89800. [ 1594.800083] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x1001 [ 1594.800094] drivers/scsi/mvsas/mv_sas.c
> 2111:phy3 Unplug Notice [ 1594.810048] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x199800. [ 1594.810055] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x1081 [ 1594.814327] drivers/scsi/mvsas/mv_sas.c
> 2083:port 3 ctrl sts=0x199800. [ 1594.814330] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 3 irq sts = 0x10000 [ 1594.814332] drivers/scsi/mvsas/mv_sas.c
> 2138:notify plug in on phy[3] [ 1594.882000] drivers/scsi/mvsas/mv_sas.c
> 1224:port 3 attach dev info is 2000000 [ 1594.882000]
> drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas addr is 3 [
> 1594.923382] drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
> [ 1597.008031] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
> device[3]:rc= 0 [ 1597.008048] ata12: translated ATA stat/err 0x01/04 to
> SCSI SK/ASC/ASCQ 0xb/00/00 [ 1597.008675] ata12.00: device reported
> invalid CHS sector 0
> [ 1597.009271] ata12: status=0x01 { Error }
> [ 1597.009871] ata12: error=0x04 { DriveStatusError }
> [ 2193.824051] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
> mvi=ffff880123200000 task=ffff880009c7c540 slot=ffff8801232265d0
> slot_idx=x2 [ 2193.824065] drivers/scsi/mvsas/mv_sas.c
> 1632:mvs_query_task:rc= 5 [ 2193.824092] drivers/scsi/mvsas/mv_sas.c
> 2083:port 0 ctrl sts=0x89800. [ 2193.824099] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 0 irq sts = 0x1001001 [ 2193.824109] drivers/scsi/mvsas/mv_sas.c
> 2111:phy0 Unplug Notice [ 2193.834062] drivers/scsi/mvsas/mv_sas.c
> 2083:port 0 ctrl sts=0x199800. [ 2193.834067] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 0 irq sts = 0x1001081 [ 2193.855272] drivers/scsi/mvsas/mv_sas.c
> 2083:port 0 ctrl sts=0x199800. [ 2193.855279] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 0 irq sts = 0x10000 [ 2193.855286] drivers/scsi/mvsas/mv_sas.c
> 2138:notify plug in on phy[0] [ 2193.859234] drivers/scsi/mvsas/mv_sas.c
> 1224:port 0 attach dev info is 0 [ 2193.859234]
> drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 0 [
> 2193.959270] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
> [ 2196.032026] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
> device[0]:rc= 0 [ 2196.032045] ata9: translated ATA stat/err 0x01/04 to
> SCSI SK/ASC/ASCQ 0xb/00/00 [ 2196.032676] ata9: status=0x01 { Error }
> [ 2196.033274] ata9: error=0x04 { DriveStatusError }
> [ 2440.800047] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
> mvi=ffff880123200000 task=ffff880010f36700 slot=ffff880123226628
> slot_idx=x3 [ 2440.800061] drivers/scsi/mvsas/mv_sas.c
> 1632:mvs_query_task:rc= 5 [ 2440.800090] drivers/scsi/mvsas/mv_sas.c
> 2083:port 7 ctrl sts=0x89800. [ 2440.800096] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 7 irq sts = 0x1001 [ 2440.800107] drivers/scsi/mvsas/mv_sas.c
> 2111:phy7 Unplug Notice [ 2440.810060] drivers/scsi/mvsas/mv_sas.c
> 2083:port 7 ctrl sts=0x199800. [ 2440.810065] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 7 irq sts = 0x1081 [ 2440.831453] drivers/scsi/mvsas/mv_sas.c
> 2083:port 7 ctrl sts=0x199800. [ 2440.831460] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 7 irq sts = 0x10000 [ 2440.831467] drivers/scsi/mvsas/mv_sas.c
> 2138:notify plug in on phy[7] [ 2440.880053] drivers/scsi/mvsas/mv_sas.c
> 1224:port 7 attach dev info is 4000000 [ 2440.880053]
> drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas addr is 7 [
> 2440.940497] drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
> [ 2443.008033] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
> device[4]:rc= 0 [ 2443.008052] ata13: translated ATA stat/err 0x01/04 to
> SCSI SK/ASC/ASCQ 0xb/00/00 [ 2443.008685] ata13: status=0x01 { Error }
> [ 2443.009295] ata13: error=0x04 { DriveStatusError }
> [ 2675.808044] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
> mvi=ffff880123200000 task=ffff88011aae3500 slot=ffff880123226578
> slot_idx=x1 [ 2675.808058] drivers/scsi/mvsas/mv_sas.c
> 1632:mvs_query_task:rc= 5 [ 2675.808088] drivers/scsi/mvsas/mv_sas.c
> 2083:port 2 ctrl sts=0x89800. [ 2675.808094] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 2 irq sts = 0x1001 [ 2675.808104] drivers/scsi/mvsas/mv_sas.c
> 2111:phy2 Unplug Notice [ 2675.818051] drivers/scsi/mvsas/mv_sas.c
> 2083:port 2 ctrl sts=0x199800. [ 2675.818057] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 2 irq sts = 0x1081 [ 2675.839505] drivers/scsi/mvsas/mv_sas.c
> 2083:port 2 ctrl sts=0x199800. [ 2675.839513] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 2 irq sts = 0x10000 [ 2675.839519] drivers/scsi/mvsas/mv_sas.c
> 2138:notify plug in on phy[2] [ 2675.874139] drivers/scsi/mvsas/mv_sas.c
> 1224:port 2 attach dev info is 4 [ 2675.874139]
> drivers/scsi/mvsas/mv_sas.c 1226:port 2 attach sas addr is 2 [
> 2675.936683] drivers/scsi/mvsas/mv_sas.c 378:phy 2 byte dmaded.
> [ 2678.016055] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
> device[2]:rc= 0 [ 2678.016075] ata11: translated ATA stat/err 0x01/04 to
> SCSI SK/ASC/ASCQ 0xb/00/00 [ 2678.016706] ata11: status=0x01 { Error }
> [ 2678.017315] ata11: error=0x04 { DriveStatusError }
> [ 2678.017964] ata9: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ
> 0xb/00/00 [ 2678.018573] ata9: status=0x01 { Error }
> [ 2678.019175] ata9: error=0x04 { DriveStatusError }
> 
> I did not unplug a disk, the errors seem to be spurious.
> 
> Otherwise though things seem to be working. At least so far. The
> mv_abort_task part is very familiar, the older version of this driver
> would do it right after attempting to build/activate the md raid5 array
> that lives on this controller. Except the controller would lock up, and
> all drives would become inaccessible.
> 
> I'm going to attempt to grow this array today, so long as the xfs_fsr that
> I started doesn't cause the array to fail.
> 
> If I keep getting mv_abort_task errors, I'll have to back down to the copy
> of the driver I got from Andy Yan. I've managed to patch it up to compile
> for 2.6.36 just now, I just hope it'll work at least as well as it did
> with 2.6.34. At the very least I didn't get these errors.
> 
> Some background, the disks attached to the card are (5) Seagate 7200.12 1TB
> disks, using SAS->SATA cables. Machine is a amd64 Phenom II X4 810 w/4G
> ram running debian sid and a vanila 2.6.36 kernel. The card is a
> AOC-SASLP-MV8, according to lspci:
> 
> 04:00.0 SCSI storage controller: Marvell Technology Group Ltd.
> MV64460/64461/64462 System Controller, Revision B (rev 01)
> 
> according to dmesg:
> 
> [    2.819325] mvsas 0000:04:00.0: mvsas: driver version 0.8.2
> [    2.819394] mvsas 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ
> 19 [    2.819454] mvsas 0000:04:00.0: setting latency timer to 64
> [    2.820952] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5
> Gbps [    7.203222] drivers/scsi/mvsas/mv_sas.c 1224:port 0 attach dev
> info is 0 [    7.203225] drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach
> sas addr is 0 [    7.403220] drivers/scsi/mvsas/mv_sas.c 1224:port 1
> attach dev info is 0 [    7.403223] drivers/scsi/mvsas/mv_sas.c 1226:port
> 1 attach sas addr is 1 [    7.603221] drivers/scsi/mvsas/mv_sas.c
> 1224:port 2 attach dev info is 4 [    7.603223]
> drivers/scsi/mvsas/mv_sas.c 1226:port 2 attach sas addr is 2 [   
> 7.803221] drivers/scsi/mvsas/mv_sas.c 1224:port 3 attach dev info is
> 2000000 [    7.803224] drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas
> addr is 3 [    7.904015] drivers/scsi/mvsas/mv_sas.c 1224:port 4 attach
> dev info is 0 [    7.904018] drivers/scsi/mvsas/mv_sas.c 1226:port 4
> attach sas addr is 0 [    8.008014] drivers/scsi/mvsas/mv_sas.c 1224:port
> 5 attach dev info is 0 [    8.008017] drivers/scsi/mvsas/mv_sas.c
> 1226:port 5 attach sas addr is 0 [    8.112014]
> drivers/scsi/mvsas/mv_sas.c 1224:port 6 attach dev info is 0 [   
> 8.112016] drivers/scsi/mvsas/mv_sas.c 1226:port 6 attach sas addr is 0 [  
>  8.315223] drivers/scsi/mvsas/mv_sas.c 1224:port 7 attach dev info is
> 4000000 [    8.315226] drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas
> addr is 7 [    8.315230] scsi8 : mvsas
> [    8.315620] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
> [    8.315624] drivers/scsi/mvsas/mv_sas.c 378:phy 1 byte dmaded.
> [    8.315628] drivers/scsi/mvsas/mv_sas.c 378:phy 2 byte dmaded.
> [    8.315632] drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
> [    8.315636] drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
> [    8.316762] drivers/scsi/mvsas/mv_sas.c 1388:found dev[0:5] is gone.
> [    8.384626] drivers/scsi/mvsas/mv_sas.c 1388:found dev[1:5] is gone.
> [    8.452444] drivers/scsi/mvsas/mv_sas.c 1388:found dev[2:5] is gone.
> [    8.520181] drivers/scsi/mvsas/mv_sas.c 1388:found dev[3:5] is gone.
> [    8.523810] drivers/scsi/mvsas/mv_sas.c 1388:found dev[4:5] is gone.
> 
> I just hope the raid5 reshape I'm about to do doesn't crap its pants
> because of the errors above.
> 
> I'd like to help test any fixes or changes if needed. Let me know.
> 
> Thanks again.

After a couple days of uptime, the messages are still happening:

[175665.888045] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880123b00000 task=ffff88010e77e000 slot=ffff880123b26680 slot_idx=x4
[175665.888059] drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
[175665.888086] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x89800.
[175665.888092] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1001
[175665.888103] drivers/scsi/mvsas/mv_sas.c 2111:phy0 Unplug Notice
[175665.898053] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
[175665.898061] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1081
[175665.919498] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
[175665.919501] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x10000
[175665.919503] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[0]
[175666.018302] drivers/scsi/mvsas/mv_sas.c 1224:port 0 attach dev info is 0
[175666.018302] drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 0
[175666.028291] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
[175668.096048] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[0]:rc= 0
[175668.096066] ata9: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[175668.096739] ata9.00: device reported invalid CHS sector 0
[175668.097379] ata9: status=0x01 { Error }
[175668.098022] ata9: error=0x04 { DriveStatusError }

No fatal errors yet.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
