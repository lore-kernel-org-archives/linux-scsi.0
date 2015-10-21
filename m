From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] scsi: wd719x: Remove use of macro DEFINE_PCI_DEVICE_TABLE
Date: Thu, 22 Oct 2015 03:53:27 +0530
Message-ID: <1445466207-23265-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Muhammad Falak R Wani <falakreyaz@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE with
the goal of getting rid of this macro completely, as this macro
is deprecated.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
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
1.9.1
