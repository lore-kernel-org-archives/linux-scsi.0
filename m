From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: [Trivial PATCH 2.6.9-bk5] dmx3191d.c lacked MODULE_DEVICE_TABLE()
Date: Thu, 21 Oct 2004 15:51:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410212251.i9LMpsm13032@freya.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [61.149.23.242] ([61.149.23.242]:32241 "EHLO
	freya.yggdrasil.com") by vger.kernel.org with ESMTP id S270361AbUJUH5i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 03:57:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: dafastidio@libero.it, linux-scsi@vger.kernel.org

Hi Christoph,

	Thank you for porting dmx3191d.c to the modern PCI driver
interface.  Here is a one line patch to correct a minor oversight.
You omitted the MODULE_DEVICE_TABLE() declaration, which is used
by boot and hot plug facilities to load the module when the hardware
is present.  Could you please forward it downstream if it looks
OK to you?  Thanks in advance.

                    __     ______________ 
Adam J. Richter        \ /
adam@yggdrasil.com      | g g d r a s i l

--- linux-2.6.9-bk5/drivers/scsi/dmx3191d.c	2004-10-21 12:01:55.000000000 -0700
+++ linux/drivers/scsi/dmx3191d.c	2004-10-21 15:21:02.000000000 -0700
@@ -146,6 +146,7 @@
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
 	{ }
 };
+MODULE_DEVICE_TABLE(pci, dmx3191d_pci_tbl);
 
 static struct pci_driver dmx3191d_pci_driver = {
 	.name		= DMX3191D_DRIVER_NAME,
