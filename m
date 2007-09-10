From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Mon, 10 Sep 2007 11:19:26 -0700
Message-ID: <20070910111926.9c942358.akpm@linux-foundation.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070910174926.GC30335@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbXIJSVB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2007 14:21:01 -0400
In-Reply-To: <20070910174926.GC30335@shadowen.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie, Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

On Mon, 10 Sep 2007 18:49:26 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> I have a couple of old NUMA-Q systems which are unable to read their
> boot disks with 2.6.23-rc4-mm1.  The disks appear to be recognised and
> even the partition tables read correctly, and then they go pop:
> 
>   qla1280: QLA1040 found on PCI bus 0, dev 10

cc's added.

>   Clocksource tsc unstable (delta = 99922590 ns)
>   Time: jiffies clocksource has been installed.
>   scsi(0:0): Resetting SCSI BUS
>   scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
>          Firmware version:  7.65.06, Driver version 3.26
>   scsi 0:0:0:0: Direct-Access     IBM      DGHS18X          0360 PQ: 0 ANSI: 3
>   scsi(0:0:0:0): Sync: period 10, offset 12, Wide
>   scsi 0:0:1:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
>   scsi(0:0:1:0): Sync: period 10, offset 12, Wide
>   scsi 0:0:2:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
>   scsi(0:0:2:0): Sync: period 10, offset 12, Wide
>   scsi 0:0:3:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
>   scsi(0:0:3:0): Sync: period 10, offset 12, Wide
>   scsi 0:0:4:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
>   scsi(0:0:4:0): Sync: period 10, offset 12, Wide
>   st: Version 20070203, fixed bufsize 32768, s/g segs 256
>   sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
>   sd 0:0:0:0: [sda] Write Protect is off
>   sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
>   sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
>   sd 0:0:0:0: [sda] Write Protect is off
>   sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
>    sda: sda1
>   sd 0:0:0:0: [sda] Attached SCSI disk
>   sd 0:0:1:0: [sdb] 17796077 512-byte hardware sectors (9112 MB)
>   sd 0:0:1:0: [sdb] Write Protect is off
>   sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
>   sd 0:0:1:0: [sdb] 17796077 512-byte hardware sectors (9112 MB)
>   sd 0:0:1:0: [sdb] Write Protect is off
>   sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
>    sdb: unknown partition table
>   sd 0:0:1:0: [sdb] Attached SCSI disk
>   sd 0:0:2:0: [sdc] 17796077 512-byte hardware sectors (9112 MB)
>   sd 0:0:2:0: [sdc] Write Protect is off
>   sd 0:0:2:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
>   sd 0:0:2:0: [sdc] 17796077 512-byte hardware sectors (9112 MB)
>   sd 0:0:2:0: [sdc] Write Protect is off
>   sd 0:0:2:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
>    sdc: sdc1
>   sd 0:0:2:0: [sdc] Attached SCSI disk
>   sd 0:0:3:0: [sdd] 17796077 512-byte hardware sectors (9112 MB)
>   sd 0:0:3:0: [sdd] Write Protect is off
>   sd 0:0:3:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
>   sd 0:0:3:0: [sdd] 17796077 512-byte hardware sectors (9112 MB)
>   sd 0:0:3:0: [sdd] Write Protect is off
>   sd 0:0:3:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
>    sdd: sdd1
>   sd 0:0:3:0: [sdd] Attached SCSI disk
>   sd 0:0:4:0: [sde] 17796077 512-byte hardware sectors (9112 MB)
>   sd 0:0:4:0: [sde] Write Protect is off
>   sd 0:0:4:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
>   sd 0:0:4:0: [sde] 17796077 512-byte hardware sectors (9112 MB)
>   sd 0:0:4:0: [sde] Write Protect is off
>   sd 0:0:4:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
>    sde: unknown partition table
>   sd 0:0:4:0: [sde] Attached SCSI disk
>   sd 0:0:0:0: Attached scsi generic sg0 type 0
>   sd 0:0:1:0: Attached scsi generic sg1 type 0
>   sd 0:0:2:0: Attached scsi generic sg2 type 0
>   sd 0:0:3:0: Attached scsi generic sg3 type 0
>   sd 0:0:4:0: Attached scsi generic sg4 type 0
>   serio: i8042 KBD port at 0x60,0x64 irq 1
>   serio: i8042 AUX port at 0x60,0x64 irq 12
>   mice: PS/2 mouse device common for all mice
>   input: AT Translated Set 2 keyboard as /class/input/input0
>   oprofile: using NMI interrupt.
>   TCP cubic registered
>   NET: Registered protocol family 1
>   NET: Registered protocol family 17
>   Using IPI Shortcut mode
>   input: PS/2 Logitech Mouse as /class/input/input1
>   RAMDISK: cramfs filesystem found at block 0
>   RAMDISK: Loading 1244KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/done.
>   VFS: Mounted root (cramfs filesystem) readonly.
>   Freeing unused kernel memory: 220k freed
>   initrd-tools: 0.1.81.1
>   mount: fs type devfs not supported by kernel
>   FATAL: Module sd_mod not found.
>   umount: devfs: not mounted
>   ext3: No journal on filesystem on sda1
>   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>   end_request: I/O error, dev sda, sector 63
>   Buffer I/O error on device sda1, logical block 0
>   Buffer I/O error on device sda1, logical block 1
>   Buffer I/O error on device sda1, logical block 2
>   Buffer I/O error on device sda1, logical block 3
>   mount: fs type devfs not supported by kernel
>   ext3: No journal on filesystem on sda1
>   umount: devfs: not mounted
>   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>   end_request: I/O error, dev sda, sector 28010831
>   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>   end_request: I/O error, dev sda, sector 31080815
>   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>   end_request: I/O error, dev sda, sector 31080855
>   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>   end_request: I/O error, dev sda, sector 31080919
>   Buffer I/O error on device sda1, logical block 3885107
>   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>   end_request: I/O error, dev sda, sector 28411047
>   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>   end_request: I/O error, dev sda, sector 31135687
>   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
>   end_request: I/O error, dev sda, sector 31138007
>   sd 0:0:0:0: [sda] <6>sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> 

