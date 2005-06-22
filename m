From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: aacraid (adaptec 2120S) and kernel msg
Date: Wed, 22 Jun 2005 06:58:57 +0200
Message-ID: <x6oe9zxa0e@gzp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from odpn1.odpn.net ([212.40.96.53]:14540 "EHLO odpn1.odpn.net")
	by vger.kernel.org with ESMTP id S261296AbVFVE67 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 00:58:59 -0400
Received: from 48.119-182-adsl-pool.axelero.hu [81.182.119.48]
	by odpn1.odpn.net for linux-scsi@vger.kernel.org
	id 1DkxKE-00023F-P4; Wed, 22 Jun 2005 06:58:58 +0200
Received: from gzp1.gzp.hu [192.168.192.1]
	by gzp1.gzp.hu for linux-scsi@vger.kernel.org
	id 1DkxKE-0000D1-K2; Wed, 22 Jun 2005 06:58:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Is this

PCI: Found IRQ 4 for device 03:0d.0
PCI: Sharing IRQ 4 with 03:09.0

repeated kernel message okay for so many times?

Linux version 2.4.31 (root@gzp) (gcc version 3.4.3) #1 Tue Jun 7 18:53:06 CEST 2005
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
