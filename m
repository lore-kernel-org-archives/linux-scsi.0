From: Nohez <nohez@cmie.com>
Subject: Re: Qlogic 2460 Query
Date: Tue, 17 Jan 2006 04:21:23 +0530 (IST)
Message-ID: <Pine.LNX.4.33.0601170405210.30241-100000@mars.cmie.ernet.in>
References: <20060116211724.GB13315@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [202.149.212.34] ([202.149.212.34]:25698 "EHLO cmie.com")
	by vger.kernel.org with ESMTP id S1751249AbWAPWuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 17:50:15 -0500
In-Reply-To: <20060116211724.GB13315@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org


I tried the patch. It works. I can now access the JBOD using Qlogic
driver. I have attached the relevant messages from /var/log/messages.

Thank you

Nohez

-------------------------------------------------------------------
/var/log/messages
-------------------------------------------------------------------
kernel: QLogic Fibre Channel HBA Driver
kernel: qla2400 0000:02:02.0: Found an ISP2422, irq 11, iobase 0xd087c000
kernel: qla2400 0000:02:02.0: Configuring PCI space...
kernel: qla2400 0000:02:02.0: Configure NVRAM parameters...
kernel: qla2400 0000:02:02.0: Verifying loaded RISC code...
kernel: scsi(3): **** Load RISC code ****
kernel: scsi(3): Verifying Checksum of loaded RISC code.
kernel: scsi(3): Checksum OK, start firmware.
kernel: qla2400 0000:02:02.0: Allocated (1061 KB) for firmware dump...
kernel: scsi(3): Issue init firmware.
kernel: qla2400 0000:02:02.0: Waiting for LIP to complete...
kernel: scsi(3): Asynchronous LIP RESET (f7f7).
kernel: qla2400 0000:02:02.0: LIP reset occured (f7f7).
kernel: scsi(3): LIP occured (f7f7).
kernel: qla2400 0000:02:02.0: LIP occured (f7f7).
kernel: scsi(3): Asynchronous LOOP UP (1 Gbps).
kernel: qla2400 0000:02:02.0: LOOP UP detected (1 Gbps).
kernel: scsi(3): Asynchronous PORT UPDATE.
kernel: scsi(3): Port database changed ffff 0006 0000.
kernel: scsi(3): F/W Ready - OK
kernel: scsi(3): fw_state=3 curr time=ffffaefe.
kernel: qla2400 0000:02:02.0: Topology - (Loop), Host Loop address 0x0
kernel: scsi(3): Configure loop -- dpc flags =0x4080040
kernel: qla2x00_mailbox_command(3): **** FAILED. mbx0=4006, mbx1=7fe, mbx2=5eb, cmd=6a ****
kernel: qla2x00_get_port_name(3): failed=102.
kernel: scsi(3): MBC_GET_PORT_NAME Failed, No FL Port
kernel: scsi(3): LOOP READY
kernel: DEBUG: detect hba 3 at address = c5d92284
kernel: scsi3 : qla2xxx
kernel: qla2400 0000:02:02.0:
kernel:  QLogic Fibre Channel HBA Driver: 8.01.03-k-fw-debug
kernel:   QLogic QLA2460 - PCI-X 2.0 to 4Gb FC, Single Channel
kernel:   ISP2422: PCI (33 MHz) @ 0000:02:02.0 hdma-, host#=3, fw=4.00.16 [IP]
kernel:   Vendor: SUN       Model: SENA              Rev: 1.09
kernel:   Type:   Enclosure                          ANSI SCSI revision: 03
kernel:  3:0:0:0: Attached scsi generic sg1 type 13
kernel:   Vendor: FUJITSU   Model: MAN3735F SUN72G   Rev: 1504
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
kernel: SCSI device sdb: 143374738 512-byte hdwr sectors (73408 MB)
kernel: SCSI device sdb: drive cache: write through
kernel: SCSI device sdb: 143374738 512-byte hdwr sectors (73408 MB)
kernel: SCSI device sdb: drive cache: write through
kernel:  sdb: sdb1 sdb2
kernel: sd 3:0:1:0: Attached scsi disk sdb
kernel: sd 3:0:1:0: Attached scsi generic sg2 type 0
kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x800.
kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x800.
kernel: scsi(3:1:1) UNDERRUN status detected 0x15-0x302.
kernel:   Vendor: FUJITSU   Model: MAN3735F SUN72G   Rev: 1504
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
kernel: SCSI device sdc: 143374738 512-byte hdwr sectors (73408 MB)
kernel: SCSI device sdc: drive cache: write through
kernel: SCSI device sdc: 143374738 512-byte hdwr sectors (73408 MB)
kernel: SCSI device sdc: drive cache: write through
kernel:  sdc:<6>scsi(3:1:0) UNDERRUN status detected 0x15-0x800.
kernel: scsi(3:1:0) UNDERRUN status detected 0x15-0x800.
kernel:  sdc1
kernel: sd 3:0:2:0: Attached scsi disk sdc
kernel: sd 3:0:2:0: Attached scsi generic sg3 type 0
kernel: scsi(3:2:0) UNDERRUN status detected 0x15-0x800.
kernel: scsi(3:2:0) UNDERRUN status detected 0x15-0x800.
kernel: scsi(3:2:1) UNDERRUN status detected 0x15-0x302.
kernel:   Vendor: SUN       Model: SENA              Rev: 1.09
kernel:   Type:   Enclosure                          ANSI SCSI revision: 03
kernel:  3:0:3:0: Attached scsi generic sg4 type 13
kernel: scsi(3:2:0) UNDERRUN status detected 0x15-0x800.
kernel: scsi(3:2:0) UNDERRUN status detected 0x15-0x800.
-------------------------------------------------------------------

On Mon, 16 Jan 2006, Andrew Vasquez wrote:

> On Sat, 14 Jan 2006, Nohez wrote:
>
> > I have attached config file. How can I find out the driver variant that
> > OpenSuSE is using ? I have attached modinfo output. Will this help ?
>
> Ok, I was able to get a machine running with these sources and
> duplicate the problem.  Seems the sources are missing the following
> patch:
>
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113720091219427&q=raw
>
> Try that out and let me know if it solves the problem.
>
> Thanks,
> AV

