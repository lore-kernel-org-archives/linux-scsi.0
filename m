From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 4/8] cciss: e500 SSID fix
Date: Wed, 1 Nov 2006 15:58:28 -0600
Message-ID: <20061101215828.GD29928@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:19662 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S1752499AbWKAV6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2006 16:58:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


PATCH 4/8

The patch changes the SSID on the E500 as a workaround for a firmware bug. It
looks like the original patch was backed out between rc2 and rc4.
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
------------------------------------------------------------------------------------------
diff -urNp linux-2.6-p00003/drivers/block/cciss.c linux-2.6/drivers/block/cciss.c
--- linux-2.6-p00003/drivers/block/cciss.c	2006-10-31 15:05:49.000000000 -0600
+++ linux-2.6/drivers/block/cciss.c	2006-10-31 15:20:25.000000000 -0600
@@ -82,7 +82,7 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3213},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3214},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3233},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -114,7 +114,7 @@ static struct board_type products[] = {
 	{0x3213103C, "Smart Array E200i", &SA5_access, 120},
 	{0x3214103C, "Smart Array E200i", &SA5_access, 120},
 	{0x3215103C, "Smart Array E200i", &SA5_access, 120},
-	{0x3233103C, "Smart Array E500", &SA5_access, 512},
+	{0x3237103C, "Smart Array E500", &SA5_access, 512},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access, 120},
 };
 
