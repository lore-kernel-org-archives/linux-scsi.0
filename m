From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 16/30] hpsa: add pci ids for storageworks 1210m, remove p400,
	p800, p700m
Date: Thu, 04 Feb 2010 08:42:45 -0600
Message-ID: <20100204144245.10406.74795.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Miller <mikem@beardog.cce.hp.com>

hpsa: add pci ids for StorageWorks 1210m, remove p400, p800, p700m
and update pci_ids.h to include new PCI ID for StorageWorks 1210m variant.

Signed-off-by: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e518766..46055e2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -77,9 +77,6 @@ MODULE_PARM_DESC(hpsa_allow_any,
 
 /* define the PCI info for the cards we can control */
 static const struct pci_device_id hpsa_pci_device_id[] = {
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3223},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3234},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
@@ -87,6 +84,9 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324a},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324b},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
+#define PCI_DEVICE_ID_HP_CISSF 0x333f
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -99,9 +99,6 @@ MODULE_DEVICE_TABLE(pci, hpsa_pci_device_id);
  *  access = Address of the struct of function pointers
  */
 static struct board_type products[] = {
-	{0x3223103C, "Smart Array P800", &SA5_access},
-	{0x3234103C, "Smart Array P400", &SA5_access},
-	{0x323d103c, "Smart Array P700M", &SA5_access},
 	{0x3241103C, "Smart Array P212", &SA5_access},
 	{0x3243103C, "Smart Array P410", &SA5_access},
 	{0x3245103C, "Smart Array P410i", &SA5_access},
@@ -109,6 +106,8 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
+	{0x3233103C, "StorageWorks P1210m", &SA5_access},
+	{0x333F103C, "StorageWorks P1210m", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
