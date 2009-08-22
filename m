From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Sat, 22 Aug 2009 16:24:30 -0300
Message-ID: <20090822192430.GA5697@ime.usp.br>
References: <20090820220740.GA767@ime.usp.br>
 <Pine.LNX.4.44L0.0908211003090.2912-100000@iolanthe.rowland.org>
 <20090822191420.GA5572@ime.usp.br>
 <20090822192304.GB5572@ime.usp.br>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout9.uol.com.br ([200.221.4.200]:47827 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933296AbZHVTYd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2009 15:24:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by socom9.uol.com.br (Postfix) with ESMTP id 0D2BA93
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2009 16:20:37 -0300 (BRT)
Received: from chagas.nectar.ath.cx (unknown [187.22.248.83])
	by socom9.uol.com.br (Postfix) with ESMTPA id EAD90B0
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2009 16:20:35 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <20090822192304.GB5572@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Aug 22 2009, Rogério Brito wrote:
> Hi, it's me again.
(...)

The eternal problems between humans and attachments... :-(


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="smartctl.txt"

[ 3557.766018] usb 1-1: new high speed USB device using ehci_hcd and address 2
[ 3557.880845] usb 1-1: New USB device found, idVendor=06e1, idProduct=d185
[ 3557.880852] usb 1-1: New USB device strings: Mfr=56, Product=78, SerialNumber=100
[ 3557.880856] usb 1-1: Product: USB2.0 Storage Device
[ 3557.880859] usb 1-1: Manufacturer: ADS Technologies lnc.
[ 3557.880862] usb 1-1: SerialNumber: A9EA07106E8C
[ 3557.880990] usb 1-1: configuration #1 chosen from 1 choice
[ 3557.912142] Initializing USB Mass Storage driver...
[ 3557.913540] scsi2 : SCSI emulation for USB Mass Storage devices
[ 3557.915028] usb-storage: device found at 2
[ 3557.915033] usb-storage: waiting for device to settle before scanning
[ 3557.915068] usbcore: registered new interface driver usb-storage
[ 3557.915075] USB Mass Storage support registered.
[ 3562.915318] usb-storage: device scan complete
[ 3562.915795] scsi 2:0:0:0: Direct-Access     ST375064 0A                    PQ: 0 ANSI: 0
[ 3562.951132] sd 2:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[ 3562.951998] sd 2:0:0:0: [sda] Write Protect is off
[ 3562.952017] sd 2:0:0:0: [sda] Mode Sense: 33 00 00 00
[ 3562.952024] sd 2:0:0:0: [sda] Assuming drive cache: write through
[ 3562.953873] sd 2:0:0:0: [sda] Assuming drive cache: write through
[ 3562.953879]  sda: sda1
[ 3562.978866] sd 2:0:0:0: [sda] Assuming drive cache: write through
[ 3562.978873] sd 2:0:0:0: [sda] Attached SCSI disk
[ 3563.422546] EXT4-fs (sda1): barriers enabled
[ 3563.451546] kjournald2 starting: pid 5527, dev sda1:8, commit interval 5 seconds
[ 3563.452641] EXT4-fs (sda1): internal journal on sda1:8
[ 3563.452649] EXT4-fs (sda1): delayed allocation enabled
[ 3563.452655] EXT4-fs: file extents enabled
[ 3563.500069] EXT4-fs: mballoc enabled
[ 3563.500103] EXT4-fs (sda1): mounted filesystem with ordered data mode
[ 4205.806025] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[ 4205.920895] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 4266.806022] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[ 4327.806033] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[ 4388.807021] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[ 4440.168050] INFO: task smartctl:5581 blocked for more than 120 seconds.
[ 4440.168055] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4440.168060] smartctl      D ffff8800014ad9c0     0  5581   2677 0x00000000
[ 4440.168068]  ffff8800681bf740 0000000000000086 0000000000000001 0000000000000001
[ 4440.168075]  00000000000109c0 000000000000c858 ffff8800681be360 ffff8800681be6d8
[ 4440.168082]  000000007c8713b0 ffff880068051d68 ffff8800681be6d8 ffff880068051d70
[ 4440.168089] Call Trace:
[ 4440.168103]  [<ffffffff812594de>] ? schedule_timeout+0x1e/0xb8
[ 4440.168138]  [<ffffffffa00482ca>] ? scsi_request_fn+0x355/0x423 [scsi_mod]
[ 4440.168146]  [<ffffffff8103ec9f>] ? del_timer+0x59/0x62
[ 4440.168152]  [<ffffffff812589ce>] ? wait_for_common+0xaa/0x10b
[ 4440.168159]  [<ffffffff81030077>] ? default_wake_function+0x0/0x9
[ 4440.168167]  [<ffffffff81107298>] ? __generic_unplug_device+0x12/0x2c
[ 4440.168173]  [<ffffffff8110a5f4>] ? blk_execute_rq+0x93/0xab
[ 4440.168178]  [<ffffffff8110a7b9>] ? blk_recount_segments+0x17/0x27
[ 4440.168184]  [<ffffffff811054c6>] ? blk_rq_bio_prep+0x39/0x69
[ 4440.168190]  [<ffffffff8110d8be>] ? sg_scsi_ioctl+0x229/0x2ad
[ 4440.168196]  [<ffffffff8110dc94>] ? scsi_cmd_ioctl+0x352/0x39e
[ 4440.168202]  [<ffffffff81069912>] ? filemap_fault+0x5e/0x36d
[ 4440.168208]  [<ffffffff8107a2a8>] ? __do_fault+0x34b/0x386
[ 4440.168214]  [<ffffffff81113b80>] ? kobject_get+0x12/0x17
[ 4440.168225]  [<ffffffffa026c7e0>] ? sd_ioctl+0x78/0xa6 [sd_mod]
[ 4440.168230]  [<ffffffff8110b509>] ? __blkdev_driver_ioctl+0x69/0x7e
[ 4440.168236]  [<ffffffff8110bd14>] ? blkdev_ioctl+0x7d2/0x806
[ 4440.168241]  [<ffffffff81069912>] ? filemap_fault+0x5e/0x36d
[ 4440.168246]  [<ffffffff8107a2a8>] ? __do_fault+0x34b/0x386
[ 4440.168254]  [<ffffffff810b6c71>] ? block_ioctl+0x38/0x3c
[ 4440.168261]  [<ffffffff810a01fa>] ? vfs_ioctl+0x21/0x6c
[ 4440.168266]  [<ffffffff810a06fe>] ? do_vfs_ioctl+0x443/0x47b
[ 4440.168272]  [<ffffffff81021e5c>] ? do_page_fault+0x1fe/0x212
[ 4440.168277]  [<ffffffff810a0773>] ? sys_ioctl+0x3d/0x5c
[ 4440.168284]  [<ffffffff8100b02b>] ? system_call_fastpath+0x16/0x1b
[ 4449.806034] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[ 4510.807023] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[ 4560.168054] INFO: task smartctl:5581 blocked for more than 120 seconds.
[ 4560.168060] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4560.168064] smartctl      D ffff8800014ad9c0     0  5581   2677 0x00000000
[ 4560.168072]  ffff8800681bf740 0000000000000086 0000000000000001 0000000000000001
[ 4560.168080]  00000000000109c0 000000000000c858 ffff8800681be360 ffff8800681be6d8
[ 4560.168087]  000000007c8713b0 ffff880068051d68 ffff8800681be6d8 ffff880068051d70
[ 4560.168095] Call Trace:
[ 4560.168108]  [<ffffffff812594de>] ? schedule_timeout+0x1e/0xb8
[ 4560.168142]  [<ffffffffa00482ca>] ? scsi_request_fn+0x355/0x423 [scsi_mod]
[ 4560.168150]  [<ffffffff8103ec9f>] ? del_timer+0x59/0x62
[ 4560.168155]  [<ffffffff812589ce>] ? wait_for_common+0xaa/0x10b
[ 4560.168163]  [<ffffffff81030077>] ? default_wake_function+0x0/0x9
[ 4560.168171]  [<ffffffff81107298>] ? __generic_unplug_device+0x12/0x2c
[ 4560.168177]  [<ffffffff8110a5f4>] ? blk_execute_rq+0x93/0xab
[ 4560.168182]  [<ffffffff8110a7b9>] ? blk_recount_segments+0x17/0x27
[ 4560.168188]  [<ffffffff811054c6>] ? blk_rq_bio_prep+0x39/0x69
[ 4560.168194]  [<ffffffff8110d8be>] ? sg_scsi_ioctl+0x229/0x2ad
[ 4560.168200]  [<ffffffff8110dc94>] ? scsi_cmd_ioctl+0x352/0x39e
[ 4560.168206]  [<ffffffff81069912>] ? filemap_fault+0x5e/0x36d
[ 4560.168213]  [<ffffffff8107a2a8>] ? __do_fault+0x34b/0x386
[ 4560.168219]  [<ffffffff81113b80>] ? kobject_get+0x12/0x17
[ 4560.168229]  [<ffffffffa026c7e0>] ? sd_ioctl+0x78/0xa6 [sd_mod]
[ 4560.168235]  [<ffffffff8110b509>] ? __blkdev_driver_ioctl+0x69/0x7e
[ 4560.168240]  [<ffffffff8110bd14>] ? blkdev_ioctl+0x7d2/0x806
[ 4560.168246]  [<ffffffff81069912>] ? filemap_fault+0x5e/0x36d
[ 4560.168251]  [<ffffffff8107a2a8>] ? __do_fault+0x34b/0x386
[ 4560.168259]  [<ffffffff810b6c71>] ? block_ioctl+0x38/0x3c
[ 4560.168266]  [<ffffffff810a01fa>] ? vfs_ioctl+0x21/0x6c
[ 4560.168271]  [<ffffffff810a06fe>] ? do_vfs_ioctl+0x443/0x47b
[ 4560.168277]  [<ffffffff81021e5c>] ? do_page_fault+0x1fe/0x212
[ 4560.168283]  [<ffffffff810a0773>] ? sys_ioctl+0x3d/0x5c
[ 4560.168289]  [<ffffffff8100b02b>] ? system_call_fastpath+0x16/0x1b
[ 4571.806026] usb 1-1: reset high speed USB device using ehci_hcd and address 2

--7AUc2qLy4jB3hD7Z--
