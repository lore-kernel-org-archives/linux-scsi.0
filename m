From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 28/29] scsi: atp870u: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:13:54 +0530
Message-ID: <1501404235-9105-8-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501404235-9105-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35264 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754170AbdG3Iop (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jul 2017 04:44:45 -0400
In-Reply-To: <1501404235-9105-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/atp870u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 8b52a9d..70f1bc4 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1685,7 +1685,7 @@ static struct scsi_host_template atp870u_template = {
      .max_sectors		= ATP870U_MAX_SECTORS,
 };
 
-static struct pci_device_id atp870u_id_table[] = {
+static const struct pci_device_id atp870u_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP885_DEVID)			  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP880_DEVID1)			  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP880_DEVID2)			  },
-- 
2.7.4
