From: Joe Perches <joe@perches.com>
Subject: [TRIVIAL PATCH] block: Correct misuses of 0x%<decimal>
Date: Sun, 02 Aug 2015 13:25:13 -0700
Message-ID: <1438547113.29569.5.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: linux-kernel@vger.kernel.org, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Correct misuse of 0x%d in logging messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/DAC960.c | 4 ++--
 drivers/block/cciss.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 811e11c..d9b32f2 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -2954,7 +2954,7 @@ DAC960_DetectController(struct pci_dev *PCI_Device,
        case DAC960_PD_Controller:
          if (!request_region(Controller->IO_Address, 0x80,
                              Controller->FullModelName)) {
-               DAC960_Error("IO port 0x%d busy for Controller at\n",
+               DAC960_Error("IO port 0x%x busy for Controller at\n",
                             Controller, Controller->IO_Address);
                goto Failure;
          }
@@ -2990,7 +2990,7 @@ DAC960_DetectController(struct pci_dev *PCI_Device,
        case DAC960_P_Controller:
          if (!request_region(Controller->IO_Address, 0x80,
                              Controller->FullModelName)){
-               DAC960_Error("IO port 0x%d busy for Controller at\n",
+               DAC960_Error("IO port 0x%x busy for Controller at\n",
                             Controller, Controller->IO_Address);
                goto Failure;
          }
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0422c47..2758982 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3854,7 +3854,7 @@ static void print_cfg_table(ctlr_info_t *h)
               readl(&(tb->HostWrite.CoalIntDelay)));
        dev_dbg(&h->pdev->dev, "   Coalesce Interrupt Count = 0x%x\n",
               readl(&(tb->HostWrite.CoalIntCount)));
-       dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%d\n",
+       dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%x\n",
               readl(&(tb->CmdsOutMax)));
        dev_dbg(&h->pdev->dev, "   Bus Types = 0x%x\n",
                readl(&(tb->BusTypes)));
