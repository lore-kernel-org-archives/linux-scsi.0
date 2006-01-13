From: Nohez <nohez@cmie.com>
Subject: Qlogic 2460 Query
Date: Fri, 13 Jan 2006 13:30:56 +0530 (IST)
Message-ID: <Pine.LNX.4.58.0601131309440.490@moon.cmie.ernet.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [202.149.212.34] ([202.149.212.34]:59175 "EHLO cmie.com")
	by vger.kernel.org with ESMTP id S932669AbWAMH7a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 02:59:30 -0500
Received: from mars.cmie.ernet.in (mars.cmie.ernet.in [196.1.1.2])
	by cmie.com (8.11.6/8.11.6/SuSE Linux 0.5) with ESMTP id k0D80uS06809
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 13:30:57 +0530
Received: from moon.cmie.ernet.in (moon.cmie.ernet.in [196.1.1.8])
	by mars.cmie.ernet.in (8.11.2/8.11.2/SuSE Linux 8.11.1-0.5) with ESMTP id k0D80uP32051
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 13:30:56 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


We recently bought a dozen Qlogic cards (model 2460 - 4Gbps). We installed
OpenSuSE 10 and the OS recognizes the card and I can access the JBOD.
OpenSuSE 10 installs kernel-default-2.6.13-15.7. For some reason I had
to upgrade the kernel to kernel-default-2.6.15-4.  Qlogic driver fails
to recognize the JBOD after the upgrade.  I also tried booting the kernel
with "acpi=off noapm". But it did not help.

Attached below is the relevant output of "dmesg" for both the kernels.

-----------------------------------------------------------------------
Works (kernel-default-2.6.13-15.7)
-----------------------------------------------------------------------
kernel: qla2xxx 0000:02:02.0: Found an ISP2422, irq 11, iobase 0xd13be000
kernel: qla2xxx 0000:02:02.0: Configuring PCI space...
kernel: qla2xxx 0000:02:02.0: Configure NVRAM parameters...
kernel: qla2xxx 0000:02:02.0: Verifying loaded RISC code...
kernel: qla2xxx 0000:02:02.0: Allocated (1061 KB) for firmware dump...
kernel: qla2xxx 0000:02:02.0: Waiting for LIP to complete...
kernel: BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
kernel: qla2xxx 0000:02:02.0: LIP reset occured (f7f7).
kernel: qla2xxx 0000:02:02.0: LIP occured (f7f7).
kernel: qla2xxx 0000:02:02.0: LOOP UP detected (1 Gbps).
kernel: qla2xxx 0000:02:02.0: Topology - (Loop), Host Loop address 0x0
kernel: scsi2 : qla2xxx
kernel: qla2xxx 0000:02:02.0:
kernel:  QLogic Fibre Channel HBA Driver: 8.01.00b5-k
kernel:   QLogic QLA2460 - PCI-X 2.0 to 4Gb FC, Single Channel
kernel:   ISP2422: PCI (33 MHz) @ 0000:02:02.0 hdma-, host#=2, fw=4.00.12 [IP]
kernel:   Vendor: SUN       Model: SENA              Rev: 1.09
kernel:   Type:   Enclosure                          ANSI SCSI revision: 03
kernel: Attached scsi generic sg1 at scsi2, channel 0, id 0, lun 0,  type 13
kernel:   Vendor: FUJITSU   Model: MAN3735F SUN72G   Rev: 1504
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
kernel: SCSI device sdb: 143374738 512-byte hdwr sectors (73408 MB)
kernel: SCSI device sdb: drive cache: write through
kernel: SCSI device sdb: 143374738 512-byte hdwr sectors (73408 MB)
kernel: SCSI device sdb: drive cache: write through
kernel:  sdb: sdb1 sdb2
kernel: Attached scsi disk sdb at scsi2, channel 0, id 1, lun 0
kernel: Attached scsi generic sg2 at scsi2, channel 0, id 1, lun 0,  type 0
kernel:   Vendor: FUJITSU   Model: MAN3735F SUN72G   Rev: 1504
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
kernel: SCSI device sdc: 143374738 512-byte hdwr sectors (73408 MB)
kernel: SCSI device sdc: drive cache: write through
kernel: SCSI device sdc: 143374738 512-byte hdwr sectors (73408 MB)
kernel: SCSI device sdc: drive cache: write through
kernel:  sdc: sdc1
kernel: Attached scsi disk sdc at scsi2, channel 0, id 2, lun 0
kernel: Attached scsi generic sg3 at scsi2, channel 0, id 2, lun 0,  type 0
kernel:   Vendor: SUN       Model: SENA              Rev: 1.09
kernel:   Type:   Enclosure                          ANSI SCSI revision: 03

-----------------------------------------------------------------------
Fails (kernel-default-2.6.15-4)
-----------------------------------------------------------------------
kernel: QLogic Fibre Channel HBA Driver
kernel: qla2400: module not supported by Novell, setting U taint flag.
kernel: qla2400 0000:02:02.0: Found an ISP2422, irq 11, iobase 0xd1370000
kernel: qla2400 0000:02:02.0: Configuring PCI space...
kernel: qla2400 0000:02:02.0: Configure NVRAM parameters...
kernel: qla2400 0000:02:02.0: Verifying loaded RISC code...
kernel: qla2400 0000:02:02.0: [ERROR] Failed to load segment 0 of firmware
kernel: Mailbox registers:
kernel: scsi(2): mbox 0 0x0000
kernel: scsi(2): mbox 1 0x0000
kernel: scsi(2): mbox 2 0x0002
kernel: scsi(2): mbox 3 0x4001
kernel: scsi(2): mbox 4 0x0000
kernel: scsi(2): mbox 5 0x0000
kernel: qla2400 0000:02:02.0: [ERROR] Failed to load segment 0 of firmware
kernel: Mailbox registers:
kernel: scsi(2): mbox 0 0x0000
kernel: scsi(2): mbox 1 0x0000
kernel: scsi(2): mbox 2 0x0002
kernel: scsi(2): mbox 3 0x4001
kernel: scsi(2): mbox 4 0x0000
kernel: scsi(2): mbox 5 0x0000
kernel: qla2400 0000:02:02.0: Failed to initialize adapter
-----------------------------------------------------------------------
