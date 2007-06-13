From: Csillag Tamas <cstamas@digitus.itk.ppke.hu>
Subject: Re: qla2xxx errors? (2.6.19)
Date: Wed, 13 Jun 2007 20:23:42 +0000
Message-ID: <20070613202342.GF14947@digitus>
References: <20070610100011.GG5705@digitus> <20070612174854.GD12266@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6e7ZaeXHKrTJCxdu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jugis.itk.ppke.hu ([193.225.109.42]:37842 "EHLO
	jugis.itk.ppke.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbXFMUYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 16:24:00 -0400
Content-Disposition: inline
In-Reply-To: <20070612174854.GD12266@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org


--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

On 06/12, Andrew Vasquez wrote:
> Could you load the driver with the ql2xextended_error_logging module
> parameter enabled:
> 
> 	$ echo "6 4 1 7"  > /proc/sys/kernel/printk
> 	$ insmod qla2xxx.ko ql2xextended_error_logging=1
> 
> and forward over the resultant messages file beginning with the load
> of the driver to the point at which the File-system failure occurs.

Ok, here we go...

Thanks.
-- 
CSILLAG Tamas (cstamas) - http://digitus.itk.ppke.hu/~cstamas

"Not all those who wander are lost."  - JRR Tolkien


--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename=current

2007-06-13_00:10:34.36780 kern.info: ACPI: PCI interrupt for device 0000:06:01.1 disabled
2007-06-13_00:10:34.38819 kern.info: ACPI: PCI interrupt for device 0000:06:01.0 disabled
2007-06-13_00:10:37.77002 kern.info: QLogic Fibre Channel HBA Driver
2007-06-13_00:10:37.77014 kern.info: ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 49 (level, low) -> IRQ 21
2007-06-13_00:10:37.77015 kern.info: qla2xxx 0000:06:01.0: Found an ISP2312, irq 21, iobase 0xf885c000
2007-06-13_00:10:37.77023 kern.info: qla2xxx 0000:06:01.0: Configuring PCI space...
2007-06-13_00:10:37.77041 kern.info: qla2xxx 0000:06:01.0: Configure NVRAM parameters...
2007-06-13_00:10:37.85574 kern.info: qla2xxx 0000:06:01.0: Verifying loaded RISC code...
2007-06-13_00:10:37.85576 kern.warn: scsi(5): **** Load RISC code ****
2007-06-13_00:10:37.95150 kern.warn: scsi(5): Verifying Checksum of loaded RISC code.
2007-06-13_00:10:37.97443 kern.warn: scsi(5): Checksum OK, start firmware.
2007-06-13_00:10:38.01821 kern.info: qla2xxx 0000:06:01.0: Extended memory detected (512 KB)...
2007-06-13_00:10:38.01822 kern.info: qla2xxx 0000:06:01.0: Resizing request queue depth (2048 -> 4096)...
2007-06-13_00:10:38.01829 kern.info: qla2xxx 0000:06:01.0: Allocated (1308 KB) for firmware dump...
2007-06-13_00:10:38.05235 kern.warn: scsi(5): Issue init firmware.
2007-06-13_00:10:38.07547 kern.warn: DEBUG: detect hba 5 at address = e23262f8
2007-06-13_00:10:38.07549 kern.info: scsi5 : qla2xxx
2007-06-13_00:10:40.07542 kern.warn: scsi(5): qla2x00_loop_resync()
2007-06-13_00:10:41.66893 kern.warn: scsi(5): Asynchronous P2P MODE received.
2007-06-13_00:10:41.66896 kern.warn: scsi(5): Asynchronous LOOP UP (2 Gbps).
2007-06-13_00:10:41.66897 kern.info: qla2xxx 0000:06:01.0: LOOP UP detected (2 Gbps).
2007-06-13_00:10:41.67430 kern.warn: scsi(5): Asynchronous PORT UPDATE.
2007-06-13_00:10:41.67435 kern.info: scsi(5): Port database changed ffff 0006 0000.
2007-06-13_00:10:41.80908 kern.warn: scsi(5): Asynchronous PORT UPDATE ignored 0000/0006/0000.
2007-06-13_00:10:41.80909 kern.warn: scsi(5): Asynchronous PORT UPDATE ignored 0000/0007/0000.
2007-06-13_00:10:41.82060 kern.warn: scsi(5): Asynchronous PORT UPDATE ignored 0000/0004/0000.
2007-06-13_00:10:42.14759 kern.warn: scsi(5): F/W Ready - OK 
2007-06-13_00:10:42.15900 kern.warn: scsi(5): fw_state=3 curr time=13a9568.
2007-06-13_00:10:42.17041 kern.warn: scsi(5): Configure loop -- dpc flags =0x40800e1
2007-06-13_00:10:42.18179 kern.warn: scsi(5): RSCN queue entry[0] = [00/000000].
2007-06-13_00:10:42.19295 kern.warn: scsi(5): device_resync: rscn overflow.
2007-06-13_00:10:42.20485 kern.warn: scsi(5): RFT_ID exiting normally.
2007-06-13_00:10:42.21633 kern.warn: scsi(5): RFF_ID exiting normally.
2007-06-13_00:10:42.22760 kern.warn: scsi(5): RNN_ID exiting normally.
2007-06-13_00:10:42.23881 kern.warn: scsi(5): RSNN_NN exiting normally.
2007-06-13_00:10:42.25540 kern.warn: scsi(5): GID_PT entry - nn 200000112593fc1c pn 210000112593fc1c portid=010100.
2007-06-13_00:10:42.26671 kern.warn: scsi(5): GID_PT entry - nn 200000112593f89c pn 210000112593f89c portid=010200.
2007-06-13_00:10:42.27796 kern.warn: scsi(5): GID_PT entry - nn 200000145e241c2c pn 210000145e241c2c portid=010300.
2007-06-13_00:10:42.28885 kern.warn: scsi(5): GID_PT entry - nn 200000145e241dd2 pn 210000145e241dd2 portid=010400.
2007-06-13_00:10:42.29975 kern.warn: scsi(5): GID_PT entry - nn 20000000d12672a5 pn 21000000d12672a5 portid=011100.
2007-06-13_00:10:42.29976 kern.warn: scsi(5): device wrap (011100)
2007-06-13_00:10:42.31919 kern.warn: scsi(5): Trying Fabric Login w/loop id 0x0081 for port 010100.
2007-06-13_00:10:42.32992 kern.warn: scsi(5): Trying Fabric Login w/loop id 0x0082 for port 010200.
2007-06-13_00:10:42.34015 kern.warn: scsi(5): Trying Fabric Login w/loop id 0x0083 for port 010300.
2007-06-13_00:10:42.35005 kern.warn: scsi(5): Trying Fabric Login w/loop id 0x0084 for port 011100.
2007-06-13_00:10:42.39558 kern.warn: scsi(5): LOOP READY
2007-06-13_00:10:42.39560 kern.info: qla2xxx 0000:06:01.0: 
2007-06-13_00:10:42.39561 kern.warn:  QLogic Fibre Channel HBA Driver: 8.01.07-k7-debug
2007-06-13_00:10:42.39562 kern.warn:   QLogic IBM FCEC - 
2007-06-13_00:10:42.39563 kern.warn:   ISP2312: PCI-X (133 MHz) @ 0000:06:01.0 hdma-, host#=5, fw=3.03.18 IPX
2007-06-13_00:10:42.39563 kern.info: ACPI: PCI Interrupt 0000:06:01.1[B] -> GSI 50 (level, low) -> IRQ 23
2007-06-13_00:10:42.39564 kern.info: qla2xxx 0000:06:01.1: Found an ISP2312, irq 23, iobase 0xf8c3e000
2007-06-13_00:10:42.39565 kern.info: qla2xxx 0000:06:01.1: Configuring PCI space...
2007-06-13_00:10:42.39566 kern.warn: scsi(6): No matching ROM signature.
2007-06-13_00:10:42.39567 kern.info: qla2xxx 0000:06:01.1: Configure NVRAM parameters...
2007-06-13_00:10:42.39568 kern.info: qla2xxx 0000:06:01.0: scsi(5:0:0:0): Queue depth adjusted-up to 4.
2007-06-13_00:10:42.39569 kern.warn: scsi(5): qla2x00_loop_resync - end
2007-06-13_00:10:42.41359 kern.notice: scsi 5:0:0:0: Direct-Access     IBM      DS400    S320    7.01 PQ: 1 ANSI: 4
2007-06-13_00:10:42.42267 kern.notice: scsi 5:0:0:0: Attached scsi generic sg1 type 0
2007-06-13_00:10:42.43283 kern.notice: scsi 5:0:0:1: Direct-Access     IBM      DS400    S320    7.01 PQ: 0 ANSI: 4
2007-06-13_00:10:42.45124 kern.notice: sd 5:0:0:1: [sdb] 1171701760 512-byte hardware sectors (599911 MB)
2007-06-13_00:10:42.45126 kern.info: qla2xxx 0000:06:01.1: Verifying loaded RISC code...
2007-06-13_00:10:42.45128 kern.warn: scsi(6): **** Load RISC code ****
2007-06-13_00:10:42.46028 kern.notice: sd 5:0:0:1: [sdb] Write Protect is off
2007-06-13_00:10:42.46030 kern.debug: sd 5:0:0:1: [sdb] Mode Sense: 8f 00 00 08
2007-06-13_00:10:42.46940 kern.notice: sd 5:0:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
2007-06-13_00:10:42.49598 kern.notice: sd 5:0:0:1: [sdb] 1171701760 512-byte hardware sectors (599911 MB)
2007-06-13_00:10:42.49600 kern.warn: scsi(6): Verifying Checksum of loaded RISC code.
2007-06-13_00:10:42.49604 kern.warn: scsi(6): Checksum OK, start firmware.
2007-06-13_00:10:42.50477 kern.notice: sd 5:0:0:1: [sdb] Write Protect is off
2007-06-13_00:10:42.50478 kern.debug: sd 5:0:0:1: [sdb] Mode Sense: 8f 00 00 08
2007-06-13_00:10:42.51429 kern.notice: sd 5:0:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
2007-06-13_00:10:42.51430 kern.info:  sdb:<6>qla2xxx 0000:06:01.1: Extended memory detected (512 KB)...
2007-06-13_00:10:42.52526 kern.info: qla2xxx 0000:06:01.1: Resizing request queue depth (2048 -> 4096)...
2007-06-13_00:10:42.52533 kern.info: qla2xxx 0000:06:01.1: Allocated (1308 KB) for firmware dump...
2007-06-13_00:10:42.52784 kern.warn:  sdb1
2007-06-13_00:10:42.54505 kern.notice: sd 5:0:0:1: [sdb] Attached SCSI disk
2007-06-13_00:10:42.56227 kern.notice: sd 5:0:0:1: Attached scsi generic sg2 type 0
2007-06-13_00:10:42.56228 kern.warn: scsi(6): Issue init firmware.
2007-06-13_00:10:42.57189 kern.notice: scsi 5:0:0:5: Direct-Access     IBM      DS400    S320    7.01 PQ: 0 ANSI: 4
2007-06-13_00:10:42.58189 kern.notice: sd 5:0:0:5: [sdc] 209715200 512-byte hardware sectors (107374 MB)
2007-06-13_00:10:42.59133 kern.notice: sd 5:0:0:5: [sdc] Write Protect is off
2007-06-13_00:10:42.59137 kern.debug: sd 5:0:0:5: [sdc] Mode Sense: 8f 00 00 08
2007-06-13_00:10:42.60164 kern.notice: sd 5:0:0:5: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
2007-06-13_00:10:42.61177 kern.notice: sd 5:0:0:5: [sdc] 209715200 512-byte hardware sectors (107374 MB)
2007-06-13_00:10:42.62176 kern.notice: sd 5:0:0:5: [sdc] Write Protect is off
2007-06-13_00:10:42.62178 kern.debug: sd 5:0:0:5: [sdc] Mode Sense: 8f 00 00 08
2007-06-13_00:10:42.63258 kern.notice: sd 5:0:0:5: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
2007-06-13_00:10:42.63259 kern.info:  sdc: sdc1
2007-06-13_00:10:42.65416 kern.notice: sd 5:0:0:5: [sdc] Attached SCSI disk
2007-06-13_00:10:42.65417 kern.notice: sd 5:0:0:5: Attached scsi generic sg3 type 0
2007-06-13_00:10:42.66967 kern.warn: DEBUG: detect hba 6 at address = e8d042f8
2007-06-13_00:10:42.66969 kern.info: scsi6 : qla2xxx
2007-06-13_00:10:43.07302 kern.warn: scsi(5): qla2x00_reset_marker()
2007-06-13_00:10:44.66695 kern.warn: scsi(6): qla2x00_loop_resync()
2007-06-13_00:10:47.69365 kern.info: qla2xxx 0000:06:01.1: 
2007-06-13_00:10:47.69368 kern.warn:  QLogic Fibre Channel HBA Driver: 8.01.07-k7-debug
2007-06-13_00:10:47.69369 kern.warn:   QLogic IBM FCEC - 
2007-06-13_00:10:47.69370 kern.warn:   ISP2312: PCI-X (133 MHz) @ 0000:06:01.1 hdma-, host#=6, fw=3.03.18 IPX
2007-06-13_00:11:04.72814 kern.info: qla2xxx 0000:06:01.1: Cable is unplugged...
2007-06-13_00:11:04.72817 kern.warn: scsi(6): fw_state=4 curr time=13aed9d.
2007-06-13_00:11:04.74938 kern.warn: scsi(6): Firmware ready **** FAILED ****.
2007-06-13_00:11:04.74939 kern.warn: qla2x00_loop_resync(): **** FAILED ****
2007-06-13_00:11:04.77101 kern.warn: scsi(6): qla2x00_loop_resync - end
2007-06-13_00:11:13.66824 kern.warn: scsi(6): Loop Down - aborting the queues before time expire
2007-06-13_00:14:57.67913 kern.warn: scsi(6): Loop down exceed 4 mins - restarting queues.
2007-06-13_00:18:59.66261 kern.notice: ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
2007-06-13_00:18:59.67418 kern.notice: ReiserFS: sdb1: using ordered data mode
2007-06-13_00:18:59.70499 kern.notice: ReiserFS: sdb1: journal params: device sdb1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
2007-06-13_00:18:59.71799 kern.notice: ReiserFS: sdb1: checking transaction log (sdb1)
2007-06-13_00:19:00.36535 kern.notice: ReiserFS: sdb1: Using r5 hash to sort names
2007-06-13_00:19:00.37791 kern.warn: ReiserFS: sdb1: warning: Created .reiserfs_priv on sdb1 - reserved for xattr storage.
2007-06-13_19:46:16.08535 kern.warn: ReiserFS: sdb1: warning: vs-4080: reiserfs_free_block: free_block (sdb1:67469615)[dev:blocknr]: bit already cleared
2007-06-13_19:47:26.94266 kern.warn: ReiserFS: sdb1: warning: vs-4080: reiserfs_free_block: free_block (sdb1:67469616)[dev:blocknr]: bit already cleared
2007-06-13_19:47:40.73310 kern.warn: ReiserFS: sdb1: warning: vs-4080: reiserfs_free_block: free_block (sdb1:67469617)[dev:blocknr]: bit already cleared
2007-06-13_19:47:40.75729 kern.warn: ReiserFS: sdb1: warning: vs-4080: reiserfs_free_block: free_block (sdb1:67469614)[dev:blocknr]: bit already cleared
2007-06-13_19:47:40.77323 kern.warn: ReiserFS: sdb1: warning: vs-4080: reiserfs_free_block: free_block (sdb1:67469618)[dev:blocknr]: bit already cleared
2007-06-13_19:51:54.33912 kern.warn: ReiserFS: sdb1: warning: vs-4080: reiserfs_free_block: free_block (sdb1:67469613)[dev:blocknr]: bit already cleared

--6e7ZaeXHKrTJCxdu--
