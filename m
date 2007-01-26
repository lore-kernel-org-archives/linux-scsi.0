From: Greg KH <greg@kroah.com>
Subject: [PATCH] remove duplicate device id from IPR driver
Date: Thu, 25 Jan 2007 18:15:03 -0800
Message-ID: <20070126021503.GB3444@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:57155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030709AbXAZCQF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jan 2007 21:16:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This patch removes a duplicate device id from the IPR driver.  Based on
the ipr.h file, I'm not so sure this was intended to be a duplicate, and
if so, the .h file should be modified to use the proper sub-device id
instead.

This was pointed out to me by Kay Sievers <kay.sievers@suse.de>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ipr.c |    3 ---
 1 file changed, 3 deletions(-)

--- gregkh-2.6.orig/drivers/scsi/ipr.c
+++ gregkh-2.6/drivers/scsi/ipr.c
@@ -7558,9 +7558,6 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B8,
-	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7,
 	      0, 0, (kernel_ulong_t)&ipr_chip_cfg[0] },
