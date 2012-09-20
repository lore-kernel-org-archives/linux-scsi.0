From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/2] hpsa: gen8plus Smart Array IDs
Date: Thu, 20 Sep 2012 16:05:18 -0500
Message-ID: <20120920210518.GA30921@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com
List-Id: linux-scsi@vger.kernel.org


hpsa: add PCI ID's for next gen Smart Array

From: Mike Miller <mike.miller@hp.com>

No marketing names yet available for the next generation of Smart Array.
---
 drivers/scsi/hpsa.c     |   18 ++++++++++++++++++
 include/linux/pci_ids.h |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 796482b..edc598b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -99,6 +99,15 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1924},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1925},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334d},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -125,6 +134,15 @@ static struct board_type products[] = {
 	{0x3354103C, "Smart Array", &SA5_access},
 	{0x3355103C, "Smart Array", &SA5_access},
 	{0x3356103C, "Smart Array", &SA5_access},
+	{0x1920103C, "Smart Array", &SA5_access},
+	{0x1921103C, "Smart Array", &SA5_access},
+	{0x1922103C, "Smart Array", &SA5_access},
+	{0x1923103C, "Smart Array", &SA5_access},
+	{0x1924103C, "Smart Array", &SA5_access},
+	{0x1925103C, "Smart Array", &SA5_access},
+	{0x1926103C, "Smart Array", &SA5_access},
+	{0x1928103C, "Smart Array", &SA5_access},
+	{0x334d103C, "Smart Array", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6b4565c..416db39 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -753,6 +753,7 @@
 #define PCI_DEVICE_ID_HP_CISSD		0x3238
 #define PCI_DEVICE_ID_HP_CISSE		0x323a
 #define PCI_DEVICE_ID_HP_CISSF		0x323b
+#define PCI_DEVICE_ID_HP_CISSH		0x323c
 #define PCI_DEVICE_ID_HP_ZX2_IOC	0x4031
 
 #define PCI_VENDOR_ID_PCTECH		0x1042
