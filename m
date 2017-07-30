From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 24/29] scsi: stex: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:13:50 +0530
Message-ID: <1501404235-9105-4-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501404235-9105-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501404235-9105-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/stex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 9b20643..21d0495 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1491,7 +1491,7 @@ static struct scsi_host_template driver_template = {
 	.this_id			= -1,
 };
 
-static struct pci_device_id stex_pci_tbl[] = {
+static const struct pci_device_id stex_pci_tbl[] = {
 	/* st_shasta */
 	{ 0x105a, 0x8350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		st_shasta }, /* SuperTrak EX8350/8300/16350/16300 */
-- 
2.7.4
