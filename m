From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/2] wd719x: Remove last declaration using DEFINE_PCI_DEVICE_TABLE
Date: Wed, 31 Aug 2016 09:19:28 -0700
Message-ID: <95c5e4100c3cd4eda643624f5b70e8d7abceb86c.1472660229.git.joe@perches.com>
References: <cover.1472660229.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1472660229.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert it to the preferred const struct pci_device_id instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/wd719x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index e3da1a2..2a9da2e 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -962,7 +962,7 @@ static void wd719x_pci_remove(struct pci_dev *pdev)
 	scsi_host_put(sh);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(wd719x_pci_table) = {
+static const struct pci_device_id wd719x_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_WD, 0x3296) },
 	{}
 };
-- 
2.10.0.rc2.1.gb2aa91d
