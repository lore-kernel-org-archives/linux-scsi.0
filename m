From: Olaf Hering <olh@suse.de>
Subject: 2.6.11rc2 prints disksize twice
Date: Mon, 31 Jan 2005 13:15:37 +0100
Message-ID: <20050131121537.GA32111@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46545 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261160AbVAaMPj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 07:15:39 -0500
Received: from hermes.suse.de (hermes-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by Cantor.suse.de (Postfix) with ESMTP id 4254413DC17B
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 13:15:38 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I think its not a functional problem,
but parts of the disk detection is printed twice.

...
SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdc: drive cache: write through
SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdc: drive cache: write through
...


Loading sym0: <1010-66> rev 0x1 at pci 0000:41:01.0 irq 103
kernel/drivers/ssym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
csi/scsi_mod.ko
Loading kernel/drivers/scsi/sdsym0: SCSI BUS has been reset.
_mod.ko
Loadingscsi0 : sym-2.1.18n
 kernel/drivers/scsi/sr_mod.ko
Loading kernel/drivers/scsi/scsi_transport_spi.ko
Loading kernel/drivers/scsi/sym53c8xx_2/sym53c8xx.ko
sym0:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28C
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:8:0: tagged command queuing enabled, command queue depth 16.
 target0:0:8: Beginning Domain Validation
sym0:8: asynchronous.
sym0:8: wide asynchronous.
sym0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
 target0:0:8: Ending Domain Validation
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sda: drive cache: write through
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sda: drive cache: write through
 sda: sda2 sda3 sda4
Attached scsi disk sda at scsi0, channel 0, id 8, lun 0
sym0:9: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28C
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:9:0: tagged command queuing enabled, command queue depth 16.
 target0:0:9: Beginning Domain Validation
sym0:9: asynchronous.
sym0:9: wide asynchronous.
sym0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
 target0:0:9: Ending Domain Validation
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdb: drive cache: write through
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdb: drive cache: write through
 sdb: sdb1 sdb2 sdb3
Attached scsi disk sdb at scsi0, channel 0, id 9, lun 0
sym0:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28C
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:10:0: tagged command queuing enabled, command queue depth 16.
 target0:0:10: Beginning Domain Validation
sym0:10: asynchronous.
sym0:10: wide asynchronous.
sym0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
 target0:0:10: Ending Domain Validation
SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdc: drive cache: write through
SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdc: drive cache: write through
 sdc: sdc1 sdc2 sdc3
Attached scsi disk sdc at scsi0, channel 0, id 10, lun 0
  Vendor: IBM       Model: HSBPD4E  PU3SCSI  Rev: 0016
  Type:   Enclosure                          ANSI SCSI revision: 02
 target0:0:15: Beginning Domain Validation
 target0:0:15: Ending Domain Validation
sym1: <1010-66> rev 0x1 at pci 0000:41:01.1 irq 104
sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.1.18n


