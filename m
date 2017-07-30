From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 23/29] scsi: fnic: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:13:49 +0530
Message-ID: <1501404235-9105-3-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index aacadbf..b3ab344 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -53,7 +53,7 @@ LIST_HEAD(fnic_list);
 DEFINE_SPINLOCK(fnic_list_lock);
 
 /* Supported devices by fnic module */
-static struct pci_device_id fnic_id_table[] = {
+static const struct pci_device_id fnic_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CISCO, PCI_DEVICE_ID_CISCO_FNIC) },
 	{ 0, }
 };
-- 
2.7.4
