From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 3/4] hpsa: housekeeping patch for device_id and product arrays
Date: Wed, 4 Sep 2013 15:11:10 -0500
Message-ID: <20130904201110.GC28147@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Patch 3 of 4

From: Mike Miller <mike.miller@hp.com>

This patch does a bit of housekeeping for hpsa. Change lowercase alpha hex
digits to uppercase for consistency within the driver. Also moves the P822se
in the tables to keep controllers of each family grouped together.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d02bdf0..5097e0c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -89,13 +89,14 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324a},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324b},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3350},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3351},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3352},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3353},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334D},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
@@ -107,7 +108,6 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1925},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334d},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1929},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BD},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BE},
@@ -138,12 +138,13 @@ static struct board_type products[] = {
 	{0x3245103C, "Smart Array P410i", &SA5_access},
 	{0x3247103C, "Smart Array P411", &SA5_access},
 	{0x3249103C, "Smart Array P812", &SA5_access},
-	{0x324a103C, "Smart Array P712m", &SA5_access},
-	{0x324b103C, "Smart Array P711m", &SA5_access},
+	{0x324A103C, "Smart Array P712m", &SA5_access},
+	{0x324B103C, "Smart Array P711m", &SA5_access},
 	{0x3350103C, "Smart Array P222", &SA5_access},
 	{0x3351103C, "Smart Array P420", &SA5_access},
 	{0x3352103C, "Smart Array P421", &SA5_access},
 	{0x3353103C, "Smart Array P822", &SA5_access},
+	{0x334D103C, "Smart Array P822se", &SA5_access},
 	{0x3354103C, "Smart Array P420i", &SA5_access},
 	{0x3355103C, "Smart Array P220i", &SA5_access},
 	{0x3356103C, "Smart Array P721m", &SA5_access},
@@ -154,7 +155,6 @@ static struct board_type products[] = {
 	{0x1926103C, "Smart Array P731m", &SA5_access},
 	{0x1928103C, "Smart Array P230i", &SA5_access},
 	{0x1929103C, "Smart Array P530", &SA5_access},
-	{0x334d103C, "Smart Array P822se", &SA5_access},
 	{0x21BD103C, "Smart Array", &SA5_access},
 	{0x21BE103C, "Smart Array", &SA5_access},
 	{0x21BF103C, "Smart Array", &SA5_access},
