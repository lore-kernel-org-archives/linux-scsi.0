From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid (adaptec 2120S) and kernel msg
Date: Wed, 22 Jun 2005 08:23:10 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01521371@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28613 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261203AbVFVMX7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 08:23:59 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gabor Z. Papp" <gzp@papp.hu>, linux-scsi@vger.kernel.org

What is the device 03:09.0?

If the message bothers you, you will no doubt need to adjust the PCI
resources (IRQ assignments) as set up by your motherboard BIOS. Consider
the possibility you will need to update your motherboard BIOS.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Gabor Z. Papp
Sent: Wednesday, June 22, 2005 12:59 AM
To: linux-scsi@vger.kernel.org
Subject: aacraid (adaptec 2120S) and kernel msg

Is this

PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0

repeated kernel message okay for so many times?

Linux version 2.4.31 (root@gzp) (gcc version 3.4.3) #1 Tue Jun 7
18:53:06 CEST 2005
[...]
SCSI subsystem driver Revision: 1.00
Red Hat/Adaptec aacraid driver (1.1-3 Jun  7 2005 18:53:28)
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
AAC0: kernel 4.2.4 build 7349
AAC0: monitor 4.2.4 build 7349
AAC0: bios 4.2.0 build 7349
AAC0: serial bad0fafaf001
AAC0: Non-DASD support enabled
spurious 8259A interrupt: IRQ7.
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0
scsi0 : aacraid
  Vendor: ADAPTEC   Model: Adaptec Mirror    Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02

lspci not very informative about the card:

03:0d.0 RAID bus controller: Adaptec AAC-RAID (rev 01)

Its an Adaptec 2120S pci raid controller.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
