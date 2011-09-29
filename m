From: yxlraid@gmail.com
Subject: [PATCH 2/8] [SCSI] mvsas: add support for 9480 device id
Date: Thu, 29 Sep 2011 00:33:24 -0700
Message-ID: <4e834c7f.6539440a.62a1.fffffe8b@mx.google.com>
References: <mvsas>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- Add support for Marvell 88SE9480 SAS/SATA HBA

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 4e9af66..2bbf43c 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -707,6 +707,15 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 	{ PCI_VDEVICE(TTI, 0x2760), chip_9480 },
 	{
 		.vendor		= 0x1b4b,
+		.device		= 0x9480,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x9480,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9480,
+	},
+	{
+		.vendor		= 0x1b4b,
 		.device		= 0x9445,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= 0x9480,
-- 
1.7.4.4