The only patch which touches qla1280 is git-block.patch.  From a quick
squizz the change looks OK, although it's tricky and something might have
broken.

(the dprintk at line 2929 needs to print remseg, not seg_cnt).

Can you retest with that change reverted (below)?  If it's not that then
perhaps something in scsi core broke, dunno.


diff -puN drivers/scsi/qla1280.c~revert-1 drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~revert-1
+++ a/drivers/scsi/qla1280.c
@@ -2775,7 +2775,7 @@ qla1280_64bit_start_scsi(struct scsi_qla
 	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	cmd_a64_entry_t *pkt;
-	struct scatterlist *sg = NULL, *s;
+	struct scatterlist *sg = NULL;
 	__le32 *dword_ptr;
 	dma_addr_t dma_handle;
 	int status = 0;
@@ -2889,16 +2889,13 @@ qla1280_64bit_start_scsi(struct scsi_qla
 	 * Load data segments.
 	 */
 	if (seg_cnt) {	/* If data transfer. */
-		int remseg = seg_cnt;
 		/* Setup packet address segment pointer. */
 		dword_ptr = (u32 *)&pkt->dseg_0_address;
 
 		if (cmd->use_sg) {	/* If scatter gather */
 			/* Load command entry data segments. */
-			for_each_sg(sg, s, seg_cnt, cnt) {
-				if (cnt == 2)
-					break;
-				dma_handle = sg_dma_address(s);
+			for (cnt = 0; cnt < 2 && seg_cnt; cnt++, seg_cnt--) {
+				dma_handle = sg_dma_address(sg);
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 				if (ha->flags.use_pci_vchannel)
 					sn_pci_set_vchan(ha->pdev,
@@ -2909,12 +2906,12 @@ qla1280_64bit_start_scsi(struct scsi_qla
 					cpu_to_le32(pci_dma_lo32(dma_handle));
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_hi32(dma_handle));
-				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
+				*dword_ptr++ = cpu_to_le32(sg_dma_len(sg));
+				sg++;
 				dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 					cpu_to_le32(pci_dma_hi32(dma_handle)),
 					cpu_to_le32(pci_dma_lo32(dma_handle)),
-					cpu_to_le32(sg_dma_len(sg_next(s))));
-				remseg--;
+					cpu_to_le32(sg_dma_len(sg)));
 			}
 			dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
 				"command packet data - b %i, t %i, l %i \n",
@@ -2929,9 +2926,7 @@ qla1280_64bit_start_scsi(struct scsi_qla
 			dprintk(3, "S/G Building Continuation...seg_cnt=0x%x "
 				"remains\n", seg_cnt);
 
-			while (remseg > 0) {
-				/* Update sg start */
-				sg = s;
+			while (seg_cnt > 0) {
 				/* Adjust ring index. */
 				ha->req_ring_index++;
 				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
@@ -2957,10 +2952,9 @@ qla1280_64bit_start_scsi(struct scsi_qla
 					(u32 *)&((struct cont_a64_entry *) pkt)->dseg_0_address;
 
 				/* Load continuation entry data segments. */
-				for_each_sg(sg, s, remseg, cnt) {
-					if (cnt == 5)
-						break;
-					dma_handle = sg_dma_address(s);
+				for (cnt = 0; cnt < 5 && seg_cnt;
+				     cnt++, seg_cnt--) {
+					dma_handle = sg_dma_address(sg);
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 				if (ha->flags.use_pci_vchannel)
 					sn_pci_set_vchan(ha->pdev, 
@@ -2972,12 +2966,12 @@ qla1280_64bit_start_scsi(struct scsi_qla
 					*dword_ptr++ =
 						cpu_to_le32(pci_dma_hi32(dma_handle));
 					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(s));
+						cpu_to_le32(sg_dma_len(sg));
 					dprintk(3, "S/G Segment Cont. phys_addr=%x %x, len=0x%x\n",
 						cpu_to_le32(pci_dma_hi32(dma_handle)),
 						cpu_to_le32(pci_dma_lo32(dma_handle)),
-						cpu_to_le32(sg_dma_len(s)));
-					remseg--;
+						cpu_to_le32(sg_dma_len(sg)));
+					sg++;
 				}
 				dprintk(5, "qla1280_64bit_start_scsi: "
 					"continuation packet data - b %i, t "
@@ -3068,7 +3062,7 @@ qla1280_32bit_start_scsi(struct scsi_qla
 	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct cmd_entry *pkt;
-	struct scatterlist *sg = NULL, *s;
+	struct scatterlist *sg = NULL;
 	__le32 *dword_ptr;
 	int status = 0;
 	int cnt;
@@ -3194,7 +3188,6 @@ qla1280_32bit_start_scsi(struct scsi_qla
 	 * Load data segments.
 	 */
 	if (seg_cnt) {
-		int remseg = seg_cnt;
 		/* Setup packet address segment pointer. */
 		dword_ptr = &pkt->dseg_0_address;
 
@@ -3203,25 +3196,22 @@ qla1280_32bit_start_scsi(struct scsi_qla
 			qla1280_dump_buffer(1, (char *)sg, 4 * 16);
 
 			/* Load command entry data segments. */
-			for_each_sg(sg, s, seg_cnt, cnt) {
-				if (cnt == 4)
-					break;
+			for (cnt = 0; cnt < 4 && seg_cnt; cnt++, seg_cnt--) {
 				*dword_ptr++ =
-					cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
-				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
+					cpu_to_le32(pci_dma_lo32(sg_dma_address(sg)));
+				*dword_ptr++ =
+					cpu_to_le32(sg_dma_len(sg));
 				dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
-					(pci_dma_lo32(sg_dma_address(s))),
-					(sg_dma_len(s)));
-				remseg--;
+					(pci_dma_lo32(sg_dma_address(sg))),
+					(sg_dma_len(sg)));
+				sg++;
 			}
 			/*
 			 * Build continuation packets.
 			 */
 			dprintk(3, "S/G Building Continuation"
 				"...seg_cnt=0x%x remains\n", seg_cnt);
-			while (remseg > 0) {
-				/* Continue from end point */
-				sg = s;
+			while (seg_cnt > 0) {
 				/* Adjust ring index. */
 				ha->req_ring_index++;
 				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
@@ -3249,16 +3239,18 @@ qla1280_32bit_start_scsi(struct scsi_qla
 					&((struct cont_entry *) pkt)->dseg_0_address;
 
 				/* Load continuation entry data segments. */
-				for_each_sg(sg, s, remseg, cnt) {
+				for (cnt = 0; cnt < 7 && seg_cnt;
+				     cnt++, seg_cnt--) {
 					*dword_ptr++ =
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
+						cpu_to_le32(pci_dma_lo32(sg_dma_address(sg)));
 					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(s));
+						cpu_to_le32(sg_dma_len(sg));
 					dprintk(1,
 						"S/G Segment Cont. phys_addr=0x%x, "
 						"len=0x%x\n",
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
-						cpu_to_le32(sg_dma_len(s)));
+						cpu_to_le32(pci_dma_lo32(sg_dma_address(sg))),
+						cpu_to_le32(sg_dma_len(sg)));
+					sg++;
 				}
 				dprintk(5, "qla1280_32bit_start_scsi: "
 					"continuation packet data - "
_

