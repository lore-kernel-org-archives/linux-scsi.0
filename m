From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: [PATCH][SCSI] mvsas: Add support for HighPoint RR27xx series HBA
Date: Wed, 23 Feb 2011 16:28:44 +0800
Message-ID: <201102231628.44678.linux@highpoint-tech.com>
References: <200902121128.31303.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <200902121128.31303.linux@highpoint-tech.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch is to add support for HighPoint RR27xx SAS/SATA HBA which is based on Marvell 88SE9480 chipset.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>

 drivers/scsi/mvsas/mv_init.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -urN linux-2.6.37.orig/drivers/scsi/mvsas/mv_init.c linux-2.6.37/drivers/scsi/mvsas/mv_init.c
--- linux-2.6.37.orig/drivers/scsi/mvsas/mv_init.c	2011-02-11 08:10:46.000000000 -0500
+++ linux-2.6.37/drivers/scsi/mvsas/mv_init.c	2011-02-11 10:47:01.000000000 -0500
@@ -663,6 +663,13 @@
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2722), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2740), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2744), chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2760), chip_9480 },
 
 	{ }	/* terminate list */
 };
